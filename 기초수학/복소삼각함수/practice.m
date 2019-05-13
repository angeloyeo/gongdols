clear; close all; clc;

[X,Y] = meshgrid(linspace(-5,5,100));

Z = tan(X+1i*Y);

figure;
surf(X,Y,real(Z));
xlabel('Real'); ylabel('Imag')
colormap(jet)

figure;
surf(X,Y,imag(Z));
xlabel('Real'); ylabel('Imag')


figure;
surf(X,Y,real(Z));
xlabel('Real'); ylabel('Imag')
ylim([0 1])
zlim([-1 1])