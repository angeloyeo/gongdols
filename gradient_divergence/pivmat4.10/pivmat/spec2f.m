function sp = spec2f(f,varargin)
%SPECF  2D power spectrum of vector/scalar fields.
%   SP2 = SPEC2F(F) returns a structure SP2 containing the 2D power
%   spectrum of the vector or scalar field(s) F. If F is an array of
%   fields, the average spectrum is returned.
%
%   SP2 = SPEC2F(F,'hann') applies a Hann (or Hanning) apodization window
%   to the fields along each direction in order to reduce aliasing. Note
%   that, in this case, energy is not conserved (the amount of energy
%   lost in the apodization is about 60%, but the exact value depends on
%   the details of the energy distribution).
%
%   The X and Y dimensions of the fields must be even. If one of the
%   dimension is odd, the last column/row is discarded.
%
%   Use the syntax SP2 = SPEC2F(F, ..., 'disp2d'), or SPEC2F(F, ...) without
%   output argument, to also display the 2D spectrum in the plane (kx,ky).
%
%   SPEC2F(F,...,'disp') displays the 1D (azimuthally-averaged) power
%   spectrum.
%
%   SPEC2F(F,...,'Property1','Property2',...) specifies the following
%   properties: 
%     'circle '    also displays circles (to test the isotropy of 2D power spectra).
%     'contour'    displays iso-contour of the spectrum
%     'contourf'   displays filled iso-contours of spectrum
%     'linear'     displays the spectrum in linear scale (log by default)
%
%   After the property 'contour' or 'contourf', it is possible to specify
%   the logarithmic step between each countour line. Default step is 1,
%   i.e. the contour lines are speced by a factor of 10. 
%
%   SPEC2F(SP) displays the spectrum, where SP has been previously computed
%   using SP2 = SPEC2F(...). If SP2 is a structure array, loops over all spectra
%   (press a key between each display).
%
%   For vector field(s), the structure SP contains:
%       kx,ky:    wavenumbers along x and y
%       ex:       2D power spectrum of F_x
%       ey:       2D power spectrum of F_y
%       ez:       2D power spectrum of F_z (for 3-component fields only)
%       e:        2D power spectrum (sum of the p.s. of F_x, F_y, and F_z)
%       ep:       1D azimuthally averaged power spectrum 
%       k:        wavenumber
%       unitk:    unit of wavenumber
%       unite:    unit of power spectrum (energy density)
%       appod:    Apodization window ('Hann' or 'None')
%       nfields:  number of fields used in the computation
%       history:  remind from which field specf has been called.
%
%   For scalar field(s), the structure SP contains:
%       kx,ky:    wavenumbers along x and y
%       e:        2D power spectrum
%       k:        wavenumber
%       ep:       1D azimuthally averaged power spectrum
%       unitk:    unit of wavenumber
%       unite:    unit of power spectrum (energy density)
%       appod, nfields, history: idem as for vector fields
%
%   The unit for the wavenumber is the inverse of the unit for the spatial
%   scale (e.g. in 1/mm). The length of the spectrum is half the length of
%   the field. Some properties:
%     sp2.k(1) is always 0 (zero mode = mean component of the field)
%     sp2.k(2) is the wavenumber increment, Delta k = 2*pi/L, where L is the
%                size of the field.
%     sp2.k(end) is pi/dx, where dx is the mesh size of the field.
%
%   The unit for the spectra is given by the unit of
%   the input field squared, times the unit of scale.  For instance, for a
%   velocity field given in m/s with spatial scale in mm, the unit for the
%   spectra is (m^2/s^2)*mm, i.e. (m^3/s^2)/1000.
%
%   Example:
%      v=loadvec('*');
%      sp2=spec2f(truncf(v),'hann');
%      spec2f(sp2,'disp2d');
%
%   Energy Conservation (Parseval theorem)
%
%   For a scalar field, energy conservation requires that
%     SUM(SP2.EX(:))*SP2.KX(2) = SUM(SP.EY(:))*SP.KY(2) = MEAN(F.W(:).^2)
%   and, if the field is square with equal scales along X and Y:
%     SUM(SP2.E(:))*SP.K(2) = MEAN(F.W(:).^2)
%
%   Relations between 1D and 2D spectra:
%   Two ways of computing the 1D spectrum along x of u_x:
%      v = loadvec('*');
%      u = vec2scal(v,'ux');     
%      sp = specf(u);              % 1D spectrum of u_x
%      sp2 = spec2f(u);            % 2D spectrum of u_y
%      int_spx = sum(sp2.e,1);     % sum of the 2D spec. along x
%      loglog(sp.k, sp.ex, 'ro', sp2.k, 2*int_spx(end/2+1:end), 'b');
%
%   See also SPECF, STATF, VSF, SSF, TRUNCF, CORRF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 2.10, Date: 2013/03/14
%   This function is part of the PIVMat Toolbox


