clear; close all; clc;

%% DEFINE
Xs = [];
ii=1;
%% CANVAS
figure;
set(gcf,'position',[680 330 900 650])
set(gcf,'color','w');
axis_canvas = gca;
set(gca,'visible','off')

xlim([-4 4])
ylim([0 400])

% 선 그어주기
line(xlim,[50 50],'color','k')
hold on;
line(xlim,[200 200],'color','k')
line(xlim,[300 300],'color','k')

% xtick 그려주기
for i = -4:4
    line([i i],[48 52],'color','k')
end

% xtick text
for i = -4:4
    text(i-0.05,44,num2str(i));
end


%% top
axis_top = axes('position',[117/900, 469/650, (900-86-117)/900 140/650]);
pop_size=5;
pop_mn=0;
pop_sd=1;

pd = makedist('normal','mu',pop_mn,'sigma',pop_sd);
x = linspace(-10,10,1000);
y = pdf(pd,x);
area(x,y,'facecolor',[255 229 175]/255);
hold on;
set(axis_top,'visible','off')
xlim([-4 4])

%% middle
% sampling
n_sampling = 100;
Xs = [Xs; nan(n_sampling,pop_size)];
n_steps = 2; % animation steps. 30 느린 편. 10 약간 빠른 편.
% if ii>1
%     delete(h_hist)
% end

for i_sampling = 1:n_sampling
    X=pop_mn+pop_sd*(randn(pop_size,1));
    Xs(ii,:)=X;
    set(gcf,'currentaxes',axis_canvas);
    circles = plot(X,300,'o','markerfacecolor',[244 152 66]/255,'markeredgecolor','none');
    
    % from top to middle
    for i_steps = 1:n_steps
        delete(circles)
        circles = plot(X,300+(200-300)*i_steps/n_steps,'o','markerfacecolor',[244 152 66]/255,'markeredgecolor','none');
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
        circles = plot(mean(X), 200+(50-200)*i_steps/n_steps,'o','markerfacecolor',[244 152 66]/255,'markeredgecolor','none');
        drawnow;
    end
    
    %% bottom
    axis_bottom = axes('Position',[117/900 138/650 (900-86-117)/900 140/650]);
    
    if (i_sampling > 1 && i_sampling<=n_sampling) || ii>1
        delete(h_hist)
    end
    
    h_hist = histogram(mean(Xs,2),'binWidth',0.25,'FaceColor',[244 143 66]/255,'Normalization','probability');
    hold off;
    xlim([-4 4]);
    ylim([0 max(h_hist.Values)]);
    
    set(axis_bottom,'visible','off')
    ii=ii+1;
end
% set(axis_bottom,'Color','none','YColor','none')
