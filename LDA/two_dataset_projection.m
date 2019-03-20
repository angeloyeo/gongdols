function [output1, output2] = two_dataset_projection(data1, data2, vector)
% data1 = N x 2 matrix
% data2 = N x 2 matrix
% vector = 2 x 1 matrix
% output = N x 2 matrix

A = vector*vector'/norm(vector)^2;

output1 = transpose(A*data1');
output2 = transpose(A*data2');

%xlim
xlim_max = max([data1(:,1);data2(:,1)]);
xlim_min = min([data1(:,1);data2(:,1)])-3;
ylim_max = max([data1(:,2);data2(:,2)]);
ylim_min = min([data1(:,2);data2(:,2)])-3;

figure;
set(gcf,'position',[316.2000  215.4000  904  420.0000]);
subplot(1,2,1);
scatter(data1(:,1),data1(:,2),30,'r','filled')
hold on;
scatter(data2(:,1),data2(:,2),30,'b','filled')
grid on;
ax=gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
xlim([xlim_min, xlim_max]); ylim([ylim_min, ylim_max]);
drawArrow(0,0,vector(1),vector(2),15,{'Color',[1,1,1],'LineWidth',5});
drawArrow(0,0,vector(1),vector(2),10,{'Color',[0,0,0],'LineWidth',3});
title(['Á¤»ç¿µ vector: (',num2str(vector(1)),',',num2str(vector(2)),')']);
hold off;
set(gcf,'color','white');

subplot(1,2,2);
scatter(data1(:,1),data1(:,2),30,'r','filled')
hold on;
scatter(data2(:,1),data2(:,2),30,'b','filled')
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
grid on;
drawArrow(0,0,vector(1),vector(2),15,{'Color',[1,1,1],'LineWidth',5});
drawArrow(0,0,vector(1),vector(2),10,{'Color',[0,0,0],'LineWidth',3});
xlim([xlim_min, xlim_max]); ylim([ylim_min, ylim_max]);
set(gcf,'color','white');
pause;

n_steps = 30;
for i_steps = 1:n_steps
    step_mtx = (A-eye(2))/n_steps*i_steps;
    new_xy1 = (eye(2)+step_mtx)*data1';
    new_xy2 = (eye(2)+step_mtx)*data2';
    
    scatter(new_xy1(1,:), new_xy1(2,:),30,'r','filled')
    hold on;
    scatter(new_xy2(1,:), new_xy2(2,:),30,'b','filled')
    hold off;
    ax=gca;
    ax.XAxisLocation = 'origin';
    ax.YAxisLocation = 'origin';
    grid on;
    
    xlim([xlim_min, xlim_max]); ylim([ylim_min, ylim_max]);
    drawArrow(0,0,vector(1),vector(2),15,{'Color',[1,1,1],'LineWidth',5});
    drawArrow(0,0,vector(1),vector(2),10,{'Color',[0,0,0],'LineWidth',3});
    set(gcf,'color','white')
    drawnow;
    
end
pause;
[inv_rot_output1, ~] = plot_rotated_gaussian(vector, output1,'r');
[inv_rot_output2, ~] = plot_rotated_gaussian(vector, output2,'b');

[~,~,ci, stats]= ttest2(inv_rot_output2(:,1), inv_rot_output1(:,1))

title(['t-value = ',num2str(stats.tstat)]);

end

function [ h ] = drawArrow(x1,y1,x2,y2,headwidth,props)

h = annotation('arrow');
set(h,'parent', gca, ...
    'position', [x1,y1,x2-x1,y2-y1], ...
    'HeadLength', 10, 'HeadWidth', headwidth, 'HeadStyle', 'cback1', ...
    props{:} );
end

function [inv_rot_output1, rot_normal_result]=plot_rotated_gaussian(vector, data, dist_color)

theta = atan(vector(2)/vector(1));
rot_mtx = [cos(theta) -sin(theta);sin(theta) cos(theta)];
inv_rot_output1 = transpose(inv(rot_mtx)*data');
inv_rot_data = linspace(min(inv_rot_output1(:,1)),max(inv_rot_output1(:,1)),100);
inv_rot_output1_norm = 10*normpdf(inv_rot_data,mean(inv_rot_output1(:,1)),std(inv_rot_output1(:,1)));
rot_normal_result = transpose(rot_mtx*[inv_rot_data;inv_rot_output1_norm]);

hold on;
plot(rot_normal_result(:,1),rot_normal_result(:,2),dist_color)
hold off;

end