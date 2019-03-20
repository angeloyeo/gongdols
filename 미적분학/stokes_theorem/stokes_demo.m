clear; close all; clc;

%%
r = linspace(0,1,100);
theta = linspace(0,2*pi,500);

[R,T]=meshgrid(r,theta);
x = R.*cos(T);
y = R.*sin(T);

z = surface_fun(x,y,-3);
figure;
set(gcf,'position',[410 150 560 626]);

surf(x,y,z,'facecolor',[0.5 0.8 0.5],'edgecolor','none');
caxis([-3 3])
zlim([-3 3])
grid on;
camlight

%%
nr = 1;
nt = 2;
figure;
my_stokes_GUI(nr,nt)

%% changing views
view(2)
view(3)