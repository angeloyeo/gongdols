clear; close all; clc;

load('YaleB_32x32.mat'); % gnd는 사람 번호인듯.
% 출처: http://www.cad.zju.edu.cn/home/dengcai/Data/FaceData.html
% 사용한 데이터셋의 이름은 Extended Yale Face Database B임.

figure('position',[556, 237, 947, 699]);
for i= 1:25
    subplot(5,5,i)
    imagesc(reshape(fea(i,:), 32, 32)); colormap('gray')
end

%% NMF 수행하기
n_features = 25;
[W, H] = nnmf(fea, n_features);

figure('position',[556, 237, 947, 699]);
for i_features = 1:n_features
    subplot(5,5,i_features)
    imagesc(reshape(H(i_features,:), 32, 32)); colormap('gray');
end

% figure; imagesc(reshape(randn(1, 25) * H, 32, 32)); colormap('gray')

%% PCA 수행하기

[coeff, score, latent] = pca(fea);

figure('position',[556, 237, 947, 699]);
for i_features = 1:n_features
    subplot(5,5,i_features)
    imagesc(reshape(coeff(:, i_features), 32, 32)); colormap('gray');
end
