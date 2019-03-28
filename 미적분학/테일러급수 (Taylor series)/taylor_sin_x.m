clear; close all; clc;

XLIMs = [-3*pi 3*pi];
YLIMs = [-1.5 1.5];
x = linspace(XLIMs(1),XLIMs(2),100);
y = sin(x);

plot(x,y,'linewidth',2)
grid on;
hold on;
line(XLIMs,[0 0],'color','k')
line([0 0],YLIMs,'color','k')
xlim(XLIMs)
ylim(YLIMs)

app_point = 0;

taylor_sin = 0;
for n= 0:10
    t_sin_nth_term = (-1).^n/factorial(2*n+1)*x.^(2*n+1);
    
    taylor_sin = taylor_sin + t_sin_nth_term;
    h = plot(x,taylor_sin,'r','linewidth',2);
    xlabel('x'); ylabel('y');
    
    title('sin(x) and its Taylor series');
    tp1 = 2.5;
    tp2 = -1.25;
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
    pause(1);
    if n<10
        delete(h);
        delete(t);
    end
    
end
