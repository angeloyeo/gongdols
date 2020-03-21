clear; close all; clc;

addpath('..\')
%% Fig. 1. 세 표본 집단의 분포
%
% n_tot = 200;
%
% pop_data = randn(n_tot,1) * 5 + 80;
% pop_data = round(pop_data);
% [~,pop_sort_idx] = sort(pop_data);
% pop_data = pop_data(pop_sort_idx);
%
% data = zeros(10,3);
% idx_randperm = randperm(n_tot,30);
% for i = 1:3
%     data(:,i) = pop_data(idx_randperm(1+10*(i-1):10*i));
% end
% save('data.mat','data','idx_randperm','pop_data')
load('data.mat')
grp = ones(size(pop_data));
grp(idx_randperm(1:10)) = 2;
grp(idx_randperm(11:20)) = 3;
grp(idx_randperm(21:30)) = 4;

k_pop_data = unique(pop_data);

my_colors = [0.9, 0.9, 0.9; lines(3)];

figure('position',[683 300 560 420]);
max_ylim = 1;
for i_data = 1:length(k_pop_data)
    idx = pop_data == k_pop_data(i_data);
    find_idx = find(idx);
    
    if length(find_idx) > max_ylim
        max_ylim = length(find_idx);
    end
    
    for j_data = 1:length(find_idx)
        plot(k_pop_data(i_data), j_data ,'o','markersize',10,'markeredgecolor','k','markerfacecolor',my_colors(grp(find_idx(j_data)),:));
        hold on;
    end
    xlabel('몸무게 (kg)');
    ylabel('count')
    title('전체 마을 사람들 몸무게')
end

grid on;
% xlim([min(pop_data) max(pop_data)])
% ylim([0, max_ylim])

place = {'음식 A를 먹은 사람들','음식 B를 먹은 사람들','대조군'};

%% pic2
figure('position',[680, 82, 560, 700]);
for i = 1:3
    subplot(4,1,i)
    fun_plot_discrete_hist(data(:,i),'mksize',10,'mkfcolor',my_colors(i+1,:));
    grid on;
    xlim([min(pop_data) max(pop_data)])
    ylim([0.5 max_ylim/3])
    title(place{i});
    xlabel('몸무게 (kg)');
    ylabel('count')
    plot(mean(data(:,i)), 4, 'o','markerfacecolor','r' ,'markeredgecolor','none');
    plot([mean(data(:,i)) - std(data(:,i))/2, mean(data(:,i)) + std(data(:,i))/2], [4,4],'r' ,'linewidth',2)
end

for i=1:3
    subplot(4,1,4);
    plot(mean(data(:,i)),1,'o','markersize',10, 'markerfacecolor', my_colors(i+1,:),'markeredgecolor','k');
    hold on;
    xlim([min(pop_data) max(pop_data)])
    grid on;
    title('각 그룹의 표본 평균')
    ylim([0.5, 2])
end


%% savepics
for i_fig = 1:2
    figure(i_fig);
    saveas(gcf,['C:\angeloyeo.github.io\pics\2020-02-29_ANOVA\pic',num2str(i_fig),'.png']);
end

%% pic 3 test
close all

k_pop_data = unique(pop_data);
my_colors = [0.9, 0.9, 0.9; lines(3)];
max_ylim = 1;

xx_F = linspace(0, 5, 100);
yy_F_orig = pdf('F', xx_F, 2, 27);

% grp과 F 값 미리 계산
clear F

grp = ones([size(pop_data,1), 100]);

for i = 1:100
    idx_randperm = randperm(length(pop_data), 30);
    grp(idx_randperm(1:10), i) = 2;
    grp(idx_randperm(11:20), i) = 3;
    grp(idx_randperm(21:30), i) = 4;
    
    
    [~,tbl] = anova1([pop_data(grp(:,i)==2), pop_data(grp(:,i)==3), pop_data(grp(:,i)==4)],[],'off');
    F(i) = round(tbl{2,5}*5)/5;
end

%%%%%%%%%%%%%%%%%%%%%%% test plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('position',[488, 342, 1044, 420],'color','w');
subplot(1,2,1);
i=1;
for i_data = 1:length(k_pop_data)
    idx = pop_data == k_pop_data(i_data);
    find_idx = find(idx);

    if length(find_idx) > max_ylim
        max_ylim = length(find_idx);
    end

    for j_data = 1:length(find_idx)
        plot(k_pop_data(i_data), j_data ,'o','markersize',10,'markeredgecolor','k','markerfacecolor',my_colors(grp(find_idx(j_data), i),:));
        hold on;
    end
    xlabel('몸무게 (kg)');
    ylabel('count')
    title('전체 마을 사람들 몸무게')
end

subplot(1,2,2);
plot(xx_F, yy_F_orig / max(yy_F_orig) * 20,'color',lines(1), 'linewidth',2)
hold on;
fun_plot_discrete_hist(F,'mksize',10,'mkfcolor',my_colors(1,:));
xlim([-0.5, 5])
ylim([0, 20])
xlabel('F-value')
ylabel('count')

%% pic 3 in gif
%%%%%%%%%%%%%%%%%%%%%%%%%%%% gif plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('position',[488, 342, 1044, 420],'color','w');

for i = 1:100
    disp(['count: ', num2str(i)]);

    subplot(1,2,1);

    cla;

    for i_data = 1:length(k_pop_data)
        idx = pop_data == k_pop_data(i_data);
        find_idx = find(idx);
        
        if length(find_idx) > max_ylim
            max_ylim = length(find_idx);
        end
        
        for j_data = 1:length(find_idx)
            plot(k_pop_data(i_data), j_data ,'o','markersize',10,'markeredgecolor','k','markerfacecolor',my_colors(grp(find_idx(j_data), i),:));
            hold on;
        end
        xlabel('몸무게 (kg)');
        ylabel('count')
        title('전체 마을 사람들 몸무게')
    end
    
    grid on;
    xlim([min(pop_data) max(pop_data)])
    % ylim([0, max_ylim])
    
    place = {'음식 A를 먹은 사람들','음식 B를 먹은 사람들','대조군'};
    
    subplot(1,2,2);
    plot(xx_F, yy_F_orig / max(yy_F_orig) * 20,'color',lines(1), 'linewidth',2)
    fun_plot_discrete_hist(F(1:i),'mksize',10,'mkfcolor',my_colors(1,:));
    xlim([-0.5, 5])
    ylim([0, 20])
    xlabel('F-value')
    ylabel('count')
    drawnow;
end