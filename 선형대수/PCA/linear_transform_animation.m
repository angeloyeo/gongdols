function output = linear_transform_animation(data,A)
% data = N x 2 matrix
% A = 2 x 2 matrix
% output = N x 2 matrix

dot_colors = jet(size(data,1));

output = transpose(A*data');

minmin = min(min(data));
maxmax = max(max(data));

xy_min = -max(abs(minmin),abs(maxmax));
xy_max = max(abs(minmin),abs(maxmax));

figure;
set(gcf,'position',[316.2000  215.4000  904.8000  420.0000]);
subplot(1,2,1);
scatter(data(:,1),data(:,2),30,dot_colors,'filled')
grid on;
xlim([xy_min, xy_max]); ylim([xy_min, xy_max]);
set(gcf,'color','white');

subplot(1,2,2);
scatter(data(:,1),data(:,2),30,dot_colors,'filled')
grid on;
xlim([xy_min, xy_max]); ylim([xy_min, xy_max]);
set(gcf,'color','white');

n_steps = 100;
for i_steps = 1:n_steps
    step_mtx = (A-eye(2))/n_steps*i_steps;
    new_xy = (eye(2)+step_mtx)*[data(:,1), data(:,2)]';
    scatter(new_xy(1,:), new_xy(2,:),30,dot_colors,'filled')
    grid on;
    xlim([xy_min, xy_max]); ylim([xy_min, xy_max]);
    set(gcf,'color','white')
    pause(0.001);
end



