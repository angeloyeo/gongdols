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

for i_theta = linspace(0, 2*pi, 4)
    line([cos(i_theta), cos(i_theta + 0.1)], [sin(i_theta), sin(i_theta + 0.1)], [0.1, 0], 'color','r','linewidth',2)
    line([cos(i_theta), cos(i_theta + 0.1)], [sin(i_theta), sin(i_theta + 0.1)], [-0.1, 0], 'color','r','linewidth',2)
end

text(1, 0, -0.3, '$$C$$','interpreter','latex','color','r','fontsize',15)
text(0.5, 0, surface_fun(0.5, 0, -3) + 0.3, '$$S$$','interpreter','latex','color','g','fontsize',30)
caxis([-3 3])
zlim([-3 3])
grid on;
camlight

% gif 녹화를 위한 코드
xlabel('$$x$$','interpreter','latex')
ylabel('$$y$$','interpreter','latex')
zlabel('$$z$$','interpreter','latex')
axis vis3d
% for i = 1:360
%     camorbit(1, 0, 'data')
%     drawnow
% end

%%
nr = 1;
nt = 2;

figure('color','w');
set(gcf,'position',[410 150 560 626]);
my_stokes_GUI(nr,nt)

xlabel('$$x$$','interpreter','latex')
ylabel('$$y$$','interpreter','latex')
zlabel('$$z$$','interpreter','latex')
axis vis3d

% view([90, 90])

newVid = VideoWriter('2curves', 'MPEG-4'); % New
newVid.FrameRate = 30;
newVid.Quality = 100;
open(newVid);
figure(1)
set(gcf,'color','w')
for i = 1:360
    disp(i)
    camorbit(1, 0, 'data')
    writeVideo(newVid, getframe(gcf))
    drawnow
end
close(newVid)

%% changing views
% view(2)
% view(3)
