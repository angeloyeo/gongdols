function v=vortex(n,r0,vorticity,mode,diver)
%VORTEX  Vector field of a centered vortex.
%   V = VORTEX returns a 128x128 vector field containing at the center a
%   Burger's vortex (Gaussian vorticity distribution) of radius 8 mm and
%   vorticity 1 s^-1.  V is a standard PIVMat structure, which can be
%   displayed using SHOWF.
%
%   V = VORTEX(N,R,W) returns a N*N vector field containing a vortex of
%   radius R (in mm) and vorticity W (in s^-1).
%
%   V = VORTEX(...,MODE) specifies the vorticity distribution shape:
%   'burgers' (by default) or 'rankine' (top-hat vorticity). For the
%   'burgers' mode, a divergence may also be specified by V =
%   VORTEX(...,'burgers',D), with D (in s^-1) of order of W (D=W by
%   default).
%
%   Example:  showf(vortex(256));
%
%   See also SHOWF, MULTIVORTEX, RANDVEC.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.20,  Date: 2010/04/15
%   This function is part of the PIVMat Toolbox


% History:
% 2004/06/03: v1.00, first version.
% 2005/09/05: v1.01, cosmetics.
% 2005/09/15: v1.02, name and setname fields added.
% 2005/10/21: v1.10, field ysign added. Divergence field added.
% 2006/05/26: v1.11, bug fixed for field 'history'
% 2010/04/15: v1.20, "false" zero instead of 0 (otherwise interpreted as a
%                    wrong vector by showf)


if ~exist('n','var'), n=128; end
if ~exist('r0','var'), r0=10; end
if ~exist('vorticity','var'), vorticity=1; end
if ~exist('mode','var'), mode='burgers'; end
if ~exist('diver','var'), diver=vorticity; end

mid=n/2+1;
omega=vorticity/(2*1000); % angular velocity, in m/s/mm;
gamma=diver/(2*1000); % divergence, in m/s/mm;
for i=1:n
    for j=1:n
        radius=sqrt((i-mid)^2+(j-mid)^2);
        if findstr(lower(mode),'rankine')
            if radius<=r0
                v.vx(i,j)=omega*(j-mid);
                v.vy(i,j)=-omega*(i-mid);
            else
                v.vx(i,j)=omega*r0^2*(j-mid)/radius^2;
                v.vy(i,j)=-omega*r0^2*(i-mid)/radius^2;
            end
        elseif findstr(lower(mode),'burgers')
            if radius==0
                v.vx(i,j)=0;
                v.vy(i,j)=0;
            else    
                v.vx(i,j)=omega*r0^2*(j-mid)/radius^2*(1-exp(-(radius/r0)^2));
                v.vy(i,j)=-omega*r0^2*(i-mid)/radius^2*(1-exp(-(radius/r0)^2));
                
                if gamma
                    v.vx(i,j) = v.vx(i,j) + gamma*r0^2*(i-mid)/radius^2*(1-exp(-(radius/r0)^2));
                    v.vy(i,j) = v.vy(i,j) + gamma*r0^2*(j-mid)/radius^2*(1-exp(-(radius/r0)^2));
                end
                
            end
        end
    end
end

% new v1.20 : add a small constant value to avoid strictly 0 components
v.vx = v.vx + max(abs(v.vx(:)))*1e-10;
v.vy = v.vy + max(abs(v.vy(:)))*1e-10;

v.x=(1:n)-1;
v.y=(1:n)-1;
v.ysign='Y axis downward'; % new v1.03
v.namex='x';
v.namey='y';
v.namevx='vx';
v.namevy='vy';
v.unitx='mm';
v.unity='mm';
v.unitvx='m/s';
v.unitvy='m/s';
v.history={'vortex'};

v.name='Vortex'; % added v1.02
v.setname='-';
