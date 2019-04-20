clear; close all; clc;


x0 = -2;
x1 = 1;
y0 = -1;
y1 = 1;

for i = 1:100
    draw_mandelbrot(x0,x1,y0,y1);
    
    [x,y] = ginput(1);
    
    XLIMs = get(gca,'xlim');
    YLIMs = get(gca,'ylim');
    
    x0 = x-diff(XLIMs)/50;
    x1 = x+diff(XLIMs)/50;
    
    y0 = y-diff(YLIMs)/50;
    y1 = y+diff(YLIMs)/50;
end
