close all;
t=[-3 -2 -1 0 1 2 3];
x=ones(length(t),1);
stem(t,x);axis([-7 7 -0.5 1.5]);
hold on;
t_dots=[-5 -4.5 -4 4 4.5 5];
x_dots=0.5*ones(length(t_dots),1);
plot(t_dots,x_dots,'k.','Markersize',10);
title('impulse train');xlabel('n');ylabel('p[n]');