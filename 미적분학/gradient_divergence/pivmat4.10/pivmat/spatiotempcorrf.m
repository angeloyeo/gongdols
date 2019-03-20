function stc = spatiotempcorrf(f, varargin)
%SPATIOTEMPCORRRF  Spatio-temporal correlation function
%   STC = SPATIOTEMPCORRRF(F) computes the spatio-temporal correlation
%   function of the scalar fields F, defined as
%       C(X,T) = < w(x,y,t) w(x+X,y,t+T) > / < w(x,y,t)^2 >,
%   with <..> the average over x, y, and t.  The normalization is such that
%   C(0,0)=1. This is useful to determine the convection velocity of a
%   pattern (e.g. a wave), which is given by the slope X/T maximizing the
%   correlation C.
%
%   The spatial correlation is computed along the X direction only (rotate
%   your field if you want a correlation along Y). Since C(-X,-T) = C(X,T)
%   (for an homogeneous and stationnary process), only two out of four
%   quadrants are computed: (X,T) = (>0, >0) and (<0, >0).
%
%   The output structure STC contains:
%      STC.cor    Matrix containing the correlation C(X,T)
%      STC.X      Vector (of size 1+round(Nx/2)) containing the separations
%      STC.T      Vector (of size 1+round(Nt/2)) containing the time lags
%   where Nt = LENGTH(F) and (Nx, Ny) is the size of the fields.
%
%   STC = STCORRF(...,'full') computes the correlation for all possible X
%   and T (remark: large X and T are noisy because of poor average).
%
%   STC = STCORRF(...,'verbose') displays the work in progress.
%
%   Example:
%      stc = stcorrf(h,'verb');
%      contourf(stc.X, stc.T/200, stc.cor',16);
%      xlabel('X (mm)'); ylabel('T (s)');
%
%   See also CORRF, TEMPCORRF, TEMPSPECF, SPECF, TEMPFILTERF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.04,  Date: 2016/05/11
%   This function is part of the PIVMat Toolbox


% History:
% 2014/12/11: v1.00, first version.
% 2014/12/12: v1.01, computes for both X>0 and X<0
% 2014/12/14: v1.02, add field 'history'
% 2005/01/16: v1.03, lighter verbose display
% 2016/05/11: v1.04, inluded in the PIVMat toolbox, history field fixed


% error(nargchk(1,3,nargin));

Nt = length(f);
Nx = length(f(1).x);
dx = f(1).x(2)-f(1).x(1);

if any(strncmpi(varargin,'full',4))  % consider all values of X and T.
    T = 0:(Nt-1);
    X = 0:(Nx-1);
else  % by default, only the 1st half of X and T values are considered
    T = 0:floor(Nt/2);
    X = 0:floor(Nx/2);
end

corpos = zeros(length(X),length(T));
corneg = zeros(length(X),length(T));

for indT=1:length(T)
    if any(strncmpi(varargin,'verbose',4))
        fprintf([num2str(indT/length(T),1) '%, ']);
    end
    for indX=1:length(X)
        for j=1:(Nt-T(indT))
            m = f(j).w(1:end-X(indX),:) .* f(j+T(indT)).w(1+X(indX):end,:);
            corpos(indX,indT) = corpos(indX,indT) + mean(m(:));
            m = f(j).w(1+X(indX):end,:) .* f(j+T(indT)).w(1:end-X(indX),:);
            corneg(indX,indT) = corneg(indX,indT) + mean(m(:));
        end
    end
end
if any(strncmpi(varargin,'verbose',4))
    fprintf('\n');
end

stc.cor = [corneg(end:-1:2,:) ; corpos(:,:)];
stc.cor = stc.cor / stc.cor(length(X),1); % normalization by C(0,0)
stc.X = dx*[-X(end:-1:2)  X];
stc.T = T;
stc.unitX = f(1).unitx;
stc.unitcor = ['(' f(1).unitw ')^2'];
stc.history = {{f(1).history}' 'spatiotempcorrf(ans)'}';


