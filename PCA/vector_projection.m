function output = vector_projection(data,vector)
% data = N x 2 matrix
% vector = 2 x 1 matrix
% output = N x 2 matrix

A = vector*vector'/norm(vector)^2;
dot_colors = jet(size(data,1));

output = transpose(A*data');

minmin = min(min(data));
maxmax = max(max(data));

xy_min = -max(abs(minmin),abs(maxmax));
xy_max = max(abs(minmin),abs(maxmax));

figure;
set(gcf,'position',[316.2000  215.4000  904  420.0000]);
subplot(1,2,1);
scatter(data(:,1),data(:,2),30,dot_colors,'filled')
grid on;
xlim([xy_min, xy_max]); ylim([xy_min, xy_max]);
hold on;
drawArrow(0,0,vector(1),vector(2),15,{'Color',[1,1,1],'LineWidth',5});
drawArrow(0,0,vector(1),vector(2),10,{'Color',[0,0,0],'LineWidth',3});
title(['Á¤»ç¿µ vector: (',num2str(vector(1)),',',num2str(vector(2)),')']);
hold off;
set(gcf,'color','white');

subplot(1,2,2);
scatter(data(:,1),data(:,2),30,dot_colors,'filled')
grid on;
xlim([xy_min, xy_max]); ylim([xy_min, xy_max]);
set(gcf,'color','white');

n_steps = 30;
for i_steps = 1:n_steps
    step_mtx = (A-eye(2))/n_steps*i_steps;
    new_xy = (eye(2)+step_mtx)*[data(:,1), data(:,2)]';
    scatter(new_xy(1,:), new_xy(2,:),30,dot_colors,'filled')
    grid on;
    xlim([xy_min, xy_max]); ylim([xy_min, xy_max]);
    drawArrow(0,0,vector(1),vector(2),15,{'Color',[1,1,1],'LineWidth',5});
    drawArrow(0,0,vector(1),vector(2),10,{'Color',[0,0,0],'LineWidth',3});
    set(gcf,'color','white')
    drawnow;
    
end


title(['variance = ',num2str(var(output(:)))]);
end

function [ h ] = drawArrow(x1,y1,x2,y2,headwidth,props)

h = annotation('arrow');
set(h,'parent', gca, ...
    'position', [x1,y1,x2-x1,y2-y1], ...
    'HeadLength', 10, 'HeadWidth', headwidth, 'HeadStyle', 'cback1', ...
    props{:} );
end

