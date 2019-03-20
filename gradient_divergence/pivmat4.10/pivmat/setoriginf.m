function sf=setoriginf(f,P0)
%SETORIGINF  Set the origin (0,0) of vector/scalar fields.
%   SF = SETORIGINF(F, [X,Y]) returns the same vector/scalar field(s)
%   with the origin (0,0) redefined at the new point (X,Y).
%   (X,Y) do not need to be inside the field.
%
%   If no output argument, the result is displayed by SHOWF.
%
%   Example:
%      v = setoriginf(loadvec('*.vc7'), [12.8, -20]);
%      showf(v);
%
%   See also SHIFTF, TRUNCF, FLIPF, EXTRACTF, ROTATEF, CHANGEFIELDF


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.00,  Date: 2012/05/02
%   This function is part of the PIVMat Toolbox


% History:
% 2012/05/02: v1.00, first version.


% error(nargchk(1,2,nargin));

if (ischar(f) || iscellstr(f) || isnumeric(f))
    f=loadvec(f);
end 

sf=f;  % output field

for i=1:length(f)
   sf(i).x = sf(i).x - P0(1);
   sf(i).y = sf(i).y - P0(2);
end

if nargout==0
    showf(sf);
    clear sf
end
