clear; close all; clc;
%{
본 MATLAB 스크립트에서는 Markov Chain Monte Carlo를 구현하고자 한다.
참고한 내용은 아래와 같다.

https://github.com/Joseph94m/MCMC/blob/master/MCMC.ipynb

위의 원래 코드에서는 표준편차에 대해 추정하였으나, 이번 MATLAB implementation에서는 평균값을 추정하도록 변경하고자 한다.
%}

%% 모집단과 표본을 선정.
rng(1); % for reproduction

% 모집단 선정. 전체 3만개의 모집단이 있다고 하자.
population = randn(30000, 1) * 3 + 10;
observation = population(randperm(length(population), 1000)); % 전체 모집단 중 현재 1000개 표본만을 추출 가능했다고 하자.

figure;
histogram(observation);

std_obs = std(observation); % 우리가 표본 집단을 통해서 확인한 표준편차

%% metropolis_hastings 알고리즘 돌려보기

total_iteration = 50000;
initial_guess = [1, std_obs];
[accepted, rejected] = fun_metropolis_hastings(initial_guess, total_iteration, observation);

%% 처음 50개의 iteration 동안의 accept, reject 확인

figure;
plot(rejected(1:50), 'rx');
hold on;
plot(accepted(1:50),'b.');

%% 전체 iteration 동안의 accept, reject 확인

figure;
plot(rejected, 'rx');
hold on;
plot(accepted,'b.');

%% rejected 된 경우만 plot
figure;
plot(rejected,'.');

%% 
% burn-in period를 처음의 25%라고 가정하고, 뒤의 75%의 추정 평균의 평균값을 가지고 최종 추정 평균값을 계산하자.

mu_estimated = mean(accepted(round(length(accepted) * 0.25):end));

population_est = randn(30000, 1) * std_obs + mu_estimated;

figure;
h1 = histogram(population);
hold on;
h2 = histogram(population_est);

legend([h1, h2], '원래의 모집단', '추정된 모집단')