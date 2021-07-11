clear; close all; clc;

fs = 50e3;

t = 0:1/fs:1-1/fs;
yy1 = 0.7*sin(2*pi*200*t);
yy2 = sin(2*pi*350*t);

sound(yy1, fs)
sound(yy2, fs)
sound(yy1+yy2, fs)

%%
figure('position',[68.2, 441, 984, 206]);
plot(t, yy1);
xlim([0, 0.05])
hold on;
xlabel('time(s)');
set(gca,'fontsize',12);
grid on;

figure('position',[68.2, 441, 984, 206]);
plot(t,yy2);
xlim([0, 0.05])
xlabel('time(s)');
set(gca,'fontsize',12);
grid on;


figure('position',[68.2, 441, 984, 206]);
plot(t, yy1+yy2);
xlim([0, 0.05])
xlabel('time(s)');
set(gca,'fontsize',12);
grid on;

%%
Y = zeros(1,500);
Y(200) = 0.7;
Y(350) = 1;
figure;
stem(Y,'linewidth',2)
grid on;
xlabel('frequency (Hz)');
ylabel('Amplitude');
set(gca,'fontsize',12)