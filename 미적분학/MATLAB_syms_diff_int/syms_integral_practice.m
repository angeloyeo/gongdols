% MATLAB을 이용한 적분 연습
% 문제 출처: http://mathpool.tistory.com/entry/%EC%A0%81%EB%B6%84-%EC%97%B0%EC%8A%B5-%EB%B6%80%EC%A0%95%EC%A0%81%EB%B6%84%EA%B3%BC-%EC%A0%95%EC%A0%81%EB%B6%84-%EC%97%B0%EC%8A%B5%EB%AC%B8%EC%A0%9C%EA%B8%B0%EB%B3%B8

%% 적분
syms x

%% 1) 다음 정적분의 값을 구하여라 int 2x when x: from 1 to 2

int(2*x,x,1,2)

%% 2) 부정적분~

ans2 = int(2*x^3-3*x+1);

collect(ans2) % collect: 멱함수의 계수 정렬
expand(ans2)