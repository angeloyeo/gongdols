function fv=bwfilterf(v,filtsize,order,varargin)
%BWFILTERF  Butterworth filter for vector/scalar fields
%   FF = BWFILTERF(F,FSIZE,ORDER) applies a spatial Butterworth filter to
%   the vector/scalar fields F,  with a cutoff size FSIZE (in grid units)
%   and order ORDER. A Butterworth filter is a low-pass (for ORDER>0) or
%   a high-pass (for ORDER<0) filter in the Fourier space.
%
%   BWFILTERF first Fourier-transforms the field(s), applies a low/high-
%   pass transfer function T(k) defined as
%       T(k) = 1/(1+(k/kc)^(ORDER/2)),
%   and inverse Fourier transforms back in the physical space. Here
%   k = (kx^2+ky^2)^(1/2) is the wave number, and kc is the cutoff
%   wave number of the filter, such that kc = L/FSIZE, with L the size the
%   fields. If ORDER>0, the filter is low-pass (i.e., it filters out the
%   small scales). If ORDER<0, the filter is high-pass (i.e., it filters
%   out the large scales). The X and Y dimensions of the fields must be
%   even. If one of the dimension is odd, the last column/row is discarded.
%
%   Typical values for FSIZE are around 1-10, and typical values for ORDER
%   are in the range 2-10 (positive for a low-pass filter, negative for a
%   high-pass filter). Large values of ORDER correspond to a sharper
%   filter. Values too large (say, |ORDER| > 10) may produce oscillations
%   in the physical space.
%
%   If FSIZE and ORDER are scalar, the same cutoff and order is applied
%   to each field F.  IF FSIZE and/or ORDER are arrays, a different cutoff
%   and/or order is applied to each field (their dimensions must match the
%   dimension of the field F).
%
%   FF = BWFILTERF(F,FSIZE,ORDER,'opt',...) specifies the options:
%     'low', 'high':   applies a lowpass (by default) or highpass filter.
%                      option 'high' simply changes the sign of ORDER.
%     'trunc':         truncates the borders of width FSIZE, which are
%                      affected by the filtering.
%
%   If no output argument, the result is displayed by SHOWF.
%
%   Note: If there are missing data in the field, it is better to first
%   interpolate the data, using INTERPF.
%
%   Example:
%      v = loadvec('*.vc7');
%      showf(bwfilterf(v,3,8));
%
%   See also FILTERF, INTERPF, ADDNOISEF, TRUNCF, EXTRACTF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.42,  Date: 2017/31/01
%   This function is part of the PIVMat Toolbox


% History:
% 2005/02/23: v1.00, first version.
% 2005/05/25: v1.01, bug fixed.
% 2005/09/03: v1.02, arg check added.
% 2005/10/06: v1.03, highpass filter added.
% 2005/10/09: v1.10, now called bwfilterf (from bwfiltervec 1.03, 2005/10/06)
% 2006/03/10: v1.11, new history
% 2006/04/25: v1.12, bug fixed with trunc/truncf
% 2008/10/08: v1.20, now accepts non-square fields. Vectorized version.
% 2009/03/17: v1.30, FSIZE and ORDER can be arrays.
% 2013/02/22: v1.40, works with 3D fields
% 2013/07/03: v1.41, help text improved
% 2017/31/01: v1.42, idem


%error(nargchk(3,4,nargin));

if (ischar(v) || iscellstr(v)), v=loadvec(v); end

if any(strncmpi(varargin,'high',1))
    order = -order;   % for a high-pass filter
end

if numel(filtsize)>1
    if numel(filtsize)~=numel(v)
        error('Dimensions of vector/scalar fields F and filter sizes must be equal.');
    end
else
    filtsize = filtsize * ones(1,numel(v));
end

if numel(order)>1
    if numel(order)~=numel(v)
        error('Dimensions of vector/scalar fields F and order must be equal.');
    end
else
    order = order * ones(1,numel(v));
end

nx=length(v(1).x);
ny=length(v(1).y);

% if size is odd, truncate
if mod(nx,2)==1
    nx = nx-1;
    v = extractf(v, [1 1 nx ny],'mesh');
end

if mod(ny,2)==1
    ny = ny-1;
    v = extractf(v, [1 1 nx ny],'mesh');
end

n=min(nx,ny);  % note sure of this for rectangular fields...
kx0=nx/2+1; % location of the zero mode.
ky0=ny/2+1;

% computes the transfer function (spectral filter):
[ky,kx] = meshgrid(1:ny,1:nx);
k = sqrt((kx-kx0).^2+(ky-ky0).^2);

fv=v;

vecmode=isfield(v(1),'vx');   % 1 for vector field, 0 for scalar field

for i=1:numel(v)  % do NOT use parfor here!
    if filtsize(i)~=0
        T = 1./(1+(k/(n/filtsize(i))).^(order(i)/2));
        if vecmode
            spx=fftshift(fft2(v(i).vx));
            spy=fftshift(fft2(v(i).vy));
            fv(i).vx = real(ifft2(ifftshift(spx.*T)));
            fv(i).vy = real(ifft2(ifftshift(spy.*T)));
            if isfield(v(i),'vz')
                spz=fftshift(fft2(v(i).vz));
                fv(i).vz = real(ifft2(ifftshift(spz.*T)));
            end
        else
            sp=fftshift(fft2(v(i).w));
            fv(i).w = real(ifft2(ifftshift(sp.*T)));
        end
        if any(strncmpi(varargin,'trunc',1))
            fv(i)=truncf(fv(i),floor(filtsize(i)));
        end
        fv(i).history = {v(i).history{:} ['bwfilterf(ans, ' num2str(filtsize(i)) ', ' num2str(order(i)) ', ''' varargin{:} ''')']}';
    end
end

if nargout==0
    showf(fv);
    clear fv
end
