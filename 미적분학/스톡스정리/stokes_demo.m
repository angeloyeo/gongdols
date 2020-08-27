clear; close all; clc;

%%
r = linspace(0,1,100);
theta = linspace(0,2*pi,500);

[R,T]=meshgrid(r,theta);
x = R.*cos(T);
y = R.*sin(T);

z = surface_fun(x,y,-3);
figure('color','w');
set(gcf,'position',[410 150 560 626]);

surf(x,y,z,'facecolor',[0.5 0.8 0.5],'edgecolor','none');
hold on;
plot3(cos(theta), sin(theta), zeros(1, 500), 'r','linewidth',2)
% arrow3([1, 0, 0], [1, 0.5, 0])
caxis([-3 3])
zlim([-3 3])
grid on;
camlight

% gif 녹화를 위한 코드
xlabel('$$x$$','interpreter','latex')
ylabel('$$y$$','interpreter','latex')
zlabel('$$z$$','interpreter','latex')
axis vis3d
for i = 1:360
    camorbit(1, 0, 'data')
    drawnow
end

%%
nr = 1;
nt = 2;
figure;
my_stokes_GUI(nr,nt)

%% changing views
view(2)
view(3)
