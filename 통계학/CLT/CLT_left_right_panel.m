clear; close all; clc;

n_steps = 10;
%% CANVAS
figure;
set(gcf,'position',[237 85 1200 600])
set(gca,'visible','off')
set(gcf,'color','w')
set(gca,'OuterPosition',[0,0,1,1],'Position',[0,0,1,1])
axis_canvas = gca;

xlim([0 10])
ylim([0 400])

line([5 5],[0,400],'color','k','linestyle','--')

%% LEFT
axis_left = axes('OuterPosition',[0,0,1/2,1],'Position',[0,0,1/2,1]);
xlim([0,20])
x = linspace(0,20,500);
% y = normpdf(x,0,1);


A = 5; % shape parameter of gamma distribution
B = 0.5; % scale parameter of gamma distribution

pd = makedist('gamma','a',A,'b',B);
y = pdf(pd,x);
plot(x, y);
area(x,y,'facecolor',[255 229 175]/255);

set(axis_left,'visible','on')


%% TOP RIGHT
axis_right = axes('OuterPosition',[1/2,0,1/2,1],'Position',[1/2,0,1/2,1]);
set(axis_right,'visible','on')

X = gamrnd(A,B,[1, 100]);
line([0,20],[0,400],'color','w')
hold on;
% set(gcf,'currentaxes',axis_right);
set(axis_right,'xlim',[0,20])
set(axis_right,'ylim',[0,400])
circles = plot(X,350,'o','markerfacecolor',[244 152 66]/255,'markeredgecolor','none');

% from top to middle
for i_steps = 1:n_steps
    delete(circles)
    circles = plot(X,350+(200-350)*i_steps/n_steps,'o','markerfacecolor',[244 152 66]/255,'markeredgecolor','none');
    drawnow;
end

% colliding into a mean point
for i_steps = 1:n_steps
    delete(circles)
    circles = plot(X+(mean(X)-X)*i_steps/n_steps, 200,'o','markerfacecolor',[244 152 66]/255,'markeredgecolor','none');
    drawnow;
end

% from middle to bottom
for i_steps = 1:n_steps
    delete(circles)
    circles = plot(mean(X), 200+(0-200)*i_steps/n_steps,'o','markerfacecolor',[244 152 66]/255,'markeredgecolor','none');
    drawnow;
end
% 
% if (i_sampling > 1 && i_sampling<=n_sampling) || ii>1
%     delete(h_hist)
% end

h_hist = histogram(mean(X,2),'binWidth',0.25,'FaceColor',[244 143 66]/255,'Normalization','probability');
hold off;
% xlim([0 10]);
% ylim([0 max(h_hist.Values)]);
