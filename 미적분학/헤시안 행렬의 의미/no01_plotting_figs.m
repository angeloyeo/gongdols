%{
2020년 5월 27일 작성 시작

%%%%%%%%%%%%%%%%%%%%%% 헤시안 행렬의 기하학적 의미 %%%%%%%%%%%%%%%%%%%%%%%%

- Hessian Matrix의 고유값, 고유벡터의 의미
1) Hessian의 각 고유벡터는 서로 독립적인 curvature 방향을 의미함
2) Hessian의 각 고유값은 위 고유벡터의 방향으로 얼마나 curved 되었는지를 의미함.

- 주의할 점
1) Hessian Matrix는 symmetric matrix임.


- 구현하고자 하는 내용
Quadratic form에서, 즉 f(x) = x^TAx-b^Tx+c와 같은 함수 f에서,
1) 여기서 A가 Hessian이며, Hessian은 함수의 curvature를 나타냄.
 
A는 identity matrix에서 시작해서 원하는 Hessian 행렬 A로 서서히 변경되어 감에 따라 함수의 모양이 어떻게 바뀌는지 확인
이를 통해 Hessian Matrix의 선형변환이 수행하는 바가 무엇인지 기하학적으로 이해

%}
clear; close all; clc;
addpath('..\..\선형대수\gauss_jordan_visualization\');

%% Quadratic form으로 함수 표현하기
n_step = 100;

A_final = [2,1; 1,2]; % Bowl 형태의 Hessian
% A_final = [2,0; 0,-2]; % Saddle 형태의 Hessian

b = [0, 0]';
c = 0;
figure('position',[2028, 495, 1153, 387]);

[X,Y] = meshgrid(-10:0.8:10);

for i_step = 1:n_step
    A = (A_final - eye(2)) * i_step / n_step + eye(2);
    
    fcn = @(x,y) (1/2 * A(1,1)*x.^2 + 1/2 * (A(1,2)+A(2,1))*x.*y + 1/2 * A(2,2)*y.^2 - b(1)*x - b(2)*y + c);

    % 3차원 곡면 그리기
    subplot(1,2,1);
    surf(X, Y, fcn(X,Y))
    xlim([-10, 10])
    ylim([-10, 10])
    zlim([-300, 300])
    % contour plot
    
    subplot(1,2,2);
    contour(X,Y,fcn(X,Y),50)
    
    % eigen vector & eigen value
    [V,D] = eig(A);
    mArrow2(0, 0, V(1,1)*D(1,1),V(2,1)*D(1,1),{'color','r','linewidth',2});
    mArrow2(0, 0, V(1,2)*D(2,2),V(2,2)*D(2,2),{'color','r','linewidth',2});
    drawnow
end