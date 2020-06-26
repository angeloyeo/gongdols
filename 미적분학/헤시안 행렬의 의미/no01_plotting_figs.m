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
addpath('..\로피탈정리의_기하학적의미\')
%% Fig 1. 1차 미분 계수의 의미

clear v
v = VideoWriter('fig1.mp4','MPEG-4');
v.FrameRate = 30;
v.Quality = 100;
open(v);

clear F

plotXY(-2.5,2.5,-2.5,2.5,true,20)
x = linspace(-2.5,2.5, 100);
y = x+0.5+1/3*sin(2*pi*1/3*x);

hold on;
plot(x,y,'k','linewidth',2)
i=1;
for xx = linspace(-3,3,100)
    
    h(1) = plot(xx, xx+0.5+1/3*sin(2*pi*1/3*xx),'o','markerfacecolor','r','markeredgecolor','none','markersize',8);
    %     t = text(0.6307, 1.2953, '$$ (x,y) = (g(t), f(t)) $$','Interpreter','latex');
    %     t.FontSize = 20;
    
    dydx = 1+1/3*2*pi*1/3*cos(2*pi*1/3*xx);
    x = linspace(xx-1,xx+1,10);
    h(2) = plot(x, dydx*(x-xx) + xx+0.5+1/3*sin(2*pi*1/3*xx),'color','b','linewidth',2);
    
    slope = (xx+0.5+1/3*sin(2*pi*1/3*xx))/xx;
%     if xx ==0
%         h(3) = line([0,0],[0,2],'color','r','linewidth',2);
%     elseif xx > 0
%         x = linspace(0,xx+0.5,10);
%         h(3) = plot(x, slope*x,'color','r','linewidth',2);
%     elseif xx<0
%         x = linspace(xx-0.5,0,10);
%         h(3)= plot(x, slope*x,'color','r','linewidth',2);
%     end
    drawnow;
    
    F(i)=getframe(gcf);
    if xx<3
        delete(h)
    end
    i=i+1;
end


for i=1:length(F)
    % convert the image to a frame
    frame = F(i) ;
    writeVideo(v, frame);
end

close(v)
%% Fig. 2 Quadratic form으로 함수 표현하기 (Bowl Shape)


clear v
v = VideoWriter('fig2.mp4','MPEG-4');
v.FrameRate = 30;
v.Quality = 100;
open(v);

clear F

n_step = 100;

A_final = [2,1; 1,2]; % Bowl 형태의 Hessian
% A_final = [2,0; 0,-2]; % Saddle 형태의 Hessian

b = [0, 0]';
c = 0;
figure('position',[2028, 495, 1153, 387]);

[X,Y] = meshgrid(-10:0.8:10);
i=1;
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
    str = [ 'Matrix \it{A} = ', '$$ \left[ {\matrix{ ',num2str(A(1,1)),' & ', num2str(A(1,2)),... 
        ' \cr ', num2str(A(2,1)) , ' & ', num2str(A(2,2)),' } } \right] $$' ];
    t = text(0.6, 0.2, str, 'unit','normalized' ,'Interpreter','latex', ...
        'BackgroundColor','w','Fontsize',12);
    drawnow
    
    
    F(i)=getframe(gcf);
    if xx<3
        delete(h)
    end
    i=i+1;
end

for i=1:length(F)
    % convert the image to a frame
    frame = F(i) ;
    writeVideo(v, frame);
end

close(v)

%% Fig. 3 Quadratic form으로 함수 표현하기 (Saddle Shape)

clear v
v = VideoWriter('fig3.mp4','MPEG-4');
v.FrameRate = 30;
v.Quality = 100;
open(v);

clear F

n_step = 100;

% A_final = [2,1; 1,2]; % Bowl 형태의 Hessian
A_final = [2,0; 0,-2]; % Saddle 형태의 Hessian

b = [0, 0]';
c = 0;
figure('position',[2028, 495, 1153, 387]);

[X,Y] = meshgrid(-10:0.8:10);
i=1;
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
    if D(1,1) >= 0
        mArrow2(0, 0, V(1,1)*D(1,1),V(2,1)*D(1,1),{'color','r','linewidth',2});
    else
        mArrow2(0, 0, V(1,1)*D(1,1),V(2,1)*D(1,1),{'color','b','linewidth',2});
    end
    
    mArrow2(0, 0, V(1,2)*D(2,2),V(2,2)*D(2,2),{'color','r','linewidth',2});
    str = [ 'Matrix \it{A} = ', '$$ \left[ {\matrix{ ',num2str(A(1,1)),' & ', num2str(A(1,2)),... 
        ' \cr ', num2str(A(2,1)) , ' & ', num2str(A(2,2)),' } } \right] $$' ];
    t = text(0.6, 0.2, str, 'unit','normalized' ,'Interpreter','latex', ...
        'BackgroundColor','w','Fontsize',12);
    drawnow
    
    
    F(i)=getframe(gcf);
    i=i+1;
end

for i=1:length(F)
    % convert the image to a frame
    frame = F(i) ;
    writeVideo(v, frame);
end

close(v)

%% Fig. 4 Quadratic form으로 함수 표현하기 (Bowl Shape, 마지막 장면만)


A_final = [2,1; 1,2]; % Bowl 형태의 Hessian
% A_final = [2,0; 0,-2]; % Saddle 형태의 Hessian

b = [0, 0]';
c = 0;
figure('position',[2028, 495, 1153, 387]);
A = A_final;

[X,Y] = meshgrid(-10:0.8:10);
fcn = @(x,y) (1/2 * A(1,1)*x.^2 + 1/2 * (A(1,2)+A(2,1))*x.*y + 1/2 * A(2,2)*y.^2 - b(1)*x - b(2)*y + c);

% 3차원 곡면 그리기
subplot(1,2,1);
surf(X, Y, fcn(X,Y))
xlim([-10, 10])
ylim([-10, 10])
zlim([-300, 300])
xlabel('x');
ylabel('y');
zlabel('z');
% contour plot


subplot(1,2,2);
contour(X,Y,fcn(X,Y),50)

% eigen vector & eigen value
[V,D] = eig(A);
mArrow2(0, 0, V(1,1)*D(1,1),V(2,1)*D(1,1),{'color','r','linewidth',2});
mArrow2(0, 0, V(1,2)*D(2,2),V(2,2)*D(2,2),{'color','r','linewidth',2});
str = [ 'Matrix \it{A} = ', '$$ \left[ {\matrix{ ',num2str(A(1,1)),' & ', num2str(A(1,2)),...
    ' \cr ', num2str(A(2,1)) , ' & ', num2str(A(2,2)),' } } \right] $$' ];
t = text(0.6, 0.2, str, 'unit','normalized' ,'Interpreter','latex', ...
    'BackgroundColor','w','Fontsize',12);
xlabel('x');
ylabel('y');

saveas(gcf,'fig4.png')
%% Fig. 5 Quadratic form으로 함수 표현하기 (Saddle Shape, 마지막 장면만)


% A_final = [2,1; 1,2]; % Bowl 형태의 Hessian
A_final = [2,0; 0,-2]; % Saddle 형태의 Hessian
b = [0, 0]';
c = 0;
figure('position',[2028, 495, 1153, 387]);

[X,Y] = meshgrid(-10:0.8:10);
A = A_final;

fcn = @(x,y) (1/2 * A(1,1)*x.^2 + 1/2 * (A(1,2)+A(2,1))*x.*y + 1/2 * A(2,2)*y.^2 - b(1)*x - b(2)*y + c);

% 3차원 곡면 그리기
subplot(1,2,1);
surf(X, Y, fcn(X,Y))
xlim([-10, 10])
ylim([-10, 10])
zlim([-300, 300])
xlabel('x');
ylabel('y');
zlabel('z');
% contour plot

subplot(1,2,2);
contour(X,Y,fcn(X,Y),50)

% eigen vector & eigen value
[V,D] = eig(A);
if D(1,1) >= 0
    mArrow2(0, 0, V(1,1)*D(1,1),V(2,1)*D(1,1),{'color','r','linewidth',2});
else
    mArrow2(0, 0, V(1,1)*D(1,1),V(2,1)*D(1,1),{'color','b','linewidth',2});
end
mArrow2(0, 0, V(1,2)*D(2,2),V(2,2)*D(2,2),{'color','r','linewidth',2});
str = [ 'Matrix \it{A} = ', '$$ \left[ {\matrix{ ',num2str(A(1,1)),' & ', num2str(A(1,2)),...
    ' \cr ', num2str(A(2,1)) , ' & ', num2str(A(2,2)),' } } \right] $$' ];
t = text(0.6, 0.2, str, 'unit','normalized' ,'Interpreter','latex', ...
    'BackgroundColor','w','Fontsize',12);
xlabel('x');
ylabel('y');

saveas(gcf,'fig5.png')

%% Quadratic form으로 함수 표현하기 (3차식이 포함된 함수, Monkey Saddle)
% 
% clear v
% v = VideoWriter('fig3.mp4','MPEG-4');
% v.FrameRate = 30;
% v.Quality = 100;
% open(v);
% 
% clear F

n_step = 100;

figure('position',[2028, 495, 1153, 387]);

[X,Y] = meshgrid(linspace(-3, 3, 20));

fcn = @(x,y) (x.^3-3*x.*y.^2);

% 3차원 곡면 그리기
subplot(1,2,1);
surf(X, Y, fcn(X,Y))
% xlim([-10, 10])
% ylim([-10, 10])
% zlim([-300, 300])
% contour plot

subplot(1,2,2);
contour(X,Y,fcn(X,Y),50)

%{
Monkey Saddle의 Hessian

[6x -6y;
-6y -6x]

%}
n_grid = 10;
[X,Y] = meshgrid(linspace(-3, 3, n_grid));

H = cell(n_grid,n_grid);
V = cell(n_grid,n_grid);
D = cell(n_grid,n_grid);

for i = 1:n_grid
    for j = 1:n_grid
        H{i,j} = [6 * X(i,j), -6 * Y(i,j);
            -6 * Y(i,j),  -6 * X(i,j)];
        [V{i,j}, D{i,j}] = eig(H{i,j});
    end
end

for i = 1:n_grid
    for j = 1:n_grid
        for k = 1:2
            mArrow2(X(i,j), Y(i,j), X(i,j) + D{i,j}(k,k)*V{i,j}(1, k)/10, Y(i,j) + D{i,j}(k,k)*V{i,j}(2, k)/10,...
                {'color','r','linewidth',1});
        end
    end
end

