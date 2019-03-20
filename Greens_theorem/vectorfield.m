function vectorfield(F,xval,yval)
% vectorfield([F1,F2],a:dx:b,c:dy:d)
% Plot 2D vectorfield [F1,F2] for 
% using x-values from a to b with spacing of dx
%       y-values from c to d with spacing of dy

[xg,yg] = meshgrid(xval,yval);             % values x,y on a grid
F1f = inline(vectorize(F(1)),'x','y');
F2f = inline(vectorize(F(2)),'x','y');
F1g = F1f(xg,yg);   % values of F1 on this grid
F2g = F2f(xg,yg);   % values of F1 on this grid
quiver(xg,yg,F1g,F2g,'k')
axis equal; axis tight
