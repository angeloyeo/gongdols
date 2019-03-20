%% FFT
clear; close all; clc;


N=1024;
t=0:1/500:1024/500-1/500;
sig=cos(2*pi*100*t)+cos(2*pi*30*t);
L=2^nextpow2(N);

F=fft(sig,L);

fs=500;
f=linspace(-fs/2,fs/2,L);
plot(f,abs(fftshift(F)/L))

axis tight
xlabel('frequency (Hz)');
ylabel('abs(F)')





%%
clear; close all; clc;

f=0.3;

t=0:0.05:10;

for i_t=1:length(t)
    
    f1=exp(1i*2*pi*f*t(i_t));
    f2=exp(-1i*2*pi*f*t(i_t));
    f_real=f1+f2;
    
    quiver(0,0, real(f1),imag(f1),'linewidth',2,'MaxHeadsize',0.5)
    hold on;
    grid on;
    xlim([-2.3 2.3]);
    ylim([-2.3 2.3]);
    quiver(0,0, real(f2),imag(f2),'linewidth',2,'MaxHeadsize',0.5)
    quiver(0,0, real(f_real), imag(f_real),'linewidth',2,'MaxHeadsize',0.5);

    
    pause(0.1)
    clf
end

    
