function v = im2pivmat(im)
%IM2PIVMAT  Convert an image into a PIVMat structure
%   V = IM2PIVMAT(I) converts the image I into a PIVMat structure V.
%
%   See also LOADVEC, VEC2MAT.

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.00,  Date: 2017/02/27
%   This function is part of the PIVMat Toolbox

% History:
% 2017/02/27: v1.00, first version.


v.w = single(im');   % transpose image (y,x) -> (x,y)
v.x = 1:size(im,2);
v.y = 1:size(im,1);
v.namex='x';   v.namey='y';
v.unitx='au';  v.unity='au';
v.namew='I';   v.unitw='au';
pivmat_ver=ver('pivmat');
v.pivmat_version=pivmat_ver.Version;
v.ysign='Y axis downward';
v.Attributes='undefined';
v.name='undefined';
v.setname='undefined';
v.history={'im2pivmat'};
v.source='image';
