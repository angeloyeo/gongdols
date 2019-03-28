clear; close all; clc;

% vector field
% f(x,y)=(y^2)i

[x,y]=meshgrid(0:.125:2,0:.125:2);

u=2*x;
v=zeros(size(y));

quiver(x,y,u,v)

grid on;
xlabel('x'); 
ylabel('y');


div=divergence(x,y,u,v);
hold on;
imagesc(0:.125:2,0:.125:2,transpose(div))
colormap(jet); colorbar
alpha(0.2)

% xy 평면에서 없어지고 생겨나는 벡터장
clear; close all; clc;

[x,y]=meshgrid(-1:0.9:10,-1:0.9:10);

u=(x-2).*(x-8);
v=(y-2).*(y-8);

quiver(x,y,u,v);
grid on;
xlabel('x');
ylabel('y');


div=divergence(x,y,u,v);

hold on;
imagesc(-1:0.9:10,-1:0.9:10,transpose(div))
colormap(jet); y=colorbar;
ylabel(y, 'divergence')
alpha(0.2)
axis tight