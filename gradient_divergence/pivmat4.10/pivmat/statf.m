function varargout=statf(s,maxorder)
%STATF  Statistics of a vector/scalar field
%   STAT = STATF(F) returns a structure containing some statistics for the
%   scalar field F.
%   [STATX,STATY] = STATF(F) returns two structures, each containing the
%   statistics for the X,Y components of the 2-components vector field F.
%   [STATX,STATY,STATZ] = STATF(F) returns 3 structures, each containing
%   the statistics for the X,Y,Z components of the 3-comp. vector field F.
%   
%   F is a structure (or structure array) of fields as obtained by LOADVEC
%   (vector field) or VEC2SCAL (scalar field).
%   If F is a single field, the statistics are spatial averages. If F is
%   an array of fields, the statistics combine spatial and ensemble averages.
%
%   The output structure STAT (or STATX, STATY, STATZ) contains the
%   following fields:
%     mean, std, rms:    mean, standard deviation and rms.
%     min, max:  minimum and maximum
%     nfields:   number of fields used in the computation
%     n:         number of nonzero elements.
%     zeros:     number of zero elements.
%     mom:       non-centered moments, <s^n>
%     momabs:    non-centered absolute moments, <|s^n|>
%     cmom:      centered moments, <(s-<s>)^n>
%     cmomabs:   centered absolute moments, <|s-<s>|^n>
%     skewness:  normalized 3rd order non-centered moment. (*)
%     flatness:  normalized 4th order non-centered moment. (*)
%     skewnessc: normalized 3rd order centered moment. (*)
%     flatnessc: normalized 4th order centered moment. (*)
%     history:   remind for which field statf has been called.
%
%   In these definitions, the brackets <> denote both spatial and possibly
%   ensemble averages. 
%
%   ... = STATF(F,MAXORDER) specifies the maximum order for the moments.
%   MAXORDER=6 is used by default (although its convergence may not be
%   guaranteed). The 4 quantities (*) are computed only if MAXORDER>2.
%
%   If the fields contain 0 (zero) values, they are considered as
%   erroneous and are not included into the computations.
%
%   Examples:
%      v = loadvec('*.VC7');
%      statrot = statf(vec2scal(filterf(v,1),'rot'));
%      statrot.rms
%
%   See also LOADVEC, VEC2SCAL, HISTF, CORRF, VSF, SPECF.

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.40,  Date: 2013/03/13
%   This function is part of the PIVMat Toolbox


% History:
% 2004/05/27: v1.00, first version.
% 2004/07/28: v1.10, new way to stack the statistics, that fixes the
%                    centered moment bug.
% 2004/07/29: v1.11, Added stat.zeros
% 2005/02/23: v1.12, cosmetics
% 2005/04/22: v1.13, centered or non-centered moments option added.
% 2005/09/05: v1.14, option suppressed: centered and non-centered moments
%                    are always both computed. Option maxorder added.
% 2005/09/15: v1.15, centered and non-centered skewness and flatness.
% 2005/10/13: v1.20, new name statf (fusion of statscal 1.15 and statvec
%                    1.02)
% 2005/10/30: v1.21, field 'history' added.
% 2006/03/10: v1.22, field 'history' is now a cell array
% 2008/03/28: v1.23, field 'nfields' added
% 2009/01/28: v1.24, fields 'min' and 'max' added
% 2010/01/25: v1.25, help text improved
% 2010/10/05: v1.30, construction of f_vect optimized (without reshape);
%                    skew and flat computed only if maxorder>2.
% 2013/03/13: v1.40, works with 3D fields

% error(nargchk(1,2,nargin));

vecmode=isfield(s(1),'vx');   % 1 for vector field, 0 for scalar field

if nargin==1
    maxorder=6;
end

if ~vecmode,
    % First stacks all the data into a single vector
    % (transforms each scalar field into a vector m*n,
    % and concatenates all the vectors for each frame into
    % a single big vector). This simplifies the following computations

    siz = numel(s(1).w);              %  matrix size of each field
    f_vect = zeros(1,siz*numel(s));   %  new v1.30: initialisation
    for i=1:numel(s),
        f_vect((1+(i-1)*siz):(i*siz)) = s(i).w(:);  % new method (v1.30)
    end
    
    % counts zero elements (FM 29/07/2004)
    nze = find(f_vect~=0);
    stat.zeros = length(f_vect)-length(nze);
    
    % removes the zeros from the vector:
    f_vect=f_vect(nze);
    
    % computes the statistics:
    stat.mean = mean(f_vect);
    stat.std = std(f_vect,1);
    stat.rms = sqrt(mean(f_vect.^2));
    stat.n = length(f_vect);
    stat.nfields = length(s);
    stat.min = min(f_vect);
    stat.max = max(f_vect);
    
    for order=1:maxorder,
        % computes the centered moments:
        stat.cmom(order) = mean((f_vect-stat.mean).^order);
        stat.cmomabs(order) = mean(abs(f_vect-stat.mean).^order);
        
        % computes the non-centered moments:
        stat.mom(order) = mean(f_vect.^order);
        stat.momabs(order) = mean(abs(f_vect.^order));
    end;
    
    if maxorder >=3  % new v1.30
        stat.skewness = stat.mom(3)/stat.mom(2)^(3/2);
        stat.flatness = stat.mom(4)/stat.mom(2)^2;
        
        % new v1.15:
        stat.skewnessc = stat.cmom(3)/stat.cmom(2)^(3/2);
        stat.flatnessc = stat.cmom(4)/stat.cmom(2)^2;
    end
    
    % new v1.21, changed v1.22:
    if length(s)>1,
        stat.history = {s(1).history ; ...
            ['[concat fields 1..' num2str(length(s)) ']']; ...
            ['statf(ans, ''' num2str(maxorder) ''')']};
    else
        stat.history = {s.history{:} ['statf(ans, ' num2str(maxorder) ')']}';
    end
    
    varargout(1)={stat};
else
    % if the field is a vector field,
    % calls STATF for each component of the vector field:
    varargout(1) = {statf(vec2scal(s,'ux'),maxorder)};
    varargout(2) = {statf(vec2scal(s,'uy'),maxorder)};
    if isfield(s,'vz')
        varargout(3) = {statf(vec2scal(s,'uz'),maxorder)};
    end
end
