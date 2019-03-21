clear; close all; clc;

x=[1 2 3];
y=[1 2 2];

plot(x,y,'.','markersize',30);

xlim([-1 4]);
ylim([-1 4]);

grid on;
hold on;
line([-1 4],[0 0],'color','k')
line([0 0],[-1 4],'color','k')
set(gca,'XTick',[-1 0 1 2 3 4])
set(gca,'YTick',[-1 0 1 2 3 4])

xlabel('공부 시간'); ylabel('중간고사 점수');

x_axis=-1:0.1:4;
% 
% for i=1:3
%     a=rand(1,1);
%     b=rand(1,1);
%     
%     y_axis=a*x_axis+b;
%     
%     plot(x_axis,y_axis);
% end

a_ans=1/2;
b_ans=2/3;

y_axis=a_ans*x_axis+b_ans;
plot(x_axis,y_axis);

%%

clear; close all; clc;

line([-1 4],[0 0],'color','k')
hold on;
grid on;
line([0 0],[-1 4],'color','k')
set(gca,'XTick',[-1 0 1 2 3 4])
set(gca,'YTick',[-1 0 1 2 3 4])


a_ans=1/2;
b_ans=2/3;
x_axis=-1:0.1:4;
y_axis=a_ans*x_axis+b_ans;
plot(x_axis,y_axis);

line([-1 4],[1 1],'color','k','linestyle','--')

plot(3,3,'.','markersize',20)