clear; close all; clc;

x = linspace(-100,100,500);
% y = 1/3*x + 20*exp(-x.^2/100) -50*exp(-(x-40).^2/100)-20*exp(-(x+40).^2/100) + sin(x).*exp(-x.^2);
y = 1/3*x + 20*sin(x/10).*exp(-x.^2/50000);

plot(x,y)
grid on;
