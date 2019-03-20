clear; close all; clc;

% surface integral 계산 --> 이중적분으로

fun = @(s,t) s.*(2*t.^2+(2*t+1).*(4-t.^2-s.^2));
xmin = -2;
xmax = 2;
ymin = @(t) -sqrt(4-t.^2);
ymax = @(t) sqrt(4-t.^2);

q = integral2(fun,xmin,xmax,ymin,ymax)