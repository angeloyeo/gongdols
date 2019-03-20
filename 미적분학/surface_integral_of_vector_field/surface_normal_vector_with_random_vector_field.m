clear; close all; clc;
load('seed_s.mat');
rng(s); % random seed Á¦¾î

[X,Y] = meshgrid(-2:0.25:2,-1:0.2:1);
Z = X.* exp(-X.^2 - Y.^2);
[U,V,W] = surfnorm(X,Y,Z);

figure
surf(X,Y,Z)
view(-35,45)
axis([-2 2 -1 1 -.6 .6])

title('z = xe^{(-x^2-y^2)}')
xlabel('x'); ylabel('y'); zlabel('z');
set(gca,'fontsize',15);


hold on

quiver3(X,Y,Z,U,V,W,0.5,'color','b') % normal vector

% Vector Field
quiver3(X,Y,Z,X+rand(size(X)), Y+rand(size(X)), Z+3*rand(size(X)),0.5,'color','r')