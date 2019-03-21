clear; close all; clc;

rng default

Fs = 1000;
t = 0:1/Fs:1-1/Fs;

x = cos(2*pi*100*t)+sin(2*pi*200*t)+0.5*randn(size(t));
y = 0.5*cos(2*pi*100*t-pi/4)+0.35*sin(2*pi*200*t-pi/2)+ ...
    0.5*randn(size(t));

figure;
subplot(211);
plot(t,x);
title('x(t) = cos(2\pi100t)+sin(2\pi200t)+0.5\eta(t)');
xlabel('time (s)');
subplot(212)
plot(t,y);
title('y(t) = 0.5cos(2\pi100t-\pi/4)+0.35sin(2\pi200t-\pi/2)+0.5\eta(t)');
xlabel('time (s)');

figure;
subplot(211);
plot(t,x);
title('x(t) = cos(2\pi100t)+sin(2\pi200t)+0.5\eta(t)');
xlabel('time (s)');
xlim([0 0.1])
subplot(212)
plot(t,y);
title('y(t) = 0.5cos(2\pi100t-\pi/4)+0.35sin(2\pi200t-\pi/2)+0.5\eta(t)');
xlabel('time (s)');
xlim([0 0.1])

%% MSC for magnitude
[Pxy,F] = mscohere(x,y,hamming(100),80,100,Fs);
figure;
plot(F,Pxy)
title('Magnitude-Squared Coherence')
xlabel('Frequency (Hz)')
grid

%% CPSD for phase
[Cxy,F] = cpsd(x,y,hamming(100),80,100,Fs);
figure;
plot(F,-angle(Cxy)/pi)
title('Cross Spectrum Phase')
xlabel('Frequency (Hz)')
ylabel('Lag (\times\pi rad)')

ax = gca;
ax.XTick = [100 200];
ax.YTick = [-1 -1/2 -1/4 0 1/4 1/2 1];
grid