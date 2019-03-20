function rf=rotatef(f,theta,varargin)
%ROTATEF  Rotates a vector/scalar field.
%   RF = ROTATEF(F, THETA) rotates the vector/scalar field(s) F about the
%   center through the angle THETA in the trigonometric direction (THETA is
%   given in radians). Points which have antecedent from outside the
%   original field are filled with 0. The new field RF is an
%   interpolation of the original field F on the new grid.
%
%   RF = ROTATEF(F, THETA, X0, Y0) rotates about the center specified by
%   (X0, Y0), in physical units. The center does not need to be inside the
%   field.  Specify ROTATEF(F, THETA, X0, Y0, 'mesh') to give the center
%   in mesh units instead of physical units.
%
%   RF = ROTATEF(...,'trunc') keeps only the largest rectangular area
%   (with the aspect ratio kept constant) containing only valid (i.e.
%   nonzero) elements. LIMITATION: This option works only for rotation
%   about the center - do not use it for any other center!
%
%   If no output argument, the result is displayed by SHOWF.
%
%   ROTATEF is useful for correcting vector/scalar fields obtained from
%   skewed images (e.g. misaligned camera).
%
%   Example:
%     v = loadvec('*.vc7');
%     showf(rotatef(v,0.1));
%
%   See also LOADVEC, VEC2SCAL, SHOWF, FILTERF, TRUNCF, EXTRACTF,
%   AZAVERF, SUBSBR, FLIPF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.30,  Date: 2013/03/13
%   This function is part of the PIVMat Toolbox

% History:
% 2005/07/25: v1.00, first version.
% 2005/06/24: v1.01, option 'trunc' added.
% 2005/09/03: v1.02, cosmetics.
% 2005/09/15: v1.03, no recursive call.
% 2005/10/11: v1.10, works also with scalar fields. name changed
%                    rotatevec -> rotatef.
% 2006/03/10: v1.11, bug fixed for theta==0.
% 2006/04/24: v1.12, theta>0 was clockwise for Y downward; bug fixed
% 2006/07/21: v1.20, center can now be specified, in mesh or phys units.
% 2007/12/11: v1.21, numeric input accepted
% 2013/03/13: v1.30, works with 3d fields

% error(nargchk(2,inf,nargin));

if (ischar(f) || iscellstr(f) || isnumeric(f))
    f=loadvec(f);
end

nx=length(f(1).x);
ny=length(f(1).y);

if nargin<3,
    % center of rotation (may be non integer):
    i0=(nx+1)/2; j0=(ny+1)/2;
else
    if isnumeric(varargin{1}) && isnumeric(varargin{2})
        x0 = varargin{1};
        y0 = varargin{2};
        if any(strncmpi(varargin,'mesh',1))
            i0=x0;    % if the center has been specified directly in mesh units
            j0=y0;
        else
            i0 = 1 + (x0 - f(1).x(1))/abs(f(1).x(2)-f(1).x(1));  % otherwise, find the center in mesh units (not necessarily integer)
            j0 = 1 + (y0 - f(1).y(1))/abs(f(1).y(2)-f(1).y(1));
        end
    else
        % center of rotation (may be non integer):
        i0=(nx+1)/2; j0=(ny+1)/2;
    end
end

rf=f;  % output (rotated) field

vecmode=isfield(f(1),'vx');   % 1 for vector field, 0 for scalar field

