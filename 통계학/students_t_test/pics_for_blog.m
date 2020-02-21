clear; close all; clc;

%% Fig. 1
xx1_1 = linspace(-2, 6, 500);

xx1_2 = linspace(1, 9, 500);

yy1_1 = pdf('Normal',xx1_1, 2, 1.25);
yy1_2 = pdf('Normal',xx1_2, 5, 1.25);

figure('position',[374, 433, 560, 219]);
plot(xx1_1, yy1_1,'linewidth',2)
hold on;
plot(xx1_2, yy1_2,'linewidth',2);
xlabel('x');
ylabel('f(x)');
ylim([0, 0.4])
grid on
set(gca,'fontsize',12)

% line([2 2] - 1.25, ylim,'color','k','linestyle','--')
% line([2 2], ylim,'color','k','linestyle','--')
% line([2 2] + 1.25, ylim,'color','k','linestyle','--')
% 
% line([5 5], ylim,'color','k','linestyle','--')
%% Fig. 2

xx2_1 = linspace(-4, 4, 500);
xx2_2 = xx1_2;

yy2_1 = pdf('Normal',xx2_1, 0, 1.25);
yy2_2 = yy1_2;

figure('position',[374, 433, 560, 219]);
plot(xx2_1, yy2_1,'linewidth',2);
hold on;
plot(xx2_2, yy2_2,'linewidth',2);
xlabel('x');
ylabel('f(x)');
ylim([0, 0.4])
grid on
set(gca,'fontsize',12)

%% Fig. 3

xx3_1 = xx1_1;
xx3_2 = xx1_2;

yy3_1 = pdf('Normal',xx3_1, 2, 0.25);
yy3_2 = pdf('Normal',xx3_2, 5, 0.25);

figure('position',[374, 433, 560, 219]);
plot(xx3_1, yy3_1,'linewidth',2);
hold on;
plot(xx3_2, yy3_2,'linewidth',2);
xlabel('x');
ylabel('f(x)');
ylim([0, 1.7])
grid on
set(gca,'fontsize',12)

%% pic 5
mksize = 15;
XLIMs = [-5, 7];
YLIMs = [0.5, 6.5];
% 왼쪽 그림
figure('position',[488, 437, 317, 324]);
subplot(2,1,1);
xx = [-2, -1, -1, 0, 2];
yy = [1, 1, 2, 1, 1];
plot(xx, yy, 'o', 'markersize',mksize,'markerfacecolor',lines(1),'markeredgecolor','none');
xlim(XLIMs)
ylim(YLIMs)
grid on;
xlabel('x');
ylabel('count')

subplot(2,1,2);
xx = [0, 1, 2, 3, 4];
yy = [1, 1, 1, 1, 1];
plot(xx, yy, 'o', 'markersize',mksize,'markerfacecolor',[0.85, 0.325, 0.098],'markeredgecolor','none');
xlim(XLIMs)
ylim(YLIMs)
grid on;

xlabel('x');
ylabel('count')

% 오른쪽 그림
figure('position',[809 437 317 324]);
subplot(2,1,1);
xx = [-3, -3, -2, -2, -2, -1, -1, -1, -1, -1, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2]
yy = [1, 2, 1, 2, 3, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2, 3, 1, 2];
plot(xx, yy, 'o', 'markersize',mksize,'markerfacecolor',lines(1),'markeredgecolor','none');
xlim(XLIMs)
ylim(YLIMs)
grid on;

xlabel('x');
ylabel('count')
subplot(2,1,2);
xx = [-1, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 6];
yy = [1, 1, 2, 1, 2, 3, 4, 1, 2, 3, 4, 5, 1, 2, 3, 4, 1, 2, 3, 1];
plot(xx, yy, 'o', 'markersize',mksize,'markerfacecolor',[0.85, 0.325, 0.098],'markeredgecolor','none');
xlim(XLIMs)
ylim(YLIMs)
grid on;

xlabel('x');
ylabel('count')
%% t-분포는 dof가 커질 수록 normal distribution에 가까워진다.
figure;
dofs = 5:5:50;
xx = linspace(-10, 10, 500);

my_colors = jet(length(dofs));

for i_dof = 1:length(dofs)
    
    yy = pdf('T',xx, dofs(i_dof));
    
    plot(xx, yy,'color',my_colors(i_dof,:))
    hold on;
end

yy_normal = pdf('Normal', xx, 0, 1);
plot(xx, yy_normal,'color','k','linewidth',3)

