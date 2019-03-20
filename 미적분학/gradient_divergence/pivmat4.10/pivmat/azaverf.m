function varargout = azaverf(f,x0,y0,varargin)
%AZAVERF  Azimuthal average a vector/scalar field.
%   [R, P] = AZAVERF(S, X0, Y0), where S is a scalar field, returns the
%   azimuthally-averaged profile P(R) of S with respect to the center
%   X0, Y0 (given in physical units). The output vector R is the radius
%   (in physical units), and the vector P is the profile.  If S is an array
%   of N scalar fields, R and P are MxN matrix. Use PLOT(R, P) to plot the
%   resulting profiles.
%
%   [R, UR, UT] = AZAVERF(V, X0, Y0), where V is a 2-component vector field,
%   returns the radial UR and azimuthal UT components of the azimuthally-
%   averaged profiles of V.
%
%   [R, UR, UT, UZ] = AZAVERF(V, X0, Y0), where V is a 3-component vector
%   field, returns the radial UR, azimuthal UT, and out-of-plane UZ,
%   components of the azimuthally- averaged profiles of V.
%
%   The center (X0, Y0) does not need to be inside the field. If X0 and Y0
%   are not specified, the point (0,0) is taken (in physical units).
%
%   AF = AZAVERF(F, X0, Y0), where F is a scalar or a vector field, returns
%   the azimuthally averaged field AF. If F is an array of fields, AF is
%   also an array of fields of same dimension. If no output argument
%   specified, the result is displayed with SHOWF.
%
%   ... = AZAVERF(..,I0, J0, 'mesh') specifies the center (I0, J0) in mesh
%   units instead of physical units (I0 and J0 do not need to be integer,
%   and do not need to be inside the field).
%
%   ... = AZAVERF(.., 'rmax', RMAX) computes the profile for R<=RMAX only.
%   RMAX is given in physical units, unless the argument 'mesh' is
%   specified. This option saves computation time if large R are not
%   needed.
%
%   By default, zero elements are considered as erroneous, and are not used
%   for the computation of the azimuthal average. If however you want to
%   keep them in the computation, specify  AZAVERF(...,'keepzero').
%
%   Examples:
%      v=loadvec('*.vc7');
%      showf(azaverf(v,10,10));
%
%      k=vec2scal(v,'ken');
%      [r,e] = azaverf(k,40,32,'mesh');
%      plot(r,e,'o-');
%      xlabel('r (mm)');  ylabel('energy');
%
%      v=addnoisef(vortex,0.2);
%      showf(v);
%      showf(azaverf(v,64,64));
%
%   See also SHOWF, AVERF, SPAVERF, SUBAVERF, FILTERF,
%   VEC2SCAL, ROTATEF, SUBSBR, AZPROFILE


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.30,  Date: 2013/03/13
%   This function is part of the PIVMat Toolbox


% History:
% 2006/07/19: v1.00, first version.
% 2006/07/21: v1.01, return one profile per field (do not average the fields)
% 2006/07/26: v1.02, does not return the leading zeros of the profiles
% 2006/07/28: v1.10, zero elements are considered as erroneous, and are not
%                    included. accepts filenames for input arguments.
% 2009/03/16: v1.20, new option RMAX
% 2009/04/20: v1.21, bug fixed with RMAX
% 2013/03/13: v1.30, doc changed for 3d fields


%error(nargchk(1,inf,nargin));

if (ischar(f) || iscellstr(f) || isnumeric(f))
    f = loadvec(f);
end

if nargin==1
    x0=0;       % center by default (in phys. units)
    y0=0;
end

vecmode = isfield(f(1),'vx');   % 1 for vector field, 0 for scalar field

if length(f)>1  % if an array of field is given as input argument
    if nargout<=1
        for n=1:length(f)
            af(n) = azaverf(f(n),x0,y0,varargin{:});  % run azaverf for each field
        end
        if nargout==0
            showf(af);
        else
            varargout{1}=af;
        end
    elseif nargout==2     % scalar field
        for n=1:length(f)
            [rn,pn] = azaverf(f(n),x0,y0,varargin{:});  % run azaverf for each field
            r(:,n)=rn;
            p(:,n)=pn;
        end
        varargout{1} = r;
        varargout{2} = p;
    elseif nargout==3    % vector field
        for n=1:length(f)
            [rn,urn,utn] = azaverf(f(n),x0,y0,varargin{:});  % run azaverf for each field
            r(:,n)=rn;
            ur(:,n)=urn;
            ut(:,n)=utn;
        end
        varargout{1} = r;
        varargout{2} = ur;
        varargout{3} = ut;
    elseif nargout==4    % 3D vector field
        for n=1:length(f)
            [rn,urn,utn,uzn] = azaverf(f(n),x0,y0,varargin{:});  % run azaverf for each field
            r(:,n)=rn;
            ur(:,n)=urn;
            ut(:,n)=utn;
            uz(:,n)=uzn;
        end
        varargout{1} = r;
        varargout{2} = ur;
        varargout{3} = ut;
        varargout{3} = uz;
    end
    return
end

%new v1.20
rmax = inf;
if any(strncmpi(varargin,'rmax',2))
    try
        rmax = varargin{1+find(strncmpi(varargin,'rmax',2),1,'last')};
    end
end

scale=abs(f.x(2)-f.x(1));  % phys<->mesh conversion factor (assumed to be equal for x and y)

if any(strncmpi(varargin,'mesh',1))
    i0 = x0;    % if the center has been specified directly in mesh units
    j0 = y0;
    rmaxmesh = rmax;
else
    i0 = 1 + (x0 - f.x(1))/scale;  % otherwise, find the center in mesh units (not necessarily integer)
    j0 = 1 + (y0 - f.y(1))/scale;
    rmaxmesh = rmax/scale;
end



% in the following, work only with a single field F
nx=length(f.x);
ny=length(f.y);

maxi = max([nx, nx+1-i0, i0]);  % largest distance along x (in mesh units)
maxj = max([ny, ny+1-j0, j0]);  % largest distance along y (in mesh units)
maxdist = ceil(sqrt(maxi^2+maxj^2));   % largest distance = diagonal (it is over-estimated, but it will be truncated after the computation)
r = (0:maxdist-1)*scale;     % output radial position for profiles (in phys units)

% initialisations:
numpt = zeros(1,maxdist);  % number of points in each bin
if vecmode
    ur = zeros(1,maxdist); % radial component
    ut = zeros(1,maxdist); % azimuthal component
    if isfield(f,'vz')
        uz = zeros(1,maxdist);
    end
else
    p = zeros(1,maxdist);  % scalar profile
end


% main computation:
delta = ceil(rmaxmesh/sqrt(2));
rangei = max(1,floor(i0-delta)):min(nx,ceil(i0+delta));
rangej = max(1,floor(j0-delta)):min(ny,ceil(j0+delta));
for i=rangei
    for j=rangej
        distreal = sqrt((i-i0)^2+(j-j0)^2);  % distance from the center, in mesh units
        dist = floor(1+distreal);   % index for profile (dist = 1 for distreal=0)
        if dist<=maxdist
            if vecmode
                if distreal>0
                    if ((f.vx(i,j) && f.vy(i,j)) || any(strncmpi(varargin,'keepzero',5)))  % works only for nonzero elements (new v1.10)
                        numpt(dist) = numpt(dist) + 1; % number of points in the bin #dist
                        ur(dist) = ur(dist) + f.vx(i,j)*(i-i0)/distreal + f.vy(i,j)*(j-j0)/distreal;
                        ut(dist) = ut(dist) - f.vx(i,j)*(j-j0)/distreal + f.vy(i,j)*(i-i0)/distreal;
                        if isfield(f,'vz')
                            uz(dist) = uz(dist) + f.vz(i,j);
                        end
                    end
                else
                    ur(dist) = 0;  % vector projection impossible at the center
                    ut(dist) = 0;
                    if isfield(f,'vz')
                        uz(dist) = 0;
                    end
                end
            else
                if (f.w(i,j) || any(strncmpi(varargin,'keepzero',5)))  % works only for nonzero elements (new v1.10)
                    numpt(dist) = numpt(dist) + 1; % number of points in the bin #dist
                    p(dist)= p(dist) + f.w(i,j);
                end
            end
        end
    end
