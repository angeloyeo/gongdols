t=linspace(-1,1,1000);

delta=0;
A=1;
B=0;

for inc=1:1:1000;

x=A*sin(A*2*pi*3*t+delta);
y=(B+(inc/1000))*sin((B+(inc/1000))*2*pi*3*t);

plot(y,x);
xlim([-1 1]); ylim([-1 1]);

T1=num2str(inc/1000);
T=strcat('A/B=',T1);
text(0.7,-0.9,T);
drawnow;
pause(0.01);

if inc==500
    pause(100);
end

end