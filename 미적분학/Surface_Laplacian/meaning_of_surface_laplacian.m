clear; close all; clc;

% 특정한 scalar 함수

[x,y]=meshgrid(-pi:0.2:3,-3:0.2:pi);
z=peaks(x,y);

% 3D Surface sinusoidal wave

k1 = 1; % x-dir에서 출렁이는 횟수
k2 = 3; % y-dir에서 출렁이는 횟수

cc = cos(k1*x).*cos(k2*y);
f = z+cc+100;

f1=figure; 
h_surf=surf(x,y,f);
xlabel('x'); ylabel('y'); zlabel('z');


%%% laplacian은 div(grad(f))임.

% gradient
[grad_x,grad_y]=gradient(f);

[zlims]=get(gca,'zlim');
z_quiv3=zlims(1)*ones(size(x));
grad_z=zeros(size(grad_x));
hold on;
h_quiver=quiver3(x,y,z_quiv3,grad_x,grad_y,grad_z);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% surf 끄는 함수
set(h_surf,'visible','off');

% surf 켜는 함수
set(h_surf,'visible','on');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% divergence

div=divergence(x,y,grad_x,grad_y);
figure;
quiver(x,y,grad_x,grad_y)
hold on;
imagesc(-3:0.2:3,-3:0.2:3,-div)
alpha(0.3)
xlabel('x');ylabel('y'); colorbar;

