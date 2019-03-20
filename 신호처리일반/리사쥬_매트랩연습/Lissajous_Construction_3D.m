clear all; close all; clc;

t=linspace(-pi,pi,10000);
delay=-pi/2;
delay2=0;
amp1=0.8;
amp2=1;
amp3=1;
slowness=150;


for ii=1:1:length(t)
    
    
    A=amp1*sin(amp1*2*pi*1*(ii/slowness));
    B=amp2*sin(amp2*2*pi*1*(ii/slowness)+delay);
    C=amp3*sin(amp3*2*pi*1*(ii/slowness)+delay2);
    sin_graph=amp1*sin(amp1*2*pi*1*(t+ii/slowness));
    cos_graph=amp2*sin(amp2*2*pi*1*(t+ii/slowness)+delay);
    third_graph=amp3*sin(amp3*2*pi*1*(t+ii/slowness)+delay2);

    subplot(411);
    plot(t,sin_graph);hold on;
    plot(0,A,'r*','Markersize',10);hold off;title('Signal A : X-Axis');
    xlim([-pi pi]);ylim([-1 1]);
    set(gcf,'Position',[250,100, 800, 800]);
    grid on;
    subplot(412);
    T=num2str(delay);
    Title_for_B=strcat('Signal B with Delay = ',T,' : Y-Axis');
    plot(t,cos_graph);hold on;title(Title_for_B);
    xlim([-pi pi]);ylim([-1 1]);
    plot(0,B,'r*','MarkerSize',10);hold off;
    grid on;
    subplot(413);
    T3=num2str(delay2);
    Title_for_C=strcat('Signal C with Delay = ',T3,' : Z-Axis');
    plot(t,third_graph);hold on;title(Title_for_C);
    xlim([-pi pi]);ylim([-1 1]);
    plot(0,C,'r*','MarkerSize',10);hold off;
    grid on;
    subplot(338);
%     T2=num2str(amp1/amp2);
%     Title_for_C=strcat('Ratio A/B = ',T2);
    plot3(sin_graph,cos_graph,third_graph);%title(Title_for_C);
    hold on;
    plot3(A,B,C,'r*','MarkerSize',10);hold off;%xlim([-1 1]); ylim([-1 1]);
    grid on;
%     drawnow;
    pause(0.00000001)
    
end
