clear; close all; clc;

A = [2 2;2 7];
% A=[2,1;1,2]; % shear
% angle = pi/2; A = [cos(angle) -sin(angle); sin(angle) cos(angle)]; %rotation
% A = [0, 1; 1, 0]; % permutation
% A = [1,0;0,0]; % projection
% vector = [1,2]'; A = vector*vector'; % projection on a vector

%% eigshow
% figure;
% eigshow(A) % Numerical Computing with MATLAB toolbox 다운로드 필요함.

%% animation
n_steps = 100;
step_mtx = eye(2);
[x,y] = ndgrid(-1:0.15:1);
xy_min = min(min(A*[x(:), y(:)]'));
xy_max = max(max(A*[x(:), y(:)]'));

if xy_min ==-1
    xy_min = -2;
end

if xy_max ==1
    xy_max = 2;
end

dot_colors = jet(length(x(:)));

figure(2);
scatter(x(:), y(:),30,dot_colors,'filled')
grid on;
xlim([xy_min, xy_max]); ylim([xy_min, xy_max]);
pause;
for i_steps = 1:n_steps
    step_mtx = (A-eye(2))/n_steps*i_steps;
    
    new_xy = (eye(2)+step_mtx)*[x(:), y(:)]';
    scatter(new_xy(1,:), new_xy(2,:),30,dot_colors,'filled')
    grid on;
    xlim([xy_min, xy_max]); ylim([xy_min, xy_max]);
    pause(0.01);
end

