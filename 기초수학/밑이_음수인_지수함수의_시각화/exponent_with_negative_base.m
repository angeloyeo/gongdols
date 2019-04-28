clear; close all; clc;
n = 5000;
base = -2;
x = linspace(-3,3,n);

y = base.^x;

real(y)
imag(y)
figure;
h(1) = plot(x,real(y));
hold on;
h(2) = plot(x,imag(y));
grid on;
legend(h, ['real part of y =(',num2str(base),')^x'],['imaginary part of y =(',num2str(base),')^x'],'location','best')
xlabel('x');

% 한방에 표현할 수는 없을까?
my_color = jet(length(y));

figure;
set(gcf,'position',[350 400 850 350])
subplot(1,2,1);
scatter(x,zeros(1,n),1,my_color);
axis tight
grid on;

subplot(1,2,2);
scatter(real(y), imag(y),1,my_color)
axis tight
grid on;
xlabel('real'); ylabel('imaginary')

%% base가 -3에서 -0.5정도로 변하는 영상 만들어볼까?

base2 = linspace(-3,-0.5,100);

figure;
set(gcf,'position',[350 400 850 350])

for i_base2 = 1:length(base2)
    y2 = base2(i_base2).^x;

    subplot(1,2,1);
    scatter(x,zeros(1,n),1,my_color);
    axis tight
    grid on;
    
    subplot(1,2,2);
    scatter(real(y2), imag(y2),1,my_color)
%     axis tight
    grid on;
    xlabel('real'); ylabel('imaginary')
    xlim([-10 10])
    ylim([-10 10])
    title(['y = ',num2str(base2(i_base2)),'^x'])
    drawnow;
end



