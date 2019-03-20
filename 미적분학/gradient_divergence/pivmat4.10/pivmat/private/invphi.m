function xi = invphi(dx,n)
%INVPHI  Inverse of the PHI function, used by SURFHEIGHT
%   XI = INVPHI(DX,N) gives the slope XI as a function of the displacement
%   DX and the refraction index N. This is used by SURFHEIGHT in mode 3.
%
%   Example:
%     dx = linspace(0,0.5,100);
%     xi = invphi(dx,1.33);
%     plot(dx,xi);
%
%   See also SURFHEIGHT. 


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.01,  Date: 2007/06/14
%   This function is part of the PIVMat Toolbox


% History:
% 2007/05/21: v1.00, first version.
% 2007/06/14: v1.01, bug fix: did not work with matrix! (length vs numel)


if nargin==1
    n=1.33;  % default value
end

xi=dx;   % pre-allocation (xi has the size of dx)

for i=1:numel(dx)
    if abs(dx(i)) < tan(pi/2 - asin(1/n))
        xi0 = dx(i)/(1-1/n);  % initial guess = linear approx
        % find the zero of the difference between dx and phi(xi):
        xi(i) = fzero(@(xi) ddxphi(xi,dx(i),n), xi0);
    else
        xi(i) = NaN;
    end
end

    % nested function : difference between dx and phi(xi)
    function d = ddxphi(xi,dx,n)
        d = dx - tan(atan(xi) - asin(sin(atan(xi))/n));
    end

end
