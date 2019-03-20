clear; close all; clc;

x = linspace(-3,3,20);
y = exp(x);

plot(x,y,'linewidth',2)
grid on;
hold on;
line([-3 3],[0 0],'color','k')
line([0 0],[-1 8],'color','k')
ylim([-1 8])

app_point = 0;

taylor_e = 0;
for n= 0:10
    t_e_nth_term = (x-app_point).^n/factorial(n);
    
    taylor_e = taylor_e + t_e_nth_term;
    h = plot(x,taylor_e,'r','linewidth',2);
    xlabel('x'); ylabel('y');
    
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
    pause(1);
    if n<10
        delete(h);
        delete(t);
    end
    
end
