function cor = tempcorrf(f,varargin)
%CORRF Temporal correlation function of vector or scalar fields
%   COR = TEMPCORRF(F) computes the temporal correlation function of the
%   vector or scalar fields F.  For a scalar field w(t),
%      COR.f = < w (t) w(t+T) >,
%   where T is the time lag, and <.> is the time average over t.
%   For a vector field, COR.f is the sum of the correlation for each
%   component of the vector (works with 2- and 3-component fields).
%   T takes integer values between 0 and LENGTH(F)-1.
%
%   COR is a structure which contains the following fields:
%     t:       time lag T (integers between 0 and LENGTH(F)-1)
%     f:       correlation function
%     unitf:   unit of correlation function
%     namef:   name of correlation function
%
%   COR = TEMPCORRF(F, 'norm') normalizes the correlation function, so
%   that f = 1 at T = 0.
%
%   Note that the convergence of the correlation function is not garanteed,
%   especially at large time lags T, for which few data points are
%   available to compute the correlation.
%
%   If no output argument, the correlation function is plotted.
%
%   Example:
%      v = loadvec('*.VC7');
%      cor = corrf(v);
%      plot(cor.t, cor.f, 'o-');
%
%   See also CORRF, TEMPSPECF, SPATIOTEMPCORRF, TEMPFILTERF


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.11,  Date: 2016/11/17
%   This function is part of the PIVMat Toolbox


% History:
% 2013/01/06: v1.00, first version.
% 2013/03/13: v1.10, works with 3D fields
% 2016/11/17: v1.11, slight speed improvement



% error(nargchk(1,2,nargin));

comp = numcompfield(f(1));

if any(strncmpi(varargin,'normalize',1))
    cor.unitf = '';
else
    if comp>1
        cor.unitf = ['(' f(1).unitvx ')^2'];
    else
        cor.unitf = ['(' f(1).unitw ')^2'];
    end
end
switch comp
    case 3
        cor.namef = ['< ' f(1).namevx '(t) ' f(1).namevx '(t+\tau) + ' ...
        f(1).namevy '(t) ' f(1).namevy '(t+\tau) + ' ...
        f(1).namevz '(t) ' f(1).namevz '(t+\tau) >'];
    case 2
        cor.namef = ['< ' f(1).namevx '(t) ' f(1).namevx '(t+\tau) + ' ...
        f(1).namevy '(t) ' f(1).namevy '(t+\tau) >'];
    case 1
        cor.namef = ['< ' f(1).namew '(t) ' f(1).namew '(t+\tau) >'];
end

% compuptation of the correlation function
maxtau = length(f)-1;
cor.t = 0:maxtau;
for ind = 1:numel(cor.t)
    cor.f(ind) = 0;
    for t = 1:(1+maxtau-cor.t(ind))
        switch comp
            case 3
                prodf = f(t).vx .* f(t+cor.t(ind)).vx + ...
                    f(t).vy .* f(t+cor.t(ind)).vy + ...
                    f(t).vz .* f(t+cor.t(ind)).vz;
            case 2
                prodf = f(t).vx .* f(t+cor.t(ind)).vx + ...
                    f(t).vy .* f(t+cor.t(ind)).vy;
            case 1
                prodf = f(t).w .* f(t+cor.t(ind)).w;
        end
        cor.f(ind) = cor.f(ind) + mean(prodf(:));
    end
    cor.f(ind) = cor.f(ind) / (1+maxtau-cor.t(ind));
end

if any(strncmpi(varargin,'normalize',1))
    cor.f = cor.f / cor.f(1);
end

% display plot
if ~nargout
    plot(cor.t, cor.f, 'o-');
    grid on
    xlabel('Time lag \tau');
    if any(strncmpi(varargin,'normalize',1))
        ylabel(cor.namef);
    else
        ylabel([cor.namef '  (' cor.unitf ')']);
    end
end
