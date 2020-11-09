function output = vector_projection_3d(data,cov_mtx,dim_to_project)
% data = N x 3 matrix
% cov_mtx: 3 x 3 covariance matrix
% output = N x 3 matrix

% addpath('C:\Users\icbab\Google 드라이브\여동훈_개인공부정리파일\MATLAB코드모음\다른사람_참고code\arrow3\');


[V,D] = eig(cov_mtx);
[~,D_ind]=sort(abs(diag(D)),'descend');
vecs_to_project = V(:,D_ind);
vectors = vecs_to_project(:,1:dim_to_project);

A = vectors*vectors'/norm(vectors)^2;
dot_colors = jet(size(data,1));

output = transpose(A*data');

minmin = min(min(data));
maxmax = max(max(data));

limits = max(abs(minmin),abs(maxmax));
xyz_min = -limits;
xyz_max = limits;

figure;
set(gcf,'position',[316.2000  215.4000  904  420]);
subplot(1,2,1);
scatter3(data(:,1),data(:,2),data(:,3),30,dot_colors,'filled')
grid on;
xlim([xyz_min, xyz_max]); ylim([xyz_min, xyz_max]); zlim([xyz_min, xyz_max])
hold on;
hold off;
set(gcf,'color','white');

pause;

h2=subplot(1,2,2);
scatter3(data(:,1),data(:,2),data(:,3),30,dot_colors,'filled')
grid on;
xlim([xyz_min, xyz_max]); ylim([xyz_min, xyz_max]); zlim([xyz_min, xyz_max]);
set(gcf,'color','white');

n_steps = 10;
for i_steps = 1:n_steps
    step_mtx = (A-eye(3))/n_steps*i_steps;
    new_xy = (eye(3)+step_mtx)*data';
    scatter3(new_xy(1,:), new_xy(2,:), new_xy(3,:), 30,dot_colors,'filled')
    grid on;
    xlim([xyz_min, xyz_max]); ylim([xyz_min, xyz_max]); zlim([xyz_min, xyz_max]);
    set(gcf,'color','white')
    drawnow;
end
title(['variance = ',num2str(var(output(:)))]);
pause;

figure;
scatter(data*vectors(:,1),data*vectors(:,2),30,dot_colors,'filled');

end