if theta~=0,
    ct=cos(theta);
    st=sin(theta);
    if strncmpi(f(1).ysign,'upward',2), % bug fixed v1.12
        st=-st;
    end

    for n=1:length(f),
        for i=1:nx,
            for j=1:ny

                % coordinates of the antecedent point (ia, ja) :
                ia = i0 + (i-i0)*ct - (j-j0)*st;
                ja = j0 + (i-i0)*st + (j-j0)*ct;

                % coordinates of the top-left neighbour point:
                ia0=floor(ia);  ja0=floor(ja);

                % interpolates the vector at the antecedent point
                % (or takes 0 is the antecedent point falls outside):
                if (ia0<1) || (ja0<1) || (ia0>(nx-1)) || (ja0>(ny-1)),
                    if vecmode,
                        vxa=0;
                        vya=0;
                        if isfield(f(1),'vz')
                            vza=0;
                        end
                    else
                        wa=0;
                    end
                else
                    % interpolate from the 4 weigthed neighbours:
                    if vecmode,
                        vxa = f(n).vx(ia0,ja0)*(ia0+1-ia)*(ja0+1-ja) + f(n).vx(ia0+1,ja0)*(ia-ia0)*(ja0+1-ja) + f(n).vx(ia0,ja0+1)*(ia0+1-ia)*(ja-ja0) + f(n).vx(ia0+1,ja0+1)*(ia-ia0)*(ja-ja0);
                        vya = f(n).vy(ia0,ja0)*(ia0+1-ia)*(ja0+1-ja) + f(n).vy(ia0+1,ja0)*(ia-ia0)*(ja0+1-ja) + f(n).vy(ia0,ja0+1)*(ia0+1-ia)*(ja-ja0) + f(n).vy(ia0+1,ja0+1)*(ia-ia0)*(ja-ja0);
                        if isfield(f(1),'vz')
                            vza = f(n).vz(ia0,ja0)*(ia0+1-ia)*(ja0+1-ja) + f(n).vz(ia0+1,ja0)*(ia-ia0)*(ja0+1-ja) + f(n).vz(ia0,ja0+1)*(ia0+1-ia)*(ja-ja0) + f(n).vz(ia0+1,ja0+1)*(ia-ia0)*(ja-ja0);
                        end
                    else
                        wa = f(n).w(ia0,ja0)*(ia0+1-ia)*(ja0+1-ja) + f(n).w(ia0+1,ja0)*(ia-ia0)*(ja0+1-ja) + f(n).w(ia0,ja0+1)*(ia0+1-ia)*(ja-ja0) + f(n).w(ia0+1,ja0+1)*(ia-ia0)*(ja-ja0);
                    end
                end

                % rotates the vector:
                if vecmode,
                    rf(n).vx(i,j) = vxa*ct + vya*st;
                    rf(n).vy(i,j) = -vxa*st + vya*ct;
                    if isfield(f(1),'vz')
                        rf(n).vz(i,j) = vza;
                    end
                else
                    rf(n).w(i,j) = wa;
                end
            end % for j
        end % for i

        if any(strncmpi(varargin,'trunc',2))

            cta=abs(ct); sta=abs(st);  %(modulo pi/2)  % changed v1.12

            % width of the bands (dnx, dny) to remove:
            dnx = nx/2 * ((ny/nx)*(cta-1) + sta) / ((ny/nx)*cta + sta);
            dny = dnx * (ny/nx);

            dnx=ceil(dnx); dny=ceil(dny); % arrondi a l'entier superieur
            if vecmode,
                rf(n).vx = rf(n).vx((1+dnx):(nx-dnx),(1+dny):(ny-dny));
                rf(n).vy = rf(n).vy((1+dnx):(nx-dnx),(1+dny):(ny-dny));
                if isfield(f(1),'vz')
                    rf(n).vz = rf(n).vz((1+dnx):(nx-dnx),(1+dny):(ny-dny));
                end                    
            else
                rf(n).w = rf(n).w((1+dnx):(nx-dnx),(1+dny):(ny-dny));
            end
            rf(n).x = f(n).x((1+dnx):(nx-dnx));
            rf(n).y = f(n).y((1+dny):(ny-dny));
        end

        rf(n).history = {f(n).history{:} ['rotatef(ans, ' num2str(theta) ', ' varargin{:} ')']}';
    end % end for n

end  % end if theta~=0

if nargout==0
    showf(rf);
    clear rf
end
