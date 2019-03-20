clear; close all; clc;
 
% vector field
 
[x,y]=meshgrid(-2:0.3:2,-2:.3:2);
 
u=x.^2;
v=y;
 
quiver(x,y,u,v)
 
grid on;
xlabel('x'); 
ylabel('y');
set(gca,'fontsize',15);
 