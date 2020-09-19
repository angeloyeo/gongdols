function res = fun_log_likelihood(x, data)
% likelihood를 계산하는 함수가 정규분포인 경우의 likelihood 계산

res = sum(-log(x(2) * sqrt(2*pi)) - ((data-x(1)).^2/(2*x(2)^2)));