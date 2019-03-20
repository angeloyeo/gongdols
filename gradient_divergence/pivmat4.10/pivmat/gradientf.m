function v = gradientf(s)
%GRADIENTF  Gradient of scalar field
%   V = GRADIENTF(S) returns the gradient of the scalar field(s) S.  S is a
%   structure (or a structure array) that can be obtained by VEC2SCAL.
%
%   Example:
%     showf(gradientf(vec2scal(v,'norm')));
%
%   See also VEC2SCAL.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.10,  Date: 2007/04/25
%   This function is part of the PIVMat Toolbox


% History:
% 2006/07/13: v1.00, first version.
% 2007/04/25: v1.10, bug fixed (transposed gradient)


% error(nargchk(1,1,nargin));

% v is idem as s, except for those fields which are removed:
v = rmfield(s, {'w', 'unitw','namew'});

for i=1:length(s)
    [gx gy] = gradient(s(i).w' , s(i).x, s(i).y);
    v(i).vx = gx';
    v(i).vy = gy';    
    v(i).namevx = ['\partial_x (' s(i).namew ')'];
    v(i).namevy = ['\partial_y (' s(i).namew ')'];
    v(i).unitvx = [s(i).unitw '/' s(i).unitx];
    v(i).unitvy = [s(i).unitw '/' s(i).unity];
    v(i).history = {s(i).history{:} 'gradientf(ans)'}';
end

if nargout==0
    showf(v);
    clear s
end
