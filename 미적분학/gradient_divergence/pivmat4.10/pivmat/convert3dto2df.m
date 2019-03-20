function vv = convert3dto2df(v)
%CONVERT3DTO2DF  Convert 3D vector fields to 2D vector fields
%   V2 = CONVERT3DTO2DF(V3) converts 3-components vector fields V3 (e.g.,
%   from stereo-PIV) to  2-components vector fields V2. This simply removes
%   from V3 the variable vz and the all associated info (units, names...)
%
%   Example:
%      v = loadvec('*.vc7');
%      showf(convert3dto2df(v),'norm');
%
%   See also LOADVEC, SHOWF


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.00,  Date: 2013/03/13
%   This function is part of the PIVMat Toolbox


% History:
% 2013/03/13: v1.00, first version.

%error(nargchk(1,1,nargin));

for i=1:numel(v)
    vv(i) = rmfield(v(i), {'vz','unitvz','namevz'});
    vv(i).history = {{v(i).history}' 'convert3dto2df(ans)'}';
end