end

% upper truncation (don't keep the ending empty bins)
nonzeropt=find(numpt);
firstpt=nonzeropt(1); % first non-zero point
lastpt=nonzeropt(end); % last non-zero point
numpt=numpt(1:lastpt);  % (no truncation between 1 and firstpt)
r=r(1:lastpt);
if vecmode
    ur=ur(1:lastpt);
    ut=ut(1:lastpt);
    if isfield(f,'vz')
        uz=uz(1:lastpt);
    end
else
    p=p(1:lastpt);
end

% normalise (i.e.: divide the profile by the number of points in each bin):
for pt=firstpt:lastpt   % changed v1.10 (to avoid division by 0)
    if numpt(pt)
        if vecmode
            ur(pt) = ur(pt)/numpt(pt);
            ut(pt) = ut(pt)/numpt(pt);
            if isfield(f,'vz')
                uz(pt) = uz(pt)/numpt(pt);
            end
        else
            p(pt) = p(pt)/numpt(pt);
        end
    end
end



% output
if nargout<=1   % output = vector/scalar field
    af=f;
    for i=1:nx
        for j=1:ny
            distreal = sqrt((i-i0)^2+(j-j0)^2);
            dist = floor(1+distreal);   % dist = 1 for distreal=0
            if dist<=lastpt
                if vecmode
                    if distreal>0
                        af.vx(i,j) = ur(dist)*(i-i0)/distreal - ut(dist)*(j-j0)/distreal;
                        af.vy(i,j) = ur(dist)*(j-j0)/distreal + ut(dist)*(i-i0)/distreal;
                        if isfield(af,'vz')
                            af.vz(i,j) = uz(dist);
                        end
                    else
                        af.vx(i,j) = 0;
                        af.vy(i,j) = 0;
                        if isfield(af,'vz')
                            af.vz(i,j) = 0;
                        end
                    end
                else
                    af.w(i,j) = p(dist);
                end
            else
                if vecmode
                    af.vx(i,j)=0;
                    af.vy(i,j)=0;
                    if isfield(af,'vz')
                        af.vz(i,j) = 0;
                    end
                else
                    af.w(i,j)=0;
                end
            end
        end
    end
    af.history = {f.history{:} ['azaverf(ans, ' num2str(x0) ', ' num2str(y0) ', ' varargin{:} ')']}';
    if vecmode
        af.namevx = ['< ' f.namevx '>_{\theta}'];
        af.namevy = ['< ' f.namevy '>_{\theta}'];
        if isfield(f,'vz')
            af.namevz = ['< ' f.namevz '>_{\theta}'];
        end
            
    else
        af.namew = ['< ' f.namew '>_{\theta}'];
    end
    if nargout==1
        varargout{1} = af;
    elseif nargout==0
        showf(af);
    end
else            % output = profiles
    varargout{1} = r(firstpt:end);
    if vecmode
        varargout{2} = ur(firstpt:end);
        if findstr(lower(f(1).ysign),'up')
            varargout{3} = ut(firstpt:end);
        else
            varargout{3} = -ut(firstpt:end);  % inverse the azimuthal component for fields with Y-axis downward
        end
        if isfield(f,'vz')
            varargout{4} = uz(firstpt:end);
        end
    else
        varargout{2}=p(firstpt:end);
    end
end

