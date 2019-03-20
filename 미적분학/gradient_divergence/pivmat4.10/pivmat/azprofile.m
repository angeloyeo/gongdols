function varargout = azprofile(f,X0,Y0,R,NA)
%AZAVERF  Azimuthal average a vector/scalar field.
%   [A, P] = AZPROFILE(S, X0, Y0, R), where S is a scalar field, returns the
%   azimuthal profile of S taken along a circle of radius R centered on
%   (X0, Y0) (given in physical units). A is the sampling angle array
%   (between 0 and 2*pi) and P is the profile array sampled over the
%   points (X, Y) = (X0+R*COS(A), Y0+R*SIN(A)).
%
%   [A, UR, UT] = AZPROFILE(V, X0, Y0, R), where V is a 2-component vector
%   field, returns the radial UR and azimuthal UT components of the
%   azimuthal profiles of V.
%
%   [A, UR, UT, UZ] = AZPROFILE(V, X0, Y0, R), where V is a 3-component
%   vector field, returns the radial UR, azimuthal UT, and out-of-plane UZ,
%   components of the azimuthal profiles of V.
%
%   The center (X0, Y0) does not need to be inside the field. If X0 and Y0
%   are not specified, the point (0,0) is taken (in physical units).
%
%   ... = AZAVERF(.., NA) specifies the length of the output arrays (if not
%   specifed, a default length is choosen).
%
%   Examples:
%      v = loadvec('*.vc7');
%      [angle, ur, utheta] = azprofile(v, 0, 0, 40);
%      plot(angle, ur, 'r-', angle, utheta, 'b-');
%      xlabel('angle (rad)');  ylabel('u_r,  u_\theta  (m/s)');
%
%   See also SHOWF, AZAVERF, AVERF, SPAVERF, SUBAVERF, FILTERF,
%   VEC2SCAL, ROTATEF, SUBSBR


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.01,  Date: 2016/07/13
%   This function is part of the PIVMat Toolbox


% History:
% 2016/04/08: v1.00, first version.
% 2016/07/13: v1.01, bug fixed for argument NA


%error(nargchk(4,inf,nargin));

if (ischar(f) || iscellstr(f) || isnumeric(f))
    f = loadvec(f);
end

vecmode = isfield(f(1),'vx');   % 1 for vector field, 0 for scalar field

if ~exist('NA','var')  % fixed v1.01
    NA = round( 4*R / abs(f.x(2)-f.x(1)));  % default number of angle values
end

A = linspace(0, 2*pi, NA+1);  A = A(1:NA);
X = X0 + R*cos(A);
Y = Y0 + R*sin(A);

if ~vecmode
    P = interp2(f.x, f.y, f.w', X, Y);
else
    UX = interp2(f.x, f.y, f.vx', X, Y);
    UY = interp2(f.x, f.y, f.vy', X, Y);
    
    UR =  UX.*cos(A) + UY.*sin(A);
    UT = -UX.*sin(A) + UY.*cos(A);
    
    if isfield(f,'vz')
        UZ = interp2(f.x, f.y, f.vz', X, Y);
    end
end


% output
varargout{1} = A;
if vecmode
    varargout{2} = UR;
    varargout{3} = UT;    
    if isfield(f,'vz')
        varargout{4} = UZ;
    end
else
    varargout{2} = P;
end


