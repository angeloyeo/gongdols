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
addpath('C:\Users\icbab\Google 드라이브\여동훈_개인공부정리파일\프로그래밍_코드모음\wikidocs\선형대수\gauss_jordan_visualization\');
figure;
set(gcf,'position',[500,100,1000,650])
set(gcf,'color','w');
set(gca,'visible','off')
mArrow2(-5,0,5,0,{'color','k'});
xlim([-5 5])
ylim([-1 1])

for i = -4:4
    line([i i],[-0.025 0.025],'color','k')
    t= text(i-0.1, -0.1,num2str(i));
    t.FontSize=15;
end

clear v
v = VideoWriter('fig4.mp4','MPEG-4');
v.FrameRate = 30;
v.Quality = 100;
open(v);

clear F
for i = 1:25
    h = mArrow2(0,0,-2*i/25,0,{'color','r','linewidth',2});
    
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
plotComplexPlane;

%% fig5 Euler's Equation
plotComplexPlane(-5,5,-5,5);
hold on;
line([0,2],[0,3],'color','k')
plot(2,3,'o','markerfacecolor','w','markeredgecolor','k')


%% fig6 -1 represented with Euler's Equation
plotComplexPlane(-2,2,-2,2);
hold on;
line([0,-1],[0,0],'color','r','linewidth',2)
plot(-1,0,'o','markerfacecolor','w','markeredgecolor','r','linewidth',2)

%% fig7 -1 to the x


clear v
v = VideoWriter('fig7.mp4','MPEG-4');
v.FrameRate = 30;
v.Quality = 100;
open(v);

plotComplexPlane(-2,2,-2,2);
hold on;
x = linspace(-pi,pi,100);

for i = 1:length(x)
    h(1) = line([0,real(exp(1i*x(i)))],[0,imag(exp(1i*x(i)))],'color','r','linewidth',2);
    h(2) = plot(real(exp(1i*x(i))),imag(exp(1i*x(i))),'o','markerfacecolor','w','markeredgecolor','r','linewidth',2);
    
    if imag(exp(1i*x(i)))>=0
        t = text(-2, 1.5, ['(-1)^{',sprintf('%0.2f',x(i)),'} = ',sprintf('%0.2f',real(exp(1i*x(i)))),' + i ',...
            sprintf('%0.2f',imag(exp(1i*x(i))))]);
    else
        t = text(-2, 1.5, ['(-1)^{',sprintf('%0.2f',x(i)),'} = ',sprintf('%0.2f',real(exp(1i*x(i)))),' - i ',...
            sprintf('%0.2f',abs(imag(exp(1i*x(i)))))]);
    end
    t.FontSize = 15;
    
    F(i)=getframe(gcf);
    
    
    drawnow;
    if i<length(x)
        delete(h);
        delete(t);
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

plotComplexPlane(-5,5,-5,5);
hold on;
x = linspace(-3,3,100);

for i = 1:length(x)
    val = 1.5^x(i)*exp(1i*pi*x(i));
    
    h(1) = line([0,real(val)],[0,imag(val)],'color','r','linewidth',2);
    h(2) = plot(real(val),imag(val),'o','markerfacecolor','w','markeredgecolor','r','linewidth',2);
    
    if imag(val)>=0
        t = text(-5, 3, ['(-1.5)^{',sprintf('%0.2f',x(i)),'} = ',sprintf('%0.2f',real(val)),' + i ',...
            sprintf('%0.2f',imag(val))]);
    else
        t = text(-5, 3, ['(-1.5)^{',sprintf('%0.2f',x(i)),'} = ',sprintf('%0.2f',real(val)),' - i ',...
            sprintf('%0.2f',abs(imag(val)))]);
    end
    t.FontSize = 15;
%     
    F(i)=getframe(gcf);
    
    
    drawnow;
    if i<length(x)
        delete(h);
        delete(t);
    end
    
end

for i=1:length(F)
    % convert the image to a frame
    frame = F(i) ;
    writeVideo(v, frame);
end

close(v)


