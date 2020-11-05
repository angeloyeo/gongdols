clear; close all; clc;

%% fig 1
x = linspace(-1,3,100);
y =2.^x;
figure;

plot(x,y,'linewidth',3);
hold on;
XLIMs = get(gca,'xlim');
YLIMs = get(gca,'ylim');

line(XLIMs,[0 0],'color','k')
line([0 0],[-5 YLIMs(2)],'color','k')
grid on;
xlabel('x'); ylabel('y=2^x');
set(gca,'fontsize',15);
set(gca,'fontname','나눔고딕');
title('when a>1')
ylim([-1 8])

%% fig 2
x = linspace(-3,1,100);
y =(1/2).^x;
figure;
plot(x,y,'linewidth',3);
hold on;

line([-3 1],[0 0],'color','k')
line([0 0],[-5 8],'color','k')
grid on;
xlabel('x'); ylabel('y=(1/2)^x');
set(gca,'fontsize',15);
set(gca,'fontname','나눔고딕');
title('when 0<a<1')
ylim([-1 8])

%% fig3 수직선 상에 -2를 표시
addpath('..\..\선형대수\gauss_jordan_visualization\');
plotNumberLine(-4,4,true);
clear v
v = VideoWriter('fig4.mp4','MPEG-4');
v.FrameRate = 30;
v.Quality = 100;
open(v);

clear F
for i = 1:25
    h = mArrow2(0,0,-1.5*i/25,0,{'color','r','linewidth',2});
    
    F(i)=getframe(gcf);
    pause(0.01);
    if i<100
        delete(h)
    end
    
end

for i=1:length(F)
    % convert the image to a frame
    frame = F(i) ;
    writeVideo(v, frame);
end

close(v)

%% fig4 복소 평면
plotComplexPlane(-5,5,-5,5,true);

%% fig5 Euler's Equation
plotComplexPlane(-5,5,-5,5,true);
hold on;
line([0,2],[0,3],'color','k')
plot(2,3,'o','markerfacecolor','w','markeredgecolor','k')


%% fig6 -1 represented with Euler's Equation
figure
plotComplexPlane(-2,2,-2,2,true);
hold on;
line([0,-1],[0,0],'color','r','linewidth',2)
plot(-1,0,'o','markerfacecolor','w','markeredgecolor','r','linewidth',2)

%% fig7 -1 to the x
clear v
v = VideoWriter('fig7.mp4','MPEG-4');
v.FrameRate = 30;
v.Quality = 100;
open(v);

figure;
set(gcf,'position',[152 139 1200 550])
set(gcf,'color','w')

subplot(1,2,1);
plotNumberLine(-4,4,false);
hold on;
text(0, -0.2,'x');

subplot(1,2,2)
plotComplexPlane(-2,2,-2,2,false);
hold on;
x = linspace(-1,1,100);

for i = 1:length(x)
    
    subplot(1,2,1);
    ho = plot(x(i),0,'o','markerfacecolor','w','markeredgecolor','r','linewidth',2);
    xlim([-4 4])
    subplot(1,2,2);
    h(1) = line([0,real(exp(1i*pi*x(i)))],[0,imag(exp(1i*pi*x(i)))],'color','r','linewidth',2);
    h(2) = plot(real(exp(1i*pi*x(i))),imag(exp(1i*pi*x(i))),'o','markerfacecolor','w','markeredgecolor','r','linewidth',2);
    
    if imag(exp(1i*pi*x(i)))>=0
        t = text(-2.5, 1.5, ['(-1)^{',sprintf('%0.2f',x(i)),'} = ',sprintf('%0.2f',real(exp(1i*pi*x(i)))),' + i ',...
            sprintf('%0.2f',imag(exp(1i*pi*x(i))))]);
    else
        t = text(-2.5, 1.5, ['(-1)^{',sprintf('%0.2f',x(i)),'} = ',sprintf('%0.2f',real(exp(1i*pi*x(i)))),' - i ',...
            sprintf('%0.2f',abs(imag(exp(1i*pi*x(i)))))]);
    end
    t.FontSize = 15;
    
    F(i)=getframe(gcf);
    
    drawnow;
    if i<length(x)
        delete(h);
        delete(t);
        delete(ho);
    end
    
end

for i=1:length(F)
    % convert the image to a frame
    frame = F(i) ;
    writeVideo(v, frame);
end

close(v)

%% fig 8 -1.5 to the x

clear v
v = VideoWriter('fig8.mp4','MPEG-4');
v.FrameRate = 30;
v.Quality = 100;
open(v);

figure;
set(gcf,'position',[152 139 1200 550])
set(gcf,'color','w')

subplot(1,2,1);
plotNumberLine(-4,4,false);
hold on;
text(0, -0.2,'x');

subplot(1,2,2)
plotComplexPlane(-4,4,-4,4,false);
hold on;
x = linspace(-3,3,100);

for i = 1:length(x)
    
    subplot(1,2,1);
    ho = plot(x(i),0,'o','markerfacecolor','w','markeredgecolor','r','linewidth',2);
    xlim([-4 4])
    subplot(1,2,2);
    h(1) = line([0,real((1.5)^x(i)*exp(1i*pi*x(i)))],[0,imag((1.5)^x(i)*exp(1i*pi*x(i)))],'color','r','linewidth',2);
    h(2) = plot(real((1.5)^x(i)*exp(1i*pi*x(i))),imag((1.5)^x(i)*exp(1i*pi*x(i))),'o','markerfacecolor','w','markeredgecolor','r','linewidth',2);
    
    if imag((1.5)^x(i)*exp(1i*pi*x(i)))>=0
        t = text(-5.3307, 3.4661, ['(-1.5)^{',sprintf('%0.2f',x(i)),'} = ',sprintf('%0.2f',real((1.5)^x(i)*exp(1i*pi*x(i)))),' + i ',...
            sprintf('%0.2f',imag((1.5)^x(i)*exp(1i*pi*x(i))))]);
    else
        t = text(-5.3307, 3.4661, ['(-1.5)^{',sprintf('%0.2f',x(i)),'} = ',sprintf('%0.2f',real((1.5)^x(i)*exp(1i*pi*x(i)))),' - i ',...
            sprintf('%0.2f',abs(imag((1.5)^x(i)*exp(1i*pi*x(i)))))]);
    end
    t.FontSize = 15;
    
    F(i)=getframe(gcf);
    
    drawnow;
    if i<length(x)
        delete(h);
        delete(t);
        delete(ho);
    end
    
end

for i=1:length(F)
    % convert the image to a frame
    frame = F(i) ;
    writeVideo(v, frame);
end

close(v)


