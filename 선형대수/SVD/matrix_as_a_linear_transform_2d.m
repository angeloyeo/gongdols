clear; close all; clc;

% A = [2 2;2 7];
A =[1,3;4,2]/4;
% A=[2,1;1,2]; % shear
% angle = pi/2; A = [cos(angle) -sin(angle); sin(angle) cos(angle)]; %rotation
% A = [0, 1; 1, 0]; % permutation
% A = [1,0;0,0]; % projection
% vector = [1,2]'; A = vector*vector'; % projection on a vector

%% eigshow
% figure;
% eigshow(A) % Numerical Computing with MATLAB toolbox 다운로드 필요함.

%% animation with DOTS
n_steps = 100;
step_mtx = eye(2);
[x,y] = ndgrid(-1:0.15:1);
xy_min = min(min(A*[x(:), y(:)]'))*1.5;
xy_max = max(max(A*[x(:), y(:)]'))*1.5;


dot_colors = jet(length(x(:)));

figure(2);
scatter(x(:), y(:),30,dot_colors,'filled')
grid on;
xlim([xy_min, xy_max]); ylim([xy_min, xy_max]);
pause;
for i_steps = 1:n_steps
    step_mtx = (A-eye(2))/n_steps*i_steps;
    
    new_xy = (eye(2)+step_mtx)*[x(:), y(:)]';
    scatter(new_xy(1,:), new_xy(2,:),30,dot_colors,'filled')
    grid on;
    xlim([xy_min, xy_max]); ylim([xy_min, xy_max]);
    pause(0.01);
end


%% animation with circle
t=linspace(0,2*pi,100);
x=cos(t);
y=sin(t);

% plot(x,y); % 변환 전의 plot
[temp]=A*[x;y];
% plot(temp(1,:),temp(2,:)) %변환 후의 plot
% 아래의 animation에서 figure의 최대, 최소 범위를 미리 설정하는 것이 좋음
% XLIM=[min(temp(1,:)), max(temp(1,:))]*1.1;
XLIM=[xy_min, xy_max];
YLIM=[xy_min, xy_max];


% animation
figure;
plot(x,y);
grid on;
xlim(XLIM);
ylim(YLIM);
pause;
for i_steps = 1:n_steps
    step_mtx = (A-eye(2))/n_steps*i_steps;
    new_xy = (eye(2)+step_mtx)*[x;y];
    plot(new_xy(1,:),new_xy(2,:));
    grid on;
    xlim(XLIM);
    ylim(YLIM);
    pause(0.01);
end


%% eigshow
figure;
eigshow(A)

%% SVD
figure;
plot(temp(1,:), temp(2,:));
grid on;
xlim(XLIM);
ylim(YLIM);
[U,S,V]=svd(A);

hold on; 
mArrow2(0, 0, U(1,1)*S(1,1), U(2,1)*S(1,1),{'color','b'})
mArrow2(0, 0, U(1,2)*S(2,2), U(2,2)*S(2,2),{'color','b'})

mArrow2(0,0,V(1,1), V(2,1),{'color',[0 153 0]/255})
mArrow2(0,0,V(1,2), V(2,2),{'color',[0 153 0]/255})
axis equal