clear all; close all; clc;

t=linspace(-1/16,1/4+1/16,50);

compc(1)=1;
for n=1:1:3
    for k=1:1:n 

        compc(k+1)=(1+i/n)^k;
        x=cos(2*pi*1*t);
        y=sin(2*pi*1*t);

        plot(x,y,'--')
        axis([-0.4 1.2 -0.4 1.2]);
        axis square;
        hold on;
        line([-0.4 1.2],[0 0],'color','k');
        line([0 0],[-0.4 1.2],'color','k')
        hold on;
        plot(compc,'r');
        plot(compc,'g.','MarkerSize',10);
        T1=num2str(1+n);
        T=strcat('Á¡ÀÇ °¹¼ö=',T1);
        text(1.2,-0.3,T);
        hold off;

    end
    pause(0.5);
% drawnow;
end
