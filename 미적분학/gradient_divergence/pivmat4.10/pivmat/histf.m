function varargout=histf(s,bin,opt)
%HISTF  Histogram of a vector/scalar field
%   H = HISTF(F) computes the histogram H of the field(s) F into 100
%   equally spaced bin. The appropriate range of bins is estimated from the
%   rms of the first field.
%
%   H = HISTF(F,BIN) computes the histograms among the bins specified by
%   the vector BIN.  BIN can be in the form LINSPACE(-X,X,N).
%
%   If F is a 2-components vector field, use [HX, HY] = HISTF(F,..) to
%   compute the histogram for each component of the vector field.
%   Similarly, if F is a 3-components vector field, use
%   [HX, HY, HZ] = HISTF(F,..)
%
%   [...,BIN] = HISTF(...) also returns the bins vector BIN used for the
%   computation of the histogram. This is useful if BIN is estimated by
%   HISTF itself.
%
%   By default, HISTF considers the values 0 as erroneous, and does not
%   include them in the histogram. If however the values 0 are to be
%   included, specify HISTF(...,'0');
%
%   Example:
%      v = loadvec('*.vc7');
%      [h,w] = histf(vec2scal(v,'rot'));
%      semilogy(w,h,'ro-');
%
%   See also HISTSCAL_DISP, STATF, CORRF, SSF, VSF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.31,  Date: 2016/10/21
%   This function is part of the PIVMat Toolbox


% History:
% 2004/04/21: v1.00, first version.
% 2004/07/29: v1.10, new way to stack the statistics, more efficient
% 2005/04/22: v1.11, cosmetics
% 2005/09/03: v1.12, BIN is an optional argument; arg check added.
% 2005/10/13: v1.20, now called HISFT (fusion of HISTSCAL 1.12 and HISTVEC
%                    1.01). Option '0' added.
% 2008/10/20: v1.21, now works with non-double scalar images (IMX/IM7)
% 2013/13/13: v1.30, works with 3d fields
% 2016/10/21: v1.31, new default binning for fields with non-zero mean

%error(nargchk(1,3,nargin));

vecmode=isfield(s(1),'vx');   % 1 for vector field, 0 for scalar field

if ~exist('opt','var'), opt=''; end;

if ~vecmode    
    for i=1:length(s)  % new v1.21
        s(i).w = double(s(i).w);
    end
    
    if nargin==1,
        stat=statf(s(1));
        if stat.mean < stat.std
            bin = linspace(-20*stat.std, 20*stat.std, 200);
        else   % new v1.31
            bin = linspace(stat.mean-20*stat.std, stat.mean+20*stat.std, 200);
        end
    end;
    
    % length of the vector where the scalar matrix is reshaped:
    veclen = numel(s(1).w);
    
    % initialization of the vector (to save time):
    f_vect=zeros(1,veclen*length(s));
    
    % stacks all the data into a single vector:
    for i=1:length(s),
        f_vect( (1+(i-1)*veclen):(i*veclen) ) = reshape(s(i).w,1,veclen);
        % (transforms each scalar field into a vector m*n,
        % and concatenates all the vectors for each frame into
        % a single big vector.
    end;
    
    if findstr(opt,'0'),
        h=hist(f_vect,bin);
    else
        % calcule l'histogramme des elements non nuls du vecteur
        h=hist(f_vect(f_vect~=0),bin);
    end;
    
    varargout(1)={h};
    varargout(2)={bin};
else
    if nargin==1,
        % if no bin specified, computes the bin for the first component and
        % uses the same for the second component:
        if isfield(s,'vz')
            [hx,bin]=histf(vec2scal(s,'ux'));
            hy=histf(vec2scal(s,'uy'),bin,opt);
            if isfield(s,'vz')
                hz=histf(vec2scal(s,'vz'),bin,opt);
            end
        else
            % if a bin is specified, use it for both component:
            hx=histf(vec2scal(s,'ux'),bin,opt);
            hy=histf(vec2scal(s,'uy'),bin,opt);
            if isfield(s,'vz')
                hz=histf(vec2scal(s,'vz'),bin,opt);
            end
        end;
        varargout(1)={hx};
        varargout(2)={hy};
        if isfield(s,'vz')
            varargout(3)={hz};
            varargout(4)={bin};
        else
            varargout(3)={bin};
        end
    end
end
