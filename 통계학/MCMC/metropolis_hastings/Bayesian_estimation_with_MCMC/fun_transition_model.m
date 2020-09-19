function res = fun_transition_model(x)
% transition model 혹은 proposal distribution 선정
% 여기서는 표준편차가 0.5인 정규분포로 선정하였음.
% 여기서 0.5라는 값은 임의로 설정하면 되는 hyperparameter이며,
% 이 hyperparameter의 선정에 따라 수렴 속도가 결정 됨.

res = [randn(1, 1) * 0.5 + x(1), x(2)]; % x(1)은 새로 뽑을 새로운 평균값, x(2)는 표본 집단을 통해서 확인한 표준 편차
