clear all; close all; clc;

for n=0:0.1:100;
exponential=(1+1./n).^n;
plot(n,exponential);
hold on;
pause(0.001)
end
% plot(0:0.1:100,exp(1),'r','linewidth',5);
grid on;

figure(1);
t=0:0.1:100;
plot(t,(1+1./t).^t);
grid on;hold on;
line([0 100], [exp(1) exp(1)],'color','r' )
