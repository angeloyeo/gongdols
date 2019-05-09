clear; close all; clc;

%% Fig 1
x1 = -500;
x2 = 500;
x = linspace(x1,x2,500000);
% y = 1/3*x + 20*exp(-x.^2/100) -50*exp(-(x-40).^2/100)-20*exp(-(x+40).^2/100) + sin(x).*exp(-x.^2);
y = 1/3*x + 20*sin(x/10).*exp(-x.^2/50000) + sin(x*10);

plotXY(x1,x2,x1,x2, true)
grid on;
hold on;
plot(x,y)