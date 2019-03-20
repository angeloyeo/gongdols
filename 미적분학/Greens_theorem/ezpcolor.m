function ezpcolor(f,ra)
% ezpcolor(f,[x1 x2 y1 y2])
% pseudocolor plot of function f for x in [x1,x2], y in [y1,y2]
% f is symboic expression of x,y

N = 50;
xval = linspace(ra(1),ra(2),N);
yval = linspace(ra(3),ra(4),N);
[xg,yg] = meshgrid(xval,yval);       % values x,y on grid
ff = inline(vectorize(f),'x','y');
fg = ff(xg,yg);                      % values of f on this grid
pcolor(xg,yg,fg)
axis equal; shading interp

set(gcf,'Renderer','painters')
