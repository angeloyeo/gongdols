function sp = specf(f,varargin)
%SPECF  1D power spectrum of vector/scalar fields.
%   SP = SPECF(F) returns a structure SP containing the 1D power
%   spectrum of the vector or scalar field(s) F. If F is an array of
%   fields, the average spectrum is returned. Note: The factor 1/2, usually
%   used in the definition of energy, is _not_ included here, so that the
%   integral of the power spectrum over wavenumbers is given by the mean
%   square of the input field (see Parseval below).
%
%   SP = SPECF(F,'hann') applies a Hann (or Hanning) apodization window
%   to the fields along each direction in order to reduce aliasing. Note
%   that, in this case, energy is not conserved (the amount of energy
%   lost in the apodization is about 60%, but the exact value depends on
%   the details of the energy distribution).
%
%   The X and Y dimensions of the fields must be even. If one of the
%   dimension is odd, the last column/row is discarded.
%
%   Use the syntax SP = SPECF(F, ..., 'disp'), or SPECF(F, ...) without
%   output argument, to also display the spectrum. This works only for
%   square fields (see below).
%
%   SPECF(SP) displays the spectrum, where SP has been previously computed
%   using SP=SPECF(...). If SP is a structure array, loops over all spectra
%   (press a key between each display).
%
%   SPECF(..., 'comp', n) shows the spectrum multiplied by k^n (compensated
%   spectrum).
%
%   SPECF(..., 'k2') shows the spectrum multiplied by k^2 (dissipation
%   spectrum). Equivalent to SPECF(..., 'comp', 2).
%   
%   For vector field(s), the structure SP contains:
%       kx,ky:    wavenumbers along x and y
%       exvx:     1D power spectrum of F_x along x
%       exvy:     1D power spectrum of F_y along x
%       eyvx:     1D power spectrum of F_x along y
%       eyvy:     1D power spectrum of F_y along y
%       exvz:     1D power spectrum of F_z along x (for 3D fields)
%       eyvz:     1D power spectrum of F_z along y (for 3D fields)
%       k:        wavenumber
%       el, et:   1D longitudinal and transverse power spectra
%       e:        1D power spectrum (sum of el and et)
%       unitk:    unit of wavenumber
%       unite:    unit of power spectrum (energy density)
%       appod:    Apodization window ('Hann' or 'None')
%       nfields:  number of fields used in the computation
%       history:  remind from which field specf has been called.
%
%   For scalar field(s), the structure SP contains:
%       kx,ky:    wavenumbers along x and y
%       ex:       1D power spectrum of F along x
%       ey:       1D power spectrum of F along y
%       k:        wavenumber
%       e:        1D power spectrum (average of ex and ey)
%       unitk:    unit of wavenumber
%       unite:    unit of power spectrum (energy density)
%       appod, nfields, history: idem as for vector fields
%
%   Note that the long. and transv. spectra (el and et) are computed only
%   for square fields. Use TRUNCF if you want to first extract the central
%   square from the fields.
%
%   The unit for the wavenumber is the inverse of the unit for the spatial
%   scale (e.g. in 1/mm). The length of the spectrum is half the length of
%   the field (negative wavenumbers ignored). Some useful properties:
%     sp.k(1) is equal to 0 (zero mode = mean component of the field)
%     sp.k(2) is the wavenumber increment, Delta k = 2*pi/L, where L is the
%                size of the field.
%     sp.k(end) is pi/dx, where dx is the mesh size of the field.
%
%   The unit for the spectra (exvx, el, et, e...) is given by the unit of
%   the input field squared, times the unit of scale.  For instance, for a
%   velocity field given in m/s with spatial scale in mm, the unit for the
%   spectra is (m^2/s^2)*mm, i.e. (m^3/s^2)/1000.
%   
%   Example:
%      v=loadvec('*.vc7');    % assuming v in m/s and r in mm
%      sp=specf(truncf(v));
%      loglog(sp.k*1000, sp.el/1000);
%      xlabel('k (m^{-1}'); 
%      ylabel('E(k)  (m^3 s^{-2}');
%
%   Energy Conservation (Parseval theorem)
%
%   For a scalar field, energy conservation requires that
%     SUM(SP.EX)*SP.KX(2) = SUM(SP.EY)*SP.KY(2) = MEAN(F.W(:).^2)
%   and, if the field is square with equal scales along X and Y:
%     SUM(SP.E)*SP.K(2) = MEAN(F.W(:).^2)
%
%   For a vector field, energy conservation requires that
%     SUM(SP.EXVX)*SP.KX(2) = SUM(SP.EYVX)*SP.KY(2) = MEAN(F.VX(:).^2)
%     SUM(SP.EXVY)*SP.KX(2) = SUM(SP.EYVY)*SP.KY(2) = MEAN(F.VY(:).^2)
%   and, if the field is square with equal scales along X and Y:
%     SUM(SP.EL)*SP.K(2) = (MEAN(F.VX(:).^2)+MEAN(F.VY(:).^2))
%
%   Example:  Verification of energy conservation for a scalar field:
%      v=truncf(loadvec('b00001.vc7'));
%      c=vec2scal(v,'ux');
%      sp=specf(c);
%      st=statf(c);
%      %  The 3 computations should give the same number (in m2/s2):
%      st.rms.^2            % (twice the) energy in physical space
%      sum(sp.ex)*sp.kx(2)  % energy in Fourier space (computation 1)
%      sum(sp.ey)*sp.ky(2)  % energy in Fourier space (computation 2)
%
%   See also SPEC2F, TEMPSPECF, STATF, VSF, SSF, TRUNCF, CORRF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 2.20, Date: 2013/03/13
%   This function is part of the PIVMat Toolbox


