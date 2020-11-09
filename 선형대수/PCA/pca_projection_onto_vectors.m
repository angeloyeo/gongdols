clear; close all; clc;
rng(2); %for reproducibility
cov_mtx=[2,1;1,2];

%% data scatter plot
xy = randn(1000,2);
xy_min = min(min(cov_mtx*xy'));
xy_max = max(max(cov_mtx*xy'));
new_xy = cov_mtx*xy';

%% projection
% 
[V,D] = eig(cov_mtx);
proj_vec= V(:,2)*D(2,2);
% proj_vec= V(:,1)*D(1,1);

% proj_vec = [-2,1]';

output = vector_projection(transpose(new_xy),proj_vec);

