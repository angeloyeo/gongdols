function pca_animation(cov_mtx, input_data,which_eigvec)
% cov_mtx: 2 x 2 covariance matrix
% input_data = N x 2 matrix. N = # samples.
% which_eigvec = 1 or 2. Depending on which eigenvector you want to project
% onto.

dot_colors = jet(size(input_data,1));

minmin = min(min(input_data));
maxmax = max(max(input_data));

limits = max(abs(minmin), abs(maxmax));

figure;
scatter(input_data(:,1), input_data(:,2) ,30,dot_colors,'filled')
grid on;
xlim([-limits, limits]); ylim([-limits, limits]);

disp('Press any key to continue watching PCA animation.')
pause

[V,D] = eig(cov_mtx);

eig_values = diag(D);

[~,I]=sort(eig_values,'descend');

A = V(:,I(which_eigvec))*V(:,I(which_eigvec))'; % projection matrix

n_steps = 100;

for i_steps = 1:n_steps
    step_mtx = (A-eye(2))/n_steps*i_steps;
    new_xy = (eye(2)+step_mtx)*input_data';
    scatter(new_xy(1,:), new_xy(2,:),30,dot_colors,'filled')
    grid on;
    xlim([-limits, limits]); ylim([-limits, limits]);
    pause(0.001);
end

