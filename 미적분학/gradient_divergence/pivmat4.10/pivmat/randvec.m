function v=randvec(n,nf,slope,nc,nl)
%RANDVEC  Synthetic 2D vector field.
%   V = RANDVEC returns a synthetic 2D vector field with a k^(-5/3) spectrum,
%   random phase and zero 2D divergence. The size of the vector field is
%   256x256 by default. V has the same structure as vector fields loaded by
%   LOADVEC, with arbitrary units.
%
%   V = RANDVEC(N) returns a field of size N*N.
%
%   V = RANDVEC(N,NF) returns an array of NF fields.
%
%   V = RANDVEC(N,NF,SLOPE) imposes a spectrum k^-SLOPE  (-5/3 by default).
%
%   V = RANDVEC(N,NF,SLOPE,NC,NL) does the same, but specifies the small
%   scale NC and large-scale NL cut-offs (in units of vector mesh).
%   By default, NC=3 and NL=N/3. For k<NL, the spectrum is k^2. For k > NC,
%   the spectrum falls gaussianly.
%
%   Example:  showf(randvec);
%
%   See also SHOWF, ADDNOISEF, VORTEX, MULTIVORTEX.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.07,  Date: 2007/03/27
%   This function is part of the PIVMat Toolbox


% History:
% 2004/05/23: v1.00, first version.
% 2005/02/17: v1.01, k^2 spectrum at large scales bugs fixed (there was a
%                    missing band at kx=1, ky>ko)
% 2005/02/23: v1.02, cosmetics.
% 2005/09/05: v1.03, idem.
% 2005/10/21: v1.04, field ysign added.
% 2005/10/29: v1.05, bug fixed for n>1.
% 2006/05/19: v1.06, bug fixed with field 'history'
% 2007/03/27: v1.07, bug fixed with field 'setname'


if ~exist('n','var'), n=256; end
if ~exist('nf','var'), nf=1; end
if ~exist('slope','var'), slope=5/3; end
if ~exist('nc','var'), nc=3; end % small scale scale cut-off
if ~exist('nl','var'), nl=n/3; end % large scale

k0=n/2+1; % location of the zero mode.

for num=1:nf,
    tux=zeros(n);
    tuy=zeros(n);    
    for kx=1:k0,
        for ky=1:n,
            k=sqrt((kx-k0)^2+(ky-k0)^2);
            if k
                % spectrum 2D = spectrum 1D / (pi k)
            	 e=(exp(-(k/(n/nc))^(2)) * k^2/(1+(k/(n/nl))^(2*slope+4))^(1/2))/k; 
            	 %e=(exp(-(k/(n/nc))^(2)) /(1+(k/(n/nl))^(2*slope))^(1/2))/k; 
                 
                 %e=e*(1+0.2*(rand-.5)); % adds noise
                 
                 if ((kx>1) && (ky>1)),
                     expphi=exp(j*rand*2*pi); % random phase
                 else
                     expphi=(-1)^round(2*rand); % except on the first hor. and vert. strips, which must be real (phase=0).
                 end
                
                % the fourier transform of vec(u) must be orthogonal to
                % vec(k) by incompressibility.
                % (tux and tuy must have the same phase phi to ensure
                % incompress.)
                costheta=(kx-k0)/k;
                sintheta=(ky-k0)/k;
                tux(kx,ky) = -sqrt(e)*sintheta*expphi;
                tuy(kx,ky) = sqrt(e)*costheta*expphi; 
                
                % impose the invariance u (kx,ky) = u* (-kx, -ky) to get a real vec field.
                % (where u* is the complex conjugate of u)
                if ((kx>1) && (ky>1)),
                    tux(2*k0-kx,2*k0-ky)=conj(tux(kx,ky));
                    tuy(2*k0-kx,2*k0-ky)=conj(tuy(kx,ky));
                end
            else
                tux(kx,ky)=0; % zero mode has zero energy (no mean flow)
                tuy(kx,ky)=0;
            end
        end
    end
    
    % completes the missing band (which cannot be filled by symmetry):
    % added FM Feb 17, 2005
    for kx=(k0+1):n,
        ky=1;
        k=sqrt((kx-k0)^2+(ky-k0)^2);
        % spectrum 2D = spectrum 1D / (2 pi k)
        e=(exp(-(k/(n/nc))^(2)) * k^2/(1+(k/(n/nl))^(2*slope+4))^(1/2))/k;
        %e=(exp(-(k/(n/nc))^(2)) /(1+(k/(n/nl))^(2*slope))^(1/2))/k;

        expphi=(-1)^round(2*rand);
        costheta=(kx-k0)/k;
        sintheta=(ky-k0)/k;
        tux(kx,ky) = -sqrt(e)*sintheta*expphi;
        tuy(kx,ky) =  sqrt(e)*costheta*expphi;
    end


    % nb: vx and vy should be exactly real,
    % however the asymmetry in k (on n/2-1) points <-> -k (on n/2) points
    % creates a residual imaginary part.
    v(num).vx = ifft2(ifftshift(tux),'symmetric'); % ifftshift and ifft2 instead of fftshift and fft2 (17 fev 2005)
    v(num).vy = ifft2(ifftshift(tuy),'symmetric');
    
    % normalize
    v(num).vx = v(num).vx * n^2;
    v(num).vy = v(num).vy * n^2;
    
    v(num).x=1:n;
    v(num).y=1:n;
    v(num).ysign='Y axis downward'; % new v1.04
    v(num).namex='x';
    v(num).namey='y';
    v(num).namevx='vx';
    v(num).namevy='vy';
    v(num).unitx='au';
    v(num).unity='au';
    v(num).unitvx='au';
    v(num).unitvy='au';
    v(num).history={['randvec(' num2str(n) ',' num2str(nf) ',' num2str(slope) ',' num2str(nc) ',' num2str(nl) ')']};
    v(num).name='randvec';
    v(num).setname='';
end
