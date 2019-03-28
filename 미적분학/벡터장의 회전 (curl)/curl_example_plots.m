clear; 

clear; close all; clc;

x_smpl=-1:0.3:1;
y_smpl=-1:0.3:1;
% z_smpl=-1:0.1:1;
[x,y]=meshgrid(x_smpl,y_smpl);

u=y;
v=zeros(size(x));


quiver(x,y,u,v);
grid on;
xlabel('x');
ylabel('y');
xlim([x_smpl(1) x_smpl(end)])
ylim([y_smpl(1) y_smpl(end)])
% zlabel('z');

axis tight


% 
% div=divergence(x,y,u,v);
% hold on;
% imagesc(-2:.5:2,-2:.5:2,transpose(div))
% colormap(jet); colorbar
% alpha(0.2)
% 

crl=curl(x,y,u,v);
hold on;
imagesc(x_smpl,y_smpl,transpose(crl))
colormap(jet); colorbar
alpha(0.2)

