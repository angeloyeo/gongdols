clear; close all; clc;

% A = [2 2;2 7];
% A =[1,3;4,2]/4;
A=[2,1;1,2]; % shear
% angle = pi/2; A = [cos(angle) -sin(angle); sin(angle) cos(angle)]; %rotation
% A = [0, 1; 1, 0]; % permutation
% A = [1,0;0,0]; % projection
% vector = [1,2]'; A = vector*vector'; % projection on a vector


%% animation with DOTS
n_steps = 100;
[x,y] = ndgrid(-1:0.15:1);
xy_min = min(min(A*[x(:), y(:)]'))*1.5;
xy_max = max(max(A*[x(:), y(:)]'))*1.5;

dot_colors = jet(length(x(:)));

figure(2);
set(gcf,'color','w')
set(gcf,'position',[250 120 960 540])
scatter(x(:), y(:),30,dot_colors,'filled')
grid on;
xlim([xy_min, xy_max]); ylim([xy_min, xy_max]);
% pause;

step_mtx = (A-eye(2))/n_steps;

for i_steps = 1:n_steps    
    
    new_xy = (eye(2)+step_mtx*i_steps)*[x(:), y(:)]';
    scatter(new_xy(1,:), new_xy(2,:),30,dot_colors,'filled')
    
    
    grid on;
    xlim([xy_min, xy_max]); ylim([xy_min, xy_max]);
    axis square
    
    pause(0.01);
end

%%
v = VideoWriter('permutation_transform.mp4','MPEG-4');
v.Quality = 100;

open(v);
writeVideo(v,F);
close(v);

