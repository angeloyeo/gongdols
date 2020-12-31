function res = fun_prior(x)
% observation을 봤을 때 평균값은 양수일 것 이라는 것을 예측할 수 있음.
% 따라서 prior는 평균값이 양수이다 라는 정도의 간단한 사전지식을 가지고 만들고자 함.
1
if x(1) <= 0
    res = eps; % 이후 Log-likelihood를 써줄 것이기 때문에 Log(0)은 정의되지 않으므로 epsilon 값을 넣어줌.
else
    res = 1;
end
