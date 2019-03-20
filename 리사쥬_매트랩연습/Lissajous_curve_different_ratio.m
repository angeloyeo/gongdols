clear all; close all; clc;
t=linspace(-1,1,1000);

delta=0;
A=1;
B=0;
pause_time=3;
see_in_detail=0;
for inc=1:1:3000;

x=A*sin(A*2*pi*3*t+delta);
y=(B+(inc/1000))*sin((B+(inc/1000))*2*pi*3*t);

plot(y,x);
xlim([-1 1]); ylim([-1 1]);

T1=num2str(inc/1000);
T=strcat('A/B=',T1);
text(0.7,-0.9,T);
% drawnow;
pause(0.00001);

    if see_in_detail==1
        switch see_in_detail==1
            case {inc==100, inc==166, inc==200, inc==250, inc==300, inc==333,...
                inc==400, inc==500, inc==600, inc==666, inc==750 }
            pause(pause_time);


        end
    end    
end