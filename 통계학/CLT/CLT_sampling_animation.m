clear; close all; clc;

figure;
set(gcf,'position',[680 330 900 650])
set(gcf,'color','w');

set(gca,'visible','off')

xlim([-1 1])
ylim([0 400])

% 선 그어주기
line(xlim,[50 50],'color','k')
hold on;
line(xlim,[200 200],'color','k')
line(xlim,[300 300],'color','k')

%% top
axis_top = axes('position',[187/900, 469/650, 559/900 140/650]);
pop_size=1000;
pop_mn=0;
pop_sd=1;

pd = makedist('normal','mu',pop_mn,'sigma',pop_sd);
x = linspace(-10,10,100);
y = pdf(pd,x);
plot(x,y,'linewidth',3,'color',[244 188 66]/255)
hold on; area(x,y,'facecolor',[255 229 175]/255);
set(axis_top,'visible','off')
xlim([-4 4])

%% bottom
axis_bottom = axes('Position',[187/900 138/650 559/900 140/650]);

histogram(randn(100,1))
set(axis_bottom,'visible','off')
