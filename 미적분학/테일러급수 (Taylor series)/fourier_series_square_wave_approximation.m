clear; close all; clc;

% t = 0:0.1:10;
t = linspace(0,10,1000);

figure('color','w');

line([0,0],[0,1],'linestyle','--','color','r')
hold on;
line([0,pi],[1,1],'linestyle','--','color','r')
line([pi,pi],[1,-1],'linestyle','--','color','r')
line([pi,2*pi],[-1,-1],'linestyle','--','color','r')
line([2*pi,2*pi],[-1,1],'linestyle','--','color','r')
line([2*pi,3*pi],[1,1],'linestyle','--','color','r')
line([3*pi,3*pi],[1,-1],'linestyle','--','color','r')
line([3*pi,10],[-1,-1],'linestyle','--','color','r')
grid on;
title('Approximation to a square wave')
xlabel('t');
ylabel('f(t)')
xlim([-0.5, 10.5])
ylim([-1.5, 1.5])

y = zeros(size(t));

k_tot = 100;
for k = 1:k_tot
    n = 2*(k-1)+1;
    y = y + sin(n*t)/n;
    h = plot(t,4/pi*y,'b');
    
    if k < 5
        pause(0.8)
    else
        pause(0.1);
    end
    
    if k<k_tot
        delete(h);
    end
    
end