% History:
% 2004/05/24: v1.00, first version.
% 2005/02/24: v1.01, cosmetics
% 2005/02/28: v1.10, bug fixed for the average of spectra+computes the theta-averaged spectrum.
% 2005/03/02, v1.20, bug fixed with 2D apodization.
% 2006/07/17, v1.21, variable names changed, for display with showf
% 2008/11/11, v2.00, now called 'spec2f', merging of 'spectrum2D' and
%                    'spectrum2D_disp' for inclusion into PIVMat.
% 2013/03/14, v2.10, works with 3D fields

% error(nargchk(1,inf,nargin));

if (ischar(f) || iscellstr(f) || isnumeric(f))
    f = loadvec(f);
end

if isfield(f(1),'kx')  % argument is a spectrum
    sp = f;
elseif isfield(f(1),'vx')  % argument is a vector field
    sp = spectrum2Dvec(f,varargin{:});
elseif isfield(f(1),'w')   % argument is a scalar field
    sp = spectrum2Dscal(f,varargin{:});
else
    error('Unknown input argument.');
end

% parse the logarithmic step for contour lines (1 by default)
step=1;
if any(strncmpi(varargin,'contour',4))
    posarg = find(strncmpi(varargin,'contour',4),1,'last');
    if posarg<(nargin-1)
        step = varargin{1+posarg};
    end
end

if any(strncmpi(varargin,'disp',2)) || nargout==0
    skx = [-sp(1).kx(end) -sp(1).kx(end:-1:2) sp(1).kx];
    sky = [-sp(1).ky(end) -sp(1).ky(end:-1:2) sp(1).ky];
    for i=1:numel(sp)
        if any(strcmpi(varargin,'disp')) || any(strcmpi(varargin,'disp1D'))
            loglog(sp(i).k,sp(i).ep);
            xlabel([sp.namekx '  (' sp(i).unitkx ')']);
            ylabel([sp(i).namee '  (' sp(i).unite ')']);
        elseif any(strcmpi(varargin,'disp2D')) || nargout==0
            if any(strncmpi(varargin,'linear',3))
                e = sp(i).e;
                mine=min(e(:));
                maxe=max(e(:));
            else
                e = log10(sp(i).e);
                mine = floor(min(e(:)));
                maxe = ceil(max(e(:)));
            end          
            if any(strcmpi(varargin,'contourf'))
                contourf(skx,sky,e,mine:step:maxe);
            elseif any(strcmpi(varargin,'contour'))
                contour(skx,sky,e,mine:step:maxe);
            else
                imagesc(skx,sky,e,[mine maxe]);
                axis xy
            end
            axis image
            if any(strncmpi(varargin,'circle',4))
                hold on
                [mskx, msky]=meshgrid(skx,sky);
                mat_isotrope = sqrt(mskx.^2+msky.^2);
                contour(skx, sky, mat_isotrope);
                hold off
            end
            xlabel([sp(i).namekx '  (' sp(i).unitkx ')']);
            ylabel([sp(i).nameky '  (' sp(i).unitky ')']);
            title([sp(i).namee '  (' sp(i).unite ')']);
        end
        if numel(sp)>1 && i<numel(sp)
            pause
        end
    end
end

if nargout==0
    clear sp
end



% ----------------------------------------------------------------

function sp = spectrum2Dvec(f,varargin)
%SPECTRUM2DVEC  Computes the 2D power spectra.
%   SP = SPECTRUM2DVEC(V) returns the 2D spectrum of a vector field v. If V
%   is an array of vector fields, SPECTRUM2D returns the averaged 2D
%   spectrum.
%
%   Contents of the structure SP:
%         kx,ky :   wavenumbers along x and y
%         ex,ey,ez: 2D spectra of ux and uy (and uz if present)
%         e:        2D total spectrum (=ex+ey or ex+ey+ez)
%         k:        wavenumber norm
%         ep:       1D (theta-averaged) spectrum
%
%   The theta-averaged spectrum sp.ep is computed only for square fields.
%
%   sp2D = SPECTRUM2D(v,'hann') applies a 2D Hann window to the vector field

% History:
% 2004/05/24: v1.00, first version.
% 2005/02/24: v1.01, cosmetics
% 2005/02/28: v1.10, bug fixed for the average of spectra+computes the theta-averaged spectrum.
% 2005/03/02, v1.20, bug fixed with 2D apodization.
% 2006/07/17, v1.21, variable names changed, for display with showf
% 2013/03/13, v1.30, works with 3D fields

nx=size(f(1).vx,1);
ny=size(f(1).vx,2);

% new specf v2.02
if mod(nx,2)==1
    nx = nx-1;
    f = extractf(f, [1 1 nx ny]);
