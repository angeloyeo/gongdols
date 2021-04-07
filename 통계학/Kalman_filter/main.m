clear; close all; clc;
% 매우 간단한 칼만 필터 구현
% 수레가 등속운동을 하는 상태를 가정함.
% 이 때, 수레의 위치를 측정하는 센서가 있다고 하자.
% 우리는 칼만 필터를 이용해 다음번 위치를 예측/갱신 하고자 함.

%% DEFINE
dt = 0.1;
t  = 0:dt:10;
Nsamples = length(t);

x = zeros(1, Nsamples);
xp = zeros(1, Nsamples); % Prior 위치 초기값
P = zeros(1, Nsamples);
Pp = zeros(1, Nsamples); % Prior 공분산 초기값
z = zeros(1, Nsamples); % measurement vector 초기화
z_real = zeros(1, Nsamples);
K = zeros(1, Nsamples); % Kalman gain 저장 용

A = 1; % 다음 상태로의 transition은 특별한 변화 없이 일어난다고 하자.
H = 1; % 상태 벡터를 그대로 measure할 수 있다고 하자. 
Q = 3; % process noise에 대한 공분산. 
R = 10; % 측정 시 오차에 관한 공분산.

%% 초기값 설정
x(1) = 0; % 최초의 위치 추정값
P(1) = 10; % Posterior(와 모수 간)의 공분산 초기값
z(1) = 0;
K(1) = 1;

%% 칼만필터 작동

for k=2:Nsamples
    % 등속운동을 한다고는 하지만 속도 측정 시에 오차가 있을 수 있다.
    
    vel_error = randn(1, 1) * 50;
    vel = 10 + vel_error;
    
    z(k) = z_real(k-1) + vel * dt;
    z_real(k) = z_real(k-1) + (vel-vel_error) * dt;
    
    xp(k) = A * x(k-1);
    Pp(k) = A * P(k-1) * A' + Q;
    
    K(k) = Pp(k) * H' / (H*Pp(k)*H' + R);
    
    x(k) = xp(k) + K(k) * (z(k) - H * xp(k));
    P(k) = Pp(k) - K(k) * H * Pp(k);
end
%%
figure;
plot(P,'o')

%% 매 회 칼만 필터가 추정하는 Prior와 Posterior의 분포?

clear h
figure;

xx = linspace(0,100,10000);
for k = 1:Nsamples
    % Measurement 분포 plot
    pdf_measure = normpdf(xx, z(k), 5); % w가 4일 것이라고 미리 결정해둔 것
    
    % Prior의 분포 plot
    pdf_prior = normpdf(xx, xp(k), Pp(k));
    
    % Posterior의 분포 plot
    pdf_posterior = normpdf(xx, x(k), P(k));
    
    h(1) = plot(xx, pdf_measure);
    hold on;
    h(2) = plot(xx, pdf_prior);
    h(3) = plot(xx, pdf_posterior);
    hold off;
%     legend(h, 'Measurement','Predicted State Estimate(Prior)','Optimal State Estimate(Posterior)','location','eastoutside');
    ylim([0, 1])
    if k < Nsamples
        pause; cla;
    end
end


%%
figure;
plot(z,'o');
hold on;
plot(x) % 뭐가 잘못된거지?
plot(z_real)