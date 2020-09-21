clear; close all; clc;

rng(1)
x = rand(1, 50) * 100 + 1; % 1~100 사이의 랜덤한 데이터 50개
y = 3 * x + 1 + randn(size(x)) * 30;
y = abs(y);

figure; plot(x, y, 'o');
xlabel('인구 수 (만 명)'); ylabel('고속도고 사고 발생 건수 (건)'); grid on;
title('여러 도시에서 발생한 교통사고 건수와 그 주의 인구');

c1 = fit(x', y', 'poly1');
XLIMs = xlim;

xx = linspace(XLIMs(1), XLIMs(2), 100);
yy = c1.p1 * xx + c1.p2;
hold on;
plot(xx, yy, 'r','linewidth',2)


%% 
close all;
Ngrid = 50;
[a, b] = meshgrid(linspace(-30, 30, Ngrid), linspace(-30, 30, Ngrid));

f = zeros(size(a));
[x_norm, min_x_norm, max_x_norm] = fun_minmax_normalize(x);
[y_norm, min_y_norm, max_y_norm] = fun_minmax_normalize(y);
c2 = fit(x_norm', y_norm', 'poly1');

for i = 1:Ngrid
    for j = 1:Ngrid
        f(i, j) = 1/2 * 1/length(x) * sum((a(i,j) * x_norm + b(i,j) - y_norm).^2);
    end
end
figure('position',[488.0000  342.0000  926.6000  420.0000])
subplot(1,2,1);
surf(a, b, f)
hold on;
plot3(c2.p1, c2.p2, 1/2 * 1/length(x) * sum((c2.p1 * x_norm + c2.p2 - y_norm).^2),'p',...
    'markersize',20,'markerfacecolor','r','markeredgecolor','none');
axis vis3d
xlabel('s'); ylabel('i'); zlabel('cost');

subplot(1,2,2);
contour(a,b,f, 30)
hold on;

plot(c2.p1, c2.p2, 'p',...
    'markersize',20,'markerfacecolor','r','markeredgecolor','none');
xlabel('slope (normalized)'); ylabel('intercept (normalized)'); 

xx = fun_restore_minmax_normalization(linspace(-30, 30, 100), min_x_norm, max_x_norm);
yy = fun_restore_minmax_normalization(linspace(-30, 30, 100), min_y_norm, max_y_norm);


%% Gradient 설명하기 위한 추가 그림
figure;
contour(a,b,f, 30)
xlabel('slope (normalized)'); ylabel('intercept (normalized)'); 
axis tight

%% Gradient descent 해보기

my_function = @(x, slp, int) slp * x + int;
N = length(x);

lr = 0.05;
temp = rand(2, 1) * 30;
slp = temp(1);
intcpt = temp(2);

slp_saved = slp;
intcpt_saved = intcpt;

n_epoch = 10000;
for i_epoch = 1:n_epoch
    MSE = 0;
    rEra = 0;
    rErb = 0;
    for i_data = 1:N
        yhat = my_function(x_norm(i_data), slp, intcpt);
        rEra = rEra + 1/N * (yhat-y_norm(i_data)) * x_norm(i_data);
        rErb = rErb + 1/N * (yhat-y_norm(i_data));
        MSE = MSE + 1/(2*N) * (yhat - y_norm(i_data))^2;
    end
    
     slp = slp - lr * rEra;
     intcpt = intcpt - lr * rErb;

     slp_saved = [slp_saved, slp];
     intcpt_saved = [intcpt_saved, intcpt];
end

%% 영상 촬영 

figure('position',[488.0000  342.0000  926.6000  420.0000],'color','w')
for i_epoch = 1:10:2000

    slp_restored = (slp_saved(i_epoch) * (max_y_norm - min_y_norm) + min_y_norm) / max_x_norm;
    intcpt_restored = (intcpt_saved(i_epoch) * (max_y_norm - min_y_norm) + min_y_norm);
    
    subplot(1, 2, 1);
    plot(x, y, 'o');
    hold on;
    plot(xx, slp_restored * xx + intcpt_restored,'r-','linewidth',2);
    xlim([0, 100])
    ylim([0, 350])

    xlabel('인구 수 (만 명)'); ylabel('고속도고 사고 발생 건수 (건)'); grid on;
    title('여러 도시에서 발생한 교통사고 건수와 그 주의 인구');
    
    subplot(1, 2, 2);
    contour(a,b,f, 30)
    hold on;
    plot(slp_saved(1:i_epoch), intcpt_saved(1:i_epoch), 'r');
    plot(slp_saved(i_epoch), intcpt_saved(i_epoch), 'p',...
        'markersize',20,'markerfacecolor','r','markeredgecolor','none');
    xlabel('slope (normalized)'); ylabel('intercept (normalized)'); grid on;
    drawnow

    disp(i_epoch)
    
    if i_epoch < n_epoch
        subplot(1,2,1);
        cla
        subplot(1,2,2);
        cla
    end
end
