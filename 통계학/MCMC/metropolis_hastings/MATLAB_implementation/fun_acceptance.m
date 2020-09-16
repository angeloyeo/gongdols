function res = fun_acceptance(x, x_new)
% Likelihood * Prior를 비교
% x나 x_new나 모두 Likelihood  * Prior의 값임.
% x는 이전의 x에 대한 L * P 이고 x_new는 새롭게 제안된 x에 대한 L * P 임.

if x_new > x
    res = true;
    
else
    accept = rand(1);
    
    if accept < exp(x_new-x) % log-likelihood 를 이용해 얻은 결과이므로 exponential을 이용해 다시 원래의 우도로 돌려주어야 함.
        res = true;
    else
        res= false;
    end
end
