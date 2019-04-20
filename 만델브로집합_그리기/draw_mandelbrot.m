
function draw_mandelbrot(x0, x1, y0, y1)

n_grid = 1000;

[x,y] = meshgrid(linspace(x0,x1,n_grid), linspace(y0,y1,n_grid));

c = x + 1i*y;
z = c;
n_iter = 100;
M = zeros(size(c));

for i = 1:n_iter
    z = z.^2 + c;
    M(M==0 & abs(z)>2) = n_iter-i;
end


imagesc(x(1,:), y(:,1),M)
colormap jet



    