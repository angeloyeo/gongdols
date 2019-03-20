clear; close all; clc;
rng(2); %for reproducibility
A=[2,1;1,2]; % shear
% angle = pi/2; A = [cos(angle) -sin(angle); sin(angle) cos(angle)]; %rotation
% A = [0, 1; 1, 0]; % permutation
% A = [1,0;0,0]; % projection
% vector = [1,2]'; A = vector*vector'; % projection on a vector

%% eigshow
% figure;
% eigshow(A) % Numerical Computing with MATLAB toolbox 다운로드 필요함.

%% animation
n_steps = 50;
xy = randn(1000,2);
dot_colors = jet(length(xy));

xy_min = min(min(A*xy'));
xy_max = max(max(A*xy'));

lims = max(abs(xy_min), abs(xy_max));
figure(2);

scatter(xy(:,1),xy(:,2),30,dot_colors,'filled')
grid on;
xlim([-lims, lims]); ylim([-lims, lims]);
set(gca,'fontsize',15);
set(gcf,'color','white')
[V,D]=eig(A);

for i_steps = 1:n_steps
    step_mtx = (A-eye(2))/n_steps*i_steps;
    new_xy = (eye(2)+step_mtx)*xy';
    scatter(new_xy(1,:), new_xy(2,:),30,dot_colors,'filled')
    grid on;
    hold on;
    vector1 = D(1,1)*V(:,1);
    my_drawArrow(0,0,vector1(1),vector1(2),15,{'Color',[1,1,1],'LineWidth',5});
    my_drawArrow(0,0,vector1(1),vector1(2),10,{'Color',[0,0,0],'LineWidth',3});
    vector2 = D(2,2)*V(:,2);
    my_drawArrow(0,0,vector2(1),vector2(2),15,{'Color',[1,1,1],'LineWidth',5});
    my_drawArrow(0,0,vector2(1),vector2(2),10,{'Color',[0,0,0],'LineWidth',3});
    
    hold off;
    xlim([-lims, lims]); ylim([-lims, lims]);
    set(gca,'fontsize',15);
    set(gcf,'color','white')
    pause(0.001);
end
