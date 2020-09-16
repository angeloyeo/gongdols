clear; close all; clc;

%% rejection sampling을 통해 data를 sampling
% target distribution과 유사 분포 
target = @(x) 0.3*exp(-0.2 * x.^2) + 0.7 * exp(-0.2 * (x - 10).^2);
pseudo_dist = @(x, mu, sigma) 1/(sigma*sqrt(2*pi)) * exp(-((x-mu).^2)/(2*sigma^2));

xx = linspace(-10,20, 1000);

figure; 
plot(xx, target(xx))
hold on;
plot(xx, 20 * pseudo_dist(xx, 6.5, 4.5)) % 유사 분포는 target 분포를 감쌀 수 있어야 함.

% rejection sampling 시작
rng(1)
n = 50000;
x_q = randn(1, n) * 4.5 + 6.5; % 유사분포의 x 값을 sampling.

crits = ...
    target(x_q) ./ ...
    (pseudo_dist(x_q, 6.5, 4.5) * 20); % 유사 분포에서 나온 값들을 envelope에 다시 집어넣기.
coins = rand(1, length(crits));

x_p = x_q(coins<crits);
figure; h = histogram(x_p,'BinWidth',0.5, 'Normalization','probability');
hold on; plot(xx, target(xx)/max(target(xx))*max(h.Values))
