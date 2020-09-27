clear; close all; clc;

%% 데이터 만들기
rng(1);
x0 = randn(1, 100) * 1 + 1;
x1 = randn(1, 100) * 1 + 10;

%% 데이터에 라벨 붙이기

y0 = zeros(1, 100);
y1 = ones(1, 100);

%% 데이터 합쳐주기
X = [x0, x1];
y = [y0, y1];

shuffle_ind = randperm(length(X));

X = X(shuffle_ind);
y = y(shuffle_ind);

%% 데이터의 분포 확인

figure;
histogram(x0, 50);
hold on;
histogram(x1, 50);

%% 데이터의 분포를 0, 1이라는 라벨을 함께 붙여서 확인

figure;
plot(x0, y0, 'rx');
hold on;
plot(x1, y1, 'bo');

ylim([-0.5, 1.5])
grid on;

%% model 만들기

g = @(x, a, b) 1./(1+exp(-a*x-b));

figure;
plot(x0, y0, 'rx');
hold on;
plot(x1, y1, 'bo');

ylim([-0.5, 1.5])
grid on;
% xx = linspace(-3, 11, 500);
% plot(xx, g(xx, 5, -30))

%% cost

loss = @(y, p) -(y*log(p) + (1-y) * log(1-p));

%% random initialization
rng(1);
a = randn(1) * 5; 
b = randn(1) * 5;

%% total_loss 계산 및 gradient descent
n_epoch = 1000;

total_loss = zeros(1, n_epoch);
a_history = zeros(1, n_epoch);
b_history = zeros(1, n_epoch);
lr = 0.0005;

for i_epoch  = 1:n_epoch
    
    a_history(i_epoch) = a;
    b_history(i_epoch) = b;
    
    % gradient 초기화
    pLpa = 0;
    pLpb = 0;
    
    for i = 1:length(X)
        x_i = X(i);
        y_i = y(i);
        temp_p = g(x_i, a, b);
        % loss 계산
        total_loss(i_epoch) = total_loss(i_epoch) + loss(y_i, temp_p);
        
        % gradient descent
        pLpa = pLpa + (temp_p-y_i) * x_i; % partial L partial a
        pLpb = pLpb + (temp_p-y_i); % partial L partial b
    end
    
    % update
    a = a - lr * pLpa;
    b = b - lr * pLpb;
end

%% 학습 후 결과 확인


figure;
plot(x0, y0, 'rx');
hold on;
plot(x1, y1, 'bo');

ylim([-0.5, 1.5])
grid on;
xx = linspace(-3, 11, 500);
plot(xx, g(xx, a_history(end), b_history(end)))

%% 학습 과정 확인

figure;
hold on;
ylim([-0.5, 1.5])
grid on;
xx = linspace(-3, 11, 500);

for i = 1:length(a_history)
    h = plot(xx, g(xx, a_history(i), b_history(i)),'color',lines(1),'linewidth',3);
    plot(x0, y0, 'rx');
    plot(x1, y1, 'bo');
    
    t = text(9.5, 1.2, ['epoch: ',num2str(i)],'fontsize',12,'backgroundcolor','w','edgecolor','k');
    xlabel('x');
    ylabel('y');
    drawnow;
    
    if i<length(a_history)
        delete(h);
        delete(t);
    end
end
