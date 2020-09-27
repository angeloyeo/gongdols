clear; close all; clc;

%% 이항 분포 만들기

X = [ones(1, 10^6), 2 * ones(1, 10^4)];

% p = 0.01 이므로 np>5 이상이 되려면 n > 5/p가 되어야 하므로 n > 500이 되어야 함.

n = 10000; % the number of samples

%%
k = 500; % 반복 횟수

my_mean = zeros(1, k);
for i = 1:k
    idx2get = randperm(length(X), n);
    my_mean(i) = mean(X(idx2get));
end

figure;
histogram(my_mean)
