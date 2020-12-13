clear; close all; clc;


%% Fig 3. 한 점 (x,y)에서 순간 변화율과 평균 변화율 (동영상)
for x1 = [1, 0.5, 0.1]+1
    plotXY(-1,3,-1,3,true,20)
    x = linspace(-1,3, 100);
    y = 1/3*x.^2 + 1;
    hold on;
    plot(x,y,'k','linewidth',2)
    
    x = linspace(-0.5, 2.5, 100);
    
    plot(x, 2/3*x + 2/3,'b','linewidth',3)
    plot(1, 4/3 ,'o','markerfacecolor','b','markeredgecolor','none','markersize',10)
    
    y1 = 1/3 * x1^2  + 1;
    
    y = (y1-4/3)/(x1-1) * (x-1) + 4/3;
    h(1) = plot(x1, y1, 'o', 'markerfacecolor','r','markeredgecolor','none','markersize',10);
    h(2) = plot(x, y, 'r','linewidth',3);
    
end


%% Fig 3. 한 점 (x,y)에서 순간 변화율과 평균 변화율 (동영상)
clear v
v = VideoWriter('fig3.mp4','MPEG-4');
v.FrameRate = 30;
v.Quality = 100;
open(v);

clear F

plotXY(-1,3,-1,3,true,20)
x = linspace(-1,3, 100);
y = 1/3*x.^2 + 1;
hold on;
plot(x,y,'k','linewidth',2)

x = linspace(-0.5, 2.5, 100);

plot(x, 2/3*x + 2/3,'b','linewidth',3)
plot(1, 4/3 ,'o','markerfacecolor','b','markeredgecolor','none','markersize',10)

i=1;
for x1 = linspace(3,1,100)
    
    
    y1 = 1/3 * x1^2  + 1;
    
    y = (y1-4/3)/(x1-1) * (x-1) + 4/3;
    h(1) = plot(x1, y1, 'o', 'markerfacecolor','r','markeredgecolor','none','markersize',10);
    h(2) = plot(x, y, 'r','linewidth',3);
    drawnow;
    
    F(i)=getframe(gcf);
    if x1>1
        delete(h)
    end
    i=i+1;
end


for i=1:length(F)
    % convert the image to a frame
    frame = F(i) ;
    writeVideo(v, frame);
end

close(v)

%% 3d plot

close all;
[X,Y] = meshgrid(linspace(-3,3,20));

surf(X, Y, -X.^2-Y.^2+1)
xlabel('$$x$$','interpreter','latex'); ylabel('$$y$$','interpreter','latex'); zlabel('$$z=-x^2-y^2+1$$','interpreter','latex');
hold on;
xx = -1 * ones(1,100);
yy = linspace(-3,3,100);
zz = -xx.^2 - yy.^2  + 1;
plot3(xx,yy,zz,'r','linewidth',3)

% tangential line
% (-1, -1, -1)에서...?
% round z round y = - 2y
t = linspace(-0.5,1,100);

x = -1 * ones(1, 100);
y = -2 + 4 * t;
z = -4 + 16*t

plot3(x,y,z,'k','linewidth',3);
plot3(-1,-2,-4,'o','markersize',7,'markerfacecolor','k','markeredgecolor','none')

axis square