% History:
% 2004/04/22: v1.00, first version.
% 2005/02/18: v1.01, bug fixed (hann_x and hann_y were inverted!!)
% 2005/02/28: v1.10, also computes longitudinal and transverse spectra.
% 2006/07/17, v1.20, cosmetics
% 2008/04/02: v2.00, renamed "specf". Accepts scalars and vectors;
%                    normalization is now correct (energy conservation);
%                    no more recursive calls; new 'appod' and 'unit' fields
% 2008/04/16: v2.01, field history added                    
% 2008/09/01: v2.02, now works when nx and/or ny is odd
% 2008/09/28: v2.03, the appodization mode is now specified in the history
% 2008/10/10: v2.10, compensated spectra
% 2008/11/11: v2.11, new sp.e. Bug factor 2 fixed
% 2009/02/24: v2.12, bug fixed in latex legend for non-integer exponents
% 2013/03/13: v2.20, works with 3D fields (still needs some work)

% error(nargchk(1,inf,nargin));

if (ischar(f) || iscellstr(f) || isnumeric(f))
    f = loadvec(f);
end

if isfield(f(1),'kx')  % argument is a spectrum
    sp = f;
elseif isfield(f(1),'vx')  % argument is a vector field
    sp = spectrumvec(f,varargin{:});
elseif isfield(f(1),'w')   % argument is a scalar field
    sp = spectrumscal(f,varargin{:});
else
    error('Unknown input argument.');
end


% compensated spectra: new v2.10
compmode = false;
if any(strncmpi(varargin,'comp',2))
    compmode = true;
    n = varargin{1+find(strncmpi(varargin,'comp',2),1,'last')};
    if ~isnumeric(n)
        error('PIVMat:specf:invalidArgument','Non-numeric exponent for the compensated spectrum');
    end
    strn = num2str(n);
end

if any(strncmpi(varargin,'k2',2))
    compmode = true;
    n = 2;
    strn = '2';
end


if any(strncmpi(varargin,'disp',2)) || nargout==0
    for i=1:numel(sp)
        if isfield(sp(i),'exvx')    
            if isfield(sp,'k')
                if compmode
                    loglog(sp(i).k, sp(i).k.^n.*sp(i).el,'r',sp(i).k, sp(i).k.^n.*sp(i).et, 'b');
                    legend(['k^{' strn '} E_L(k)'],['k^{' strn '} E_T(k)']);
                    xlabel(['k (' sp(i).unitk ')']);
                    ylabel(['k^{' strn '} E(k)   (' sp(i).unite ' x (' sp(i).unitk ')^{' strn '})']);
                else
                    loglog(sp(i).k, sp(i).el,'r',sp(i).k, sp(i).et, 'b');
                    legend('E_L(k)','E_T(k)');
                    xlabel(['k (' sp(i).unitk ')']);
                    ylabel(['E(k)   (' sp(i).unite ')']);
                end
            end
        elseif isfield(sp(i),'ex')
            if isfield(sp,'k')
                if compmode
                    loglog(sp(i).k, sp(i).k.^2.*sp(i).e);
                    xlabel(['k (' sp(i).unitk ')']);
                    ylabel(['k^{' strn '} E(k)   (' sp(i).unite ' x (' sp(i).unitk ')^{' strn '})']);
                else
                    loglog(sp(i).k, sp(i).e);
                    xlabel(['k (' sp(i).unitk ')']);
                    ylabel(['E(k)   (' sp(i).unite ')']);
                end
            end
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

