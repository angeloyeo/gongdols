clear; close all; clc;

fx = 1;
x = 0;

for i = 1:5
    x = [x, x(i)+0.5];
    fx = [fx, fx(i)*1.5];
end

stem(x, fx,'linewidth',2)
grid on;
set(gca,'ytick',round(fx,2))
xlabel('$$x$$','interpreter','latex');
ylabel('$$f(x)$$','interpreter','latex');
set(gca,'fontsize',11)