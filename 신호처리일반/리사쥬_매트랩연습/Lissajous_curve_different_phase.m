clear all; close all; clc;

t=linspace(-1,1,1000);

delta=0;
A=1;
B=1;

for inc=1:1:1000;

x=A*sin(A*2*pi*3*t+(delta+2*pi*inc/1000));
y=B*sin(B*2*pi*3*t);

plot(y,x);
xlim([-1 1]); ylim([-1 1]);

T1=num2str(inc/1000);
T=strcat('Phase Delay=','2\pi*',T1);
text(0.3,-0.9,T);
drawnow;
pause(0.01);
% 
% if inc==500
%     pause(100);
% end

end