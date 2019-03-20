clear all; close all; clc;

t=linspace(0,10,1000);
x=sin(t)+3*cos(t/3)+4*sin(t/4);

plot(t,x,'b');
grid on;
xlabel('time(s)'); ylabel('x(t)');
hold on;

Ts=0.1;
num_of_space=10/Ts;

t_DT=linspace(0,9,num_of_space);
x_DT=sin(t_DT)+3*cos(t_DT/3)+4*sin(t_DT/4);
% alpha=1;
alpha=t_DT(2)-t_DT(1);
    for ii=1:1:length(t_DT)
      if x_DT(ii)>=0
          rectangle('Position',[t_DT(ii),0,alpha,x_DT(ii)*(1/alpha)],'EdgeColor','r');  
      else
          rectangle('Position',[t_DT(ii),1*x_DT(ii)*(1/alpha),alpha,abs(x_DT(ii)*(1/alpha))],'EdgeColor','r');  
      end
          
    end
      

% axis([-1 11 -0.5 2.5])

% stem(t_DT,x_DT)