clear; close all; clc;

[X,Y] = meshgrid(linspace(-3,3,30));

z = X+1i*Y;

surf(X,Y,abs(log(z)),angle(log(z)));

idx2plot = abs(Y)-mean(abs(Y))==0;
hold on;
plot3(linspace(1,3,50),zeros(1,50),abs(log(linspace(1,3,50))),'r')
