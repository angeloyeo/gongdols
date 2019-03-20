clear all; close all; clc;
N=100;
r=2*pi;

for ii=1:1:ceil(r*N)
Ho=(1+i/N)^ii;
plot(Ho);
axis square;
hold on;
drawnow;
end
axis square;

figure(1);
t=1:1:ceil(r*N);
Ho_New=(1+i/N).^t;
plot(Ho_New);
% line([0 100], [exp(1) exp(1)],'color','r' )

axis tight;
grid on;
% line([-1 1],[0 0],'color','r');
% line([0 0],[-1 1],'color','r')
% plot(cos(1)+i*sin(1),'g.');