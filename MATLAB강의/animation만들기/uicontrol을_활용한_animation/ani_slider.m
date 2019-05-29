% clear; close all; clc;

fs = 200;
t = 0:1/fs:5-1/fs;
x = sin(2*pi*1*t);

figure;
set(gcf,'position',[500 500 640 480]);
figsize = get(gcf,'position');
h = plot(t,x);

SliderH = uicontrol('style','slider','position',[70 6 512 20],'min',1,'max',5,'value',1);

while(1)
    plot(t, sin(2*pi*SliderH.Value*t));
    pause(0.01);
    cla
end


