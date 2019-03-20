clear; close all; clc;

% 특정한 scalar 함수

[x,y]=meshgrid(-3:0.2:3,-3:0.2:3);


z=peaks(x,y);
f1=figure; 
h_surf=surf(x,y,z);
xlabel('x'); ylabel('y'); zlabel('z');


%%% laplacian은 div(grad(f))임.

% gradient
[grad_x,grad_y]=gradient(z);

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
imagesc(-3:0.2:3,-3:0.2:3,-div) % divergence의 반대 부호가 높이를 나타내기 대문에 (-)를 div 앞에 붙임.
alpha(0.3)
xlabel('x');ylabel('y'); colorbar;

