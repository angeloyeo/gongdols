clear; close all; clc;

A = [2,1;1,2];

XLIMs = [-5,5];
YLIMs = [-5,5];

vert_u = [XLIMs(1):XLIMs(2); ones(1,diff(XLIMs)+1)*XLIMs(2)];
vert_d = [YLIMs(1):YLIMs(2); ones(1,diff(YLIMs)+1)*YLIMs(1)];

hori_r = [ones(1,diff(YLIMs)+1)*XLIMs(2); YLIMs(1):YLIMs(2)];
hori_l = [ones(1,diff(YLIMs)+1)*XLIMs(1); YLIMs(1):YLIMs(2)];
% figure;
% for i=1:size(vert_u,2)
%     line([vert_u(1,i) vert_d(1,i)],[vert_u(2,i) vert_d(2,i)],'color','k');
%     hold on;
%     line([hori_l(1,i) hori_r(1,i)],[hori_l(2,i) hori_r(2,i)],'color','k');
% end

xlim(XLIMs)
ylim(YLIMs)

Avert_u = A*vert_u;
Avert_d = A*vert_d;
Ahori_r = A*hori_r;
Ahori_l = A*hori_l;
% figure;
% for i=1:size(vert_u,2)
%     line([Avert_u(1,i) Avert_d(1,i)],[Avert_u(2,i) Avert_d(2,i)],'color','k');
%     hold on;
%     line([Ahori_l(1,i) Ahori_r(1,i)],[Ahori_l(2,i) Ahori_r(2,i)],'color','k');
% end
% xlim(XLIMs)
% ylim(YLIMs)

%% animation으로 만들기
% A = [2,1;1,2];
% theta = pi/3;
% A = [cos(theta) -sin(theta);sin(theta) cos(theta)];

% A = [0,1;1,0];
% 
vec = [1,2]';
A = vec*vec';

v = VideoWriter('ani4_proj.mp4','MPEG-4');
open(v);
n_steps = 100;
figure;
set(gcf,'color','w');

step_mtx = (A-eye(2))/n_steps;
for i_steps = 0:n_steps
%     figure;
    for i=1:size(vert_u,2)
        line([vert_u(1,i) vert_d(1,i)],[vert_u(2,i) vert_d(2,i)],'color',[159 161 165]/255);
        hold on;
        line([hori_l(1,i) hori_r(1,i)],[hori_l(2,i) hori_r(2,i)],'color',[159 161 165]/255);
    end

    new_vert_u = (eye(2)+step_mtx*i_steps)*vert_u;
    new_vert_d = (eye(2)+step_mtx*i_steps)*vert_d;
    new_hori_r = (eye(2)+step_mtx*i_steps)*hori_r;
    new_hori_l = (eye(2)+step_mtx*i_steps)*hori_l;
    for i = 1:size(vert_u,2)
        line([new_vert_u(1,i) new_vert_d(1,i)],[new_vert_u(2,i) new_vert_d(2,i)],'color','k');
        hold on;
        line([new_hori_l(1,i) new_hori_r(1,i)],[new_hori_l(2,i) new_hori_r(2,i)],'color','k');
    end
    xlim(XLIMs);
    ylim(YLIMs);
%     
%     if i_steps ==0
%         pause;
%     end
    
%     pause(0.01);
    F(i_steps+1) = getframe(gcf);

    if i_steps<n_steps
        cla;
    end
    
end

    
writeVideo(v,F);
close(v)