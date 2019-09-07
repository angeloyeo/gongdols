clear; close all; clc;

XLIMs = [-2*pi, 2*pi];
YLIMs = [-1 4];
x = linspace(XLIMs(1), XLIMs(2) ,100);
y = exp(x);

figure('color','w')
plot(x,y,'linewidth',2)
grid on;
hold on;
line([0 0],[YLIMs(1) YLIMs(2)],'color','k')
line([XLIMs(1) XLIMs(2)],[0 0],'color','k')
xlim(XLIMs)
ylim(YLIMs)

ExpansionPoint = 0 ;

for n= 1:10
    
    syms x
    f = exp(x);
    T = taylor(f, 'ExpansionPoint', ExpansionPoint, 'Order', n);
%     F = matlabFunction(T);
%     h = fplot(F,XLIMs,'linewidth',2,'color','r');
    h = ezplot(T,XLIMs);
    set(h,'linewidth',2)
    set(h, 'color','r');

    title('e^x and its Taylor series');
    tp1 = 0.8;
    tp2 = 0.5;
    if n==1
        t = text(tp1,tp2,['added upto 1st term']);
    elseif n==2
        t = text(tp1,tp2,['added upto 2nd term']);
    elseif n==3
        t = text(tp1,tp2,['added upto 3rd term']);
    else
        t = text(tp1,tp2,['added upto ',num2str(n),'th term']);
    end
    t.FontSize=12;
    xlim(XLIMs)
ylim(YLIMs)
    pause;
    if n<10
        delete(h);
        delete(t);
    end
end
