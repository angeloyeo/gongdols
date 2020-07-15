clear; close all; clc;
%%
app_point = [5,5];
n_order = 10;
%%
[X,Y] = meshgrid(linspace(-5,5,30), linspace(-5,5,30));
figure('color','w');
surf(X,Y,Y.*sin(X) - X.*cos(Y) + exp(Y)/10,'facecolor',[50 50 50]/255,'facealpha',0.3)
zlim([-10 10])
title('f(x,y)=ysin(x)-xcos(y)+e^x/10')
hold on;
my_color = lines(n_order);
my_width = 2;
for i_order = 1:n_order
    syms X Y;
    my_f = feval(symengine,'mtaylor',Y.*sin(X) - X.*cos(Y) + exp(Y)/10, ['[X=',num2str(app_point(1)),', Y=',num2str(app_point(2)),']'] ,i_order); 
    h = fsurf(my_f,[app_point(1)-my_width, app_point(1)+my_width, app_point(2)-my_width, app_point(2)+my_width],...
        'facecolor',my_color(i_order,:),'edgecolor','none','facealpha',1);
    plot3(app_point(1), app_point(2), app_point(2).*sin(app_point(1)) - app_point(1).*cos(app_point(2)) + exp(app_point(2))/10,'r.','markersize',10);
    line([app_point(1) app_point(1)],[-5 5],[-10 -10],'color','r','linestyle','--')
    line([-5 5],[app_point(2) app_point(2)],[-10 -10],'color','r','linestyle','--')
    line([app_point(1) app_point(1)],[app_point(2) app_point(2)],[-10, app_point(2).*sin(app_point(1)) - app_point(1).*cos(app_point(2)) + exp(app_point(2))/10],'color','r','linestyle','--')
    zlim([-10 10])
    xlabel('x');
    ylabel('y');
    [caz, cel] = view;
    
    pause(0.1);
    if i_order < n_order
        delete(h);
    else
        for i = 1:100
            view(caz + 360 * i / 300, cel)
            drawnow
        end
        
    end
end