end

if mod(ny,2)==1
    ny = ny-1;
    f = extractf(f, [1 1 nx ny]);
end

hann_x=hann(nx)*ones(1,ny);     % Hann along x, invariant along y
hann_y=ones(nx,1)*hann(ny)';    % Hann along y, invariant along x

for i=1:numel(f)
    if any(strncmpi(varargin,'hann',1))
        % apodise along x, then FT along x, than transpose,
        % then apodise along x again, the FT along x, and transpose back
        i_sp(i).ex = fftshift((abs(fft((fft(f(i).vx.*hann_x).*hann_y)'))').^2);
        i_sp(i).ey = fftshift((abs(fft((fft(f(i).vy.*hann_x).*hann_y)'))').^2);
        if isfield(f(i),'vz')
            i_sp(i).ez = fftshift((abs(fft((fft(f(i).vz.*hann_x).*hann_y)'))').^2);
        end    
        sp.appod = 'Hann';
    else
        i_sp(i).ex = fftshift(abs(fft2(f(i).vx)).^2); % Fourier transform
        i_sp(i).ey = fftshift(abs(fft2(f(i).vy)).^2);
        if isfield(f(i),'vz')      
            i_sp(i).ez = fftshift(abs(fft2(f(i).vz)).^2);
        end
            
        sp.appod = 'None';
    end
end

% average over all individual spectra
sp.ex = mean(reshape([i_sp(:).ex],nx,ny,numel(f)),3)';
sp.ey = mean(reshape([i_sp(:).ey],nx,ny,numel(f)),3)';
if isfield(f(i),'vz')
    sp.ez = mean(reshape([i_sp(:).ez],nx,ny,numel(f)),3)';
end
nkx=nx/2;  % symmetrical FFT => half number of wavenumbers
nky=ny/2;

% wavenumbers (in units of 1/x, e.g. mm^-1)
sp.kx=linspace(0,pi*(1-1/nkx),nkx)/abs(f(1).x(2)-f(1).x(1));
sp.ky=linspace(0,pi*(1-1/nky),nky)/abs(f(1).y(2)-f(1).y(1));
% be careful: sp.kx(1) is equal to 0 (mode 0, i.e. energy of mean flow)
% sp.kx(2) is delta_kx (width of wavenumber) = pi / fieldsize_x
% sp.kx(end) is pi / meshsize_x


% normalisation
sp.ex=sp.ex/(nx*ny)^2/sp.kx(2);
sp.ey=sp.ey/(nx*ny)^2/sp.ky(2);
if isfield(f(1),'vz')
    sp.ez=sp.ez/(nx*ny)^2/sp.ky(2);  % (ky?)
end
sp.namekx = ['k_' f(1).namex];
sp.nameky = ['k_' f(1).namey];
sp.unitkx = [f(1).unitx '^{-1}'];
sp.unitky = [f(1).unity '^{-1}'];
sp.nameex = ['| FT ' f(1).namevx ' |^2'];
sp.nameey = ['| FT ' f(1).namevy ' |^2'];
sp.unitex = ['(' f(1).unitvx ')^2 ' f(1).unitx '^2'];
sp.unitey = ['(' f(1).unitvy ')^2 ' f(1).unity '^2'];
if isfield(f(1),'vz')
    sp.nameez = ['| FT ' f(1).namevz ' |^2'];
    sp.unitez = ['(' f(1).unitvz ')^2 ' f(1).unity '^2'];
end
sp.name = ['spectrum ' f(1).name];
sp.setname = f(1).setname;
sp.nfields = numel(f);

if isfield(f(1),'vz')
    sp.e = sp.ex + sp.ey + sp.ez;
    sp.namee = ['| FT ' f(1).namevx ' |^2 + | FT ' f(1).namevy ' |^2 + | FT ' f(1).namevz ' |^2'];
else
    sp.e = sp.ex + sp.ey; % total (2D) energy
    sp.namee = ['| FT ' f(1).namevx ' |^2 + | FT ' f(1).namevy ' |^2'];
end
sp.unite = ['(' f(1).unitvx ')^2 ' f(1).unitx '^2'];

if length(f)>1,
    sp.history = {f(1).history ; ...
        ['[concat fields 1..' num2str(length(f)) ']']; ...
        ['spec2f(ans, ' sp.appod ')']};
else
    sp.history = {f.history{:} ['spec2f(ans, ' sp.appod ')']}';
end

[sp.k,sp.ep]=cart2polmat(sp.e); % azimuthal average
sp.k = sp.k*abs(sp.kx(2)-sp.kx(1)); % normalise k




% ----------------------------------------------------------------

function sp = spectrum2Dscal(f,varargin)
%SPECTRUM2DSCAL  Computes the 2D power spectra.
%  idem SPECTRUM2DVEC, but for scalar field


nx=size(f(1).w,1);
ny=size(f(1).w,2);

% new specf v2.02
if mod(nx,2)==1
    nx = nx-1;
    f = extractf(f, [1 1 nx ny]);
end

if mod(ny,2)==1
    ny = ny-1;
    f = extractf(f, [1 1 nx ny]);
end

hann_x=hann(nx)*ones(1,ny);     % Hann along x, invariant along y
hann_y=ones(nx,1)*hann(ny)';    % Hann along y, invariant along x

for i=1:numel(f)
    if any(strncmpi(varargin,'hann',1))
        % apodise along x, then FT along x, than transpose,
        % then apodise along x again, the FT along x, and transpose back
        i_sp(i).e = fftshift((abs(fft((fft(f(i).w.*hann_x).*hann_y)'))').^2);
        sp.appod = 'Hann';
    else
        i_sp(i).e = fftshift(abs(fft2(f(i).w)).^2); % Fourier transform
        sp.appod = 'None';
    end
end

% average over all individual spectra
sp.e = mean(reshape([i_sp(:).e],nx,ny,numel(f)),3)';

nkx=nx/2;  % symmetrical FFT => half number of wavenumbers
nky=ny/2;

% wavenumbers (in units of 1/x, e.g. mm^-1)
sp.kx=linspace(0,pi*(1-1/nkx),nkx)/abs(f(1).x(2)-f(1).x(1));
sp.ky=linspace(0,pi*(1-1/nky),nky)/abs(f(1).y(2)-f(1).y(1));
% be careful: sp.kx(1) is equal to 0 (mode 0, i.e. energy of mean flow)
% sp.kx(2) is delta_kx (width of wavenumber) = pi / fieldsize_x
% sp.kx(end) is pi / meshsize_x


% normalisation
sp.e=sp.e/(nx*ny)^2/sp.kx(2);

sp.namekx = ['k_' f(1).namex];
sp.nameky = ['k_' f(1).namey];
sp.unitkx = [f(1).unitx '^{-1}'];
sp.unitky = [f(1).unity '^{-1}'];
sp.namee = ['| FT ' f(1).namew ' |^2'];
sp.unite = ['(' f(1).unitw ')^2 ' f(1).unitx '^2'];
sp.name = ['spectrum ' f(1).name];
sp.setname = f(1).setname;
sp.nfields = numel(f);

if length(f)>1,
    sp.history = {f(1).history ; ...
        ['[concat fields 1..' num2str(length(f)) ']']; ...
        ['spec2f(ans, ' sp.appod ')']};
else
    sp.history = {f.history{:} ['spec2f(ans, ' sp.appod ')']}';
end

[sp.k,sp.ep]=cart2polmat(sp.e); % azimuthal average
sp.k = sp.k*abs(sp.kx(2)-sp.kx(1)); % normalise k



%%%%%%%%%%%%%%%%%% SUBFUNCTION %%%%%%%%%%%%%%%%%

function [kp,ep]=cart2polmat(e)
%CART2POLMAT  Converts a cartesian matrix into a scalar function
%    of the radial distance.
%
%   Call:       [kp,ep]=cart2polmat(e);
%
%   Parameters: e = matrix
%
%   Return:     kp = vector of the radial distance
%               ep = scalar function of the radial distance
%
%   F. Moisy, Feb. 28, 2005.


% first version: FM Dec 12, 2003
% changes: FM Feb 17, 2005: comments
%          FM Feb 23, 2005: cosmetics
%          FM Feb 28, 2005: the 0 mode is now in r=0.

[nx,ny]=size(e);

nmax=ceil((nx^2+ny^2)^(1/2)/2)+1; % largest radius = diagonal.
ep=zeros(1,nmax);  % initialise
kp=1:nmax; % radii

i0=nx/2+1; j0=ny/2+1; % wavenumber origin (mode k=0)

for i=1:nx,
    for j=1:ny,
        n=1+((i-i0)^2+(j-j0)^2)^(1/2);  % distance between (i,j) et (i0,j0)
        % (attention : n equals 1 for (i,j)=(i0,j0) )
        if (n == floor(n)),    % if n is an integer, then takes its energy
            ep(n)=ep(n)+e(i,j);
        else    % otherwise, share its energy between the neighbours (energy conservation)
            n_inf=floor(n);
            n_sup=ceil(n);
            ep(n_inf)=ep(n_inf) + e(i,j) * (n_sup-n);
            ep(n_sup)=ep(n_sup) + e(i,j) * (n-n_inf);
        end
    end
end

kmax=ceil(min([nx ny])/2);
ep=ep(1:kmax); % truncate to the smallest size
kp=kp(1:kmax)-1; % attention : the mode 0 was in kp=1 ! (18/02/2005)

