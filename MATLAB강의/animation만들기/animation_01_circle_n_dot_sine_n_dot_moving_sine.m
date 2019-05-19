clear; close all; clc;

%% 원을 따라 움직이는 점 만들기

figure;

theta= linspace(0,2*pi,100);

x = cos(theta); y = sin(theta);

for i = 10%1:length(theta)
    plot(x,y,'color','b')
    axis square
    
    hold on;
    plot(cos(theta(i)), sin(theta(i)),'ro', 'markerfacecolor','r','markersize',15)
    drawnow;
    hold off;
end


%% 사인 곡선을 따라 움직이는 점 만들기

figure;

x = linspace(0,3,100);
y = sin(2*pi*1*x);

for i = 1:length(x)
    plot(x,y)
    
    hold on;
    plot(x(i), y(i),'ro','markerfacecolor','r','markersize',5);
    drawnow;
    hold off;
end

    
    
%% 움직이는 사인 곡선 만들기
figure;
x = linspace(0,3,100);
y = sin(2*pi*1*x);

delay = linspace(0,2*pi,100);

for i = 1:length(delay)
    plot(x,sin(2*pi*1*x-delay(i)));
    drawnow;
    hold off;
end
