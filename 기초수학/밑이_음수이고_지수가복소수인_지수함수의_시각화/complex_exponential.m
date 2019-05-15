clear; close all; clc;

[x,y]=meshgrid(linspace(-3,3,50));

z = x+1i*y;

f = (-1.5)^z;

surf(x,y,real(f), imag(f))
xlabel('real (z)');
ylabel('imag (z)');
zlabel('real(y)');
