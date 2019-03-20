function sf=shiftf(f,opt)
%SHIFTF  Shift the axis of a vector/scalar field.
%   SF = SHIFTF(F, 'origin') returns the same vector/scalar field(s) with
%   the axis X and Y shifted, so that (X,Y)=(0,0) is redefined according
%   to the option 'origin':
%         - 'bottomleft', 'bl'       (by default)
%         - 'bottomright', 'br'
%         - 'topleft', 'tl'
%         - 'topright', 'tr'
%         - 'center', 'c', 'middle'
%
%   If no output argument, the result is displayed by SHOWF.
%
%   Example:
%      v = shiftf(loadvec('*.vc7'),'center');
%      showf(v);
%
%   See also SETORIGINF, TRUNCF, FLIPF, EXTRACTF, ROTATEF, CHANGEFIELDF


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.11,  Date: 2012/05/02
%   This function is part of the PIVMat Toolbox


% History:
% 2005/10/21: v1.00, first version.
% 2006/07/13: v1.01, 'center' instead of 'c'
% 2006/07/21: v1.10, new options 'bottomleft', 'topright' etc.
% 2012:05/02: v1.11, help text improved

% error(nargchk(1,2,nargin));

if (ischar(f) || iscellstr(f) || isnumeric(f))
    f=loadvec(f);
end 

if nargin==1,
    opt='bottomleft';
end

sf=f;  % output (shifted) field

for i=1:length(f)
    switch lower(opt)
        case {'center','c','middle'}
            sf(i).x = sf(i).x-(sf(i).x(1)+sf(i).x(end))/2;
            sf(i).y = sf(i).y-(sf(i).y(1)+sf(i).y(end))/2;
        case {'bottomleft','bl'}
            sf(i).x = sf(i).x-sf(i).x(1);
            sf(i).y = sf(i).y-sf(i).y(1);
        case {'bottomright','br'}
            sf(i).x = sf(i).x-sf(i).x(end);
            sf(i).y = sf(i).y-sf(i).y(1);
        case {'topleft','tl'}
            sf(i).x = sf(i).x-sf(i).x(1);
            sf(i).y = sf(i).y-sf(i).y(end);
        case {'topright','tr'}
            sf(i).x = sf(i).x-sf(i).x(end);
            sf(i).y = sf(i).y-sf(i).y(end);            
    end
    sf(i).history = {f(i).history{:} ['shiftf(ans, ''' opt ''')']}';
end

if nargout==0
    showf(sf);
    clear sf
end