function sp = spectrumvec(v,varargin)
nx=size(v(1).vx,1);
ny=size(v(1).vx,2);

% new specf v2.02
if mod(nx,2)==1
    nx = nx-1;
    v = extractf(v, [1 1 nx ny]);
end

if mod(ny,2)==1
    ny = ny-1;
    v = extractf(v, [1 1 nx ny]);
end

% Bug fixed 19/02/05 : hann_x and hann_y were inverted
hann_x=hann(nx)*ones(1,ny);     % Hann along x, invariant along y
hann_y=ones(nx,1)*hann(ny)';    % Hann along y, invariant along x
% hann_x is invariant along y when plotted using imagesc(hann_x')

for i=1:numel(v)
    if any(strncmpi(varargin,'hann',1))
        i_sp(i).exvx=mean(abs(fft(v(i).vx.*hann_x,[],1)).^2,2);
        i_sp(i).exvy=mean(abs(fft(v(i).vy.*hann_x,[],1)).^2,2);
        i_sp(i).eyvx=mean(abs(fft(v(i).vx.*hann_y,[],2)).^2,1)';
        i_sp(i).eyvy=mean(abs(fft(v(i).vy.*hann_y,[],2)).^2,1)';
        if isfield(v(i),'vz')
            i_sp(i).exvz=mean(abs(fft(v(i).vz.*hann_x,[],1)).^2,2);
            i_sp(i).eyvz=mean(abs(fft(v(i).vz.*hann_y,[],2)).^2,1)';
        end
        sp.appod = 'Hann';
    else
        i_sp(i).exvx=mean(abs(fft(v(i).vx,[],1)).^2,2); % rewritten v1.21
        i_sp(i).exvy=mean(abs(fft(v(i).vy,[],1)).^2,2);
        i_sp(i).eyvx=mean(abs(fft(v(i).vx,[],2)).^2,1)';
        i_sp(i).eyvy=mean(abs(fft(v(i).vy,[],2)).^2,1)';
        if isfield(v(i),'vz')
            i_sp(i).exvz=mean(abs(fft(v(i).vz,[],1)).^2,2);
            i_sp(i).eyvz=mean(abs(fft(v(i).vz,[],2)).^2,1)';
        end
        sp.appod = 'None';
    end
end

% average over all individual spectra
sp.exvx = mean([i_sp(:).exvx],2)';
sp.exvy = mean([i_sp(:).exvy],2)';
sp.eyvx = mean([i_sp(:).eyvx],2)';
sp.eyvy = mean([i_sp(:).eyvy],2)';
if isfield(v(1),'vz')
    sp.exvz = mean([i_sp(:).exvz],2)';
    sp.eyvz = mean([i_sp(:).eyvz],2)';
end
nkx=nx/2;  % symmetrical FFT => half number of wavenumbers
nky=ny/2;

% wavenumbers (in units of 1/x, e.g. mm^-1)
sp.kx=linspace(0,pi*(1-1/nkx),nkx)/abs(v(1).x(2)-v(1).x(1));
sp.ky=linspace(0,pi*(1-1/nky),nky)/abs(v(1).y(2)-v(1).y(1));
% be careful: sp.kx(1) is equal to 0 (mode 0, i.e. energy of mean flow)
% sp.kx(2) is delta_kx (width of wavenumber) = pi / fieldsize_x
% sp.kx(end) is pi / meshsize_x


% normalisation (factor 2 corrected, v 2.11)
sp.exvx = 2*sp.exvx(1:nkx)/(nx*ny)/sp.kx(2);
sp.exvy = 2*sp.exvy(1:nkx)/(nx*ny)/sp.kx(2);
sp.eyvx = 2*sp.eyvx(1:nky)/(nx*ny)/sp.ky(2);
sp.eyvy = 2*sp.eyvy(1:nky)/(nx*ny)/sp.ky(2);
% (energy in mode k=0 is counted twice)
sp.exvx(1) = sp.exvx(1)/2;
sp.exvy(1) = sp.exvy(1)/2;
sp.eyvx(1) = sp.eyvx(1)/2;
sp.eyvy(1) = sp.eyvy(1)/2;
if isfield(v(1),'vz')
    sp.exvz = 2*sp.exvz(1:nkx)/(nx*ny)/sp.kx(2);
    sp.eyvz = 2*sp.eyvz(1:nky)/(nx*ny)/sp.ky(2);
    sp.exvz(1) = sp.exvz(1)/2;
    sp.eyvz(1) = sp.eyvz(1)/2;
end

% longitudinal and transverse spectra:
if nx==ny
    sp.el = (sp.exvx + sp.eyvy);  %(i am not sure of the factor 1 or 1/2...)
    sp.et = (sp.exvy + sp.eyvx);
    sp.e = sp.el + sp.et;      % new 2.11
    sp.k = (sp.kx + sp.ky)/2;  %(should be equal...)
end

sp.unitk = [v(1).unitx '^{-1}'];
sp.unite = ['(' v(1).unitvx ')^2 x ' v(1).unitx];
sp.nfields = numel(v);

% history field (v2.01):
if length(v)>1,
    sp.history = {v(1).history ; ...
        ['[concat fields 1..' num2str(length(v)) ']']; ...
        ['specf(ans, ' sp.appod ')']};
else
    sp.history = {v.history{:} ['specf(ans, ' sp.appod ')']}';
end

% ----------------------------------------------------------------

function sp = spectrumscal(s,varargin)
nx=size(s(1).w,1);
ny=size(s(1).w,2);

% new specf v2.02
if mod(nx,2)==1
    nx = nx-1;
    s = extractf(s, [1 1 nx ny]);
end

if mod(ny,2)==1
    ny = ny-1;
    s = extractf(s, [1 1 nx ny]);
end

% Bug fixed 19/02/05 : hann_x and hann_y were inverted
hann_x=hann(nx)*ones(1,ny);     % Hann along x, invariant along y
hann_y=ones(nx,1)*hann(ny)';    % Hann along y, invariant along x
% hann_x is invariant along y when plotted using imagesc(hann_x')
        
for i=1:numel(s)
    if any(strncmpi(varargin,'hann',1))
        i_sp(i).ex=mean(abs(fft(s(i).w.*hann_x,[],1)).^2,2); % rewritten v1.21
        i_sp(i).ey=mean(abs(fft(s(i).w.*hann_y,[],2)).^2,1)';
        sp.appod = 'Hann';
    else
        i_sp(i).ex=mean(abs(fft(s(i).w,[],1)).^2,2); % rewritten v1.21
        i_sp(i).ey=mean(abs(fft(s(i).w,[],2)).^2,1)';
        sp.appod = 'None';
    end
end

% average over all individual spectra
sp.ex = mean([i_sp(:).ex],2)';
sp.ey = mean([i_sp(:).ey],2)';

nkx=nx/2;  % symmetrical FFT => half number of wavenumbers
nky=ny/2;

% wavenumbers (in units of 1/x, e.g. mm^-1)
sp.kx=linspace(0,pi*(1-1/nkx),nkx)/abs(s(1).x(2)-s(1).x(1));
sp.ky=linspace(0,pi*(1-1/nky),nky)/abs(s(1).y(2)-s(1).y(1));
% be careful: sp.kx(1) is equal to 0 (mode 0, i.e. energy of mean flow)
% sp.kx(2) is delta_kx (width of wavenumber) = pi / fieldsize_x
% sp.kx(end) is pi / meshsize_x


% normalisation (factor 2 corrected, v 2.11)
sp.ex = 2*sp.ex(1:nkx)/(nx*ny)/sp.kx(2);
sp.ey = 2*sp.ey(1:nky)/(nx*ny)/sp.ky(2);
% (energy in mode k=0 is counted twice)
sp.ex(1) = sp.ex(1)/2;
sp.ey(1) = sp.ey(1)/2;

if nx==ny
    sp.e = sp.ex + sp.ey; % changed v2.11
    sp.k = (sp.kx + sp.ky)/2; % (they should also be equal...)
end

sp.unitk = [s(1).unitx '^{-1}'];
sp.unite = ['(' s(1).unitw ')^2 x ' s(1).unitx];
sp.nfields = numel(s);

% history field (v2.01):
if length(s)>1,
    sp.history = {s(1).history ; ...
        ['[concat fields 1..' num2str(length(s)) ']']; ...
        ['specf(ans, ' sp.appod ')']};
else
    sp.history = {s.history{:} ['specf(ans, ' sp.appod ')']}';
end
