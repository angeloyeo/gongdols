clear; close all; clc;

%%

x1 = randn(1, 100) * 4 + 10;
x2 = randn(1, 100) * 4 + 25;

x1(x1<0) = abs(x1(x1<0));
x2(x2<0) = abs(x2(x2<0));
rng(1)
figure('position',[1000, 650, 700, 350]);
histogram(x1);
hold on;
histogram(x2);
xlabel('귀의 길이(cm)');
ylabel('count');
title('고양이와 강아지의 귀의 길이를 통한 구별');
grid on;

figure;

plot(x1, 0,'o','markerfacecolor','b','markeredgecolor','none');
hold on;
plot(x2,0,'o','markerfacecolor','r','markeredgecolor','none');

xlabel('귀의 길이(cm)');
title('귀의 길이 데이터를 1차원 벡터 공간 상에 매핑');