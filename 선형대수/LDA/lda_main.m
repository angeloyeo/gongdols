clear; close all; clc;

addpath('C:\Users\icbab\Google 드라이브\여동훈_개인공부정리파일\MATLAB코드모음\wikidocs\PCA\');

% covariance matrix for data1
v1=[1/sqrt(2); 1/sqrt(2)];
v2=[-1/sqrt(2);1/sqrt(2)];
V=[v1 v2];
D=[1,0;0 2];
cov_mtx1 = V*D*inv(V);

% covariance matrix for data2
% v1=[1/sqrt(2); 1/sqrt(2)];
% v2=[-1;0];
% V=[v1 v2];
% D=[1,0;0 2];
% cov_mtx2 = V*D*inv(V);
cov_mtx2 = cov_mtx1;

rng('shuffle')
unit_data1 = randn(50,2);
unit_data2 = randn(50,2);

data1 = unit_data1*cov_mtx1+4;
data2 = unit_data2*cov_mtx2+9;

%% data projection onto a vector

two_dataset_projection(data1,data2,[2;1]);

%% LDA
[V, ratio_var_mtx] = my_lda(data1,data2);

% LDA to project
two_dataset_projection(data1,data2,V(:,2));
% 
% temp1 = data1*ratio_var_mtx;
% temp2 = data2*ratio_var_mtx;
% 
% figure;
% scatter(temp1(:,1), temp1(:,2), 'r', 'filled')
% hold on;
% scatter(temp2(:,1), temp2(:,2), 'b', 'filled')
% 
% [V,D] =eig(ratio_var_mtx)


