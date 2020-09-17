clear; close all; clc;

rng(1)
n = 500;
target = @(x) 0.3*exp(-0.2 * x.^2) + 0.7 * exp(-0.2 * (x - 10).^2);
xx = linspace(-10,20, 1000);

%% Uniform distribution을 proposal distribution으로 두고 sampling
% 성능에 크게 차이는 없으나 reject되는 sample 수가 조금 차이가 있음.

pseudo_dist2 = @(x) (x>=-10 * x<20) / 30;

figure;
plot(xx, target(xx));
hold on;
plot(xx, pseudo_dist2(xx)*21); % 21은 30 * 0.7을 얘기함. 30은 출력값이 1인 x의 범주, 0.7은 target의 최고 높이.

x_q = (rand(1, n) - 0.5) * 30 + 5; % -10에서 20사이의 uniform distribution

crits = target(x_q) ./ (pseudo_dist2(x_q) * 21);
coins = rand(1, length(crits));

x_p_uniform = x_q(coins<crits);

figure; h = histogram(x_p_uniform,'BinWidth',0.5, 'Normalization','probability');
hold on; plot(xx, target(xx)/max(target(xx))*max(h.Values))
