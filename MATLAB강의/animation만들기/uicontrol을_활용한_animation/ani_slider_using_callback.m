% clear; close all; clc;

function ani_slider
fs = 200;
t = 0:1/fs:5-1/fs;
f = 1;
x = sin(2*pi*1*t);

figure;
set(gcf,'position',[500 500 640 480]);
figsize = get(gcf,'position');
h = plot(t,x);

SliderH = uicontrol('style','slider','position',[70 6 512 20],'min',1,'max',5,'value',1,'callback',@cbfcn);

    function cbfcn(src, event)
       f = SliderH.Value ;
       x = sin(2*pi*f*t);
       h = plot(t,x);
    end
end
