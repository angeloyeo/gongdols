clear; close all; clc;

[X,Y]= meshgrid(-2:0.1:2, -2:0.1:2);

Z=X.^2+Y.^2;

figure;
contour(X,Y,transpose(Z),[1/24, 1/12, 1/6, 1/3, 2/3, 1, 1.5, 2, 3, 4, 5, 6]);
colormap(gray)

hold on;
h_g=ezplot('x^2+x*y+y^2=1');

xlim([-2 2])
ylim([-2 2])

axis square
grid on
set(h_g,'linewidth',3);
title('f(x,y)=x^2+y^2; g(x,y)=x^2+xy+y^2=1')