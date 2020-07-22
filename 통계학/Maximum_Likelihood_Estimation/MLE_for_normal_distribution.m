clear; close all; clc;

% sampling from a normal distribution

x = randn(100, 1);
gauss = @(x, mu, sigma) 1/(sigma*sqrt(2*pi))*exp(-1*(x-mu)^2/(2*sigma^2)); % normal dist.

%% 다양한 mu에 대해서 likelihood 계산

mu_list = linspace(-3,3,1000);
mu_likelihood = ones(1, length(mu_list));

for i_mu = 1:length(mu_list)
    mu = mu_list(i_mu);
    sigma = 1;
    
    for i_x = 1:length(x)
        mu_likelihood(i_mu) =  mu_likelihood(i_mu) * gauss(x(i_x), mu, sigma);
    end
end

% plot x's on 1 dim axis

figure;
subplot(3,1,1);
plot(x, 0, 'o','markerfacecolor',lines(1),'markeredgecolor','none')
subplot(3,1,2);
plot(mu_list, mu_likelihood)
subplot(3,1,3);
plot(mu_list, log(mu_likelihood))

%% 다양한 sigma에 대해서 likelihood 계산

sigma_list = linspace(0,3,1000);
sigma_likelihood = ones(1, length(sigma_list));
[~,mu_idx] = max(mu_likelihood);
mu_hat = mu_list(mu_idx);

for i_sigma = 1:length(sigma_list)
    sigma = sigma_list(i_sigma);
    
    for i_x = 1:length(x)
        sigma_likelihood(i_sigma) =  sigma_likelihood(i_sigma) * gauss(x(i_x), mu_hat, sigma);
    end
end

% plot x's on 1 dim axis

figure;
subplot(3,1,1);
plot(x, 0, 'o','markerfacecolor',lines(1),'markeredgecolor','none')
subplot(3,1,2);
plot(sigma_list, sigma_likelihood)
subplot(3,1,3);
plot(sigma_list, log(sigma_likelihood))

[~, sigma_idx] = max(sigma_likelihood);
sigma_hat = sigma_list(sigma_idx);