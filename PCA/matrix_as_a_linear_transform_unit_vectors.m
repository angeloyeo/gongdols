clear; close all; clc;

% A=[2,1;1,2]; % shear
% angle = pi/2; A = [cos(angle) -sin(angle); sin(angle) cos(angle)]; %rotation
A = [0, 1; 1, 0]; % permutation
% A = [1,0;0,0]; % projection
% vector = [1,2]'; A = vector*vector'; % projection on a vector

%% eigshow
% figure;
% eigshow(A) % Numerical Computing with MATLAB toolbox 다운로드 필요함.

%% animation
n_steps = 100;
xy = [1,0;0,1]; % unit vector
dot_colors = [1,0.3,0.5; 0.3,0.4,1];

xy_min = min(min(A*xy'));
xy_max = max(max(A*xy'));

lims = max(abs(xy_min), abs(xy_max));
figure(2);
quiver(0,0,xy(1,1),xy(2,1),0,'linewidth',2,'color',dot_colors(1,:))
hold on;
quiver(0,0,xy(1,2),xy(2,2),0,'linewidth',2,'color',dot_colors(2,:))
text(xy(1,1)/2,xy(2,1)/2+lims/16,'$$\hat{i}$$','Interpreter','Latex','fontsize',15)
text(xy(1,2)/2-lims/16,xy(2,2)/2,'$$\hat{j}$$','Interpreter','Latex','fontsize',15)
grid on;
xlim([-lims, lims]); ylim([-lims, lims]);

for i_steps = 1:n_steps
    step_mtx = (A-eye(2))/n_steps*i_steps;
    new_xy = (eye(2)+step_mtx)*xy';
    quiver(0,0,new_xy(1,1),new_xy(2,1),0,'linewidth',2,'color',dot_colors(1,:))
    hold on;
    quiver(0,0,new_xy(1,2),new_xy(2,2),0,'linewidth',2,'color',dot_colors(2,:))
    text(new_xy(1,1)/2,new_xy(2,1)/2+lims/16,'$$\hat{i}$$','Interpreter','Latex','fontsize',15)
    text(new_xy(1,2)/2-lims/16,new_xy(2,2)/2,'$$\hat{j}$$','Interpreter','Latex','fontsize',15)
    grid on;
    xlim([-lims, lims]); ylim([-lims, lims]);
    hold off;
    pause(0.001);
end

