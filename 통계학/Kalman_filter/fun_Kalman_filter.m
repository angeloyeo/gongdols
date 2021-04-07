function [volt, Px, K, x_prior, P_prior, x_posterior, P_posterior] = fun_Kalman_filter(z)
%
%
persistent A H Q R 
persistent x P
persistent firstRun


if isempty(firstRun)
  A = 1;
  H = 1;
  
  Q = 0;
  R = 4;

  x = 14;
  P =  6;
  
  firstRun = 1;  
end

  
xp = A*x; % 상태변수 예측값 (predicted value for state vector, Prior)
Pp = A*P*A' + Q; % 오차 공분산 예측값 (Prior)

K = Pp*H'*inv(H*Pp*H' + R); % 칼만 이득

x = xp + K*(z - H*xp); % 상태 변수 추정값 (Posterior)
P = Pp - K*H*Pp; % 오차 공분산 계산 값 (Posterior)

x_prior = xp;
P_prior = Pp;

x_posterior = x;
P_posterior = P;

volt = x;
Px   = P;