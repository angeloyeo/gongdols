clear; close all; clc;

addpath('C:\gongdols\통계학\');

%% pic2 sampling from two different population dist.

n_tot = 200;

pop_data1 = randn(n_tot,1) * 5 + 80;
pop_data1 = round(pop_data1);
[~,pop_sort_idx] = sort(pop_data1);
pop_data1 = pop_data1(pop_sort_idx);

pop_data2 = randn(n_tot,1) * 5 + 30;
pop_data2 = round(pop_data2);
[~,pop_sort_idx] = sort(pop_data2);
pop_data2 = pop_data2(pop_sort_idx);

idx_randperm_for_pop1 = randperm(n_tot,30);
idx_randperm_for_pop2 = randperm(n_tot,30);

sample_from_pop1 = pop_data1(idx_randperm_for_pop1);
sample_from_pop2 = pop_data2(idx_randperm_for_pop2);

save('data.mat','pop_data*','idx_randperm*','sample_from*')
load('data.mat')

grp_pop1 = ones(size(pop_data1));
grp_pop1(idx_randperm_for_pop1) = 2;

grp_pop2 = ones(size(pop_data2));
grp_pop2(idx_randperm_for_pop2) = 2;

k_pop_data1 = unique(pop_data1);
k_pop_data2 = unique(pop_data2);

my_colors = [0.9, 0.9, 0.9; 1, 0 ,0];

figure('position',[15, 300 , 1523, 420]);
max_ylim = 1;
for i_data = 1:length(k_pop_data1)
    idx = pop_data1 == k_pop_data1(i_data);
    find_idx = find(idx);
    
    if length(find_idx) > max_ylim
        max_ylim = length(find_idx);
    end
    
    for j_data = 1:length(find_idx)
        plot(k_pop_data1(i_data), j_data ,'o','markersize',10,'markeredgecolor','k','markerfacecolor',my_colors(grp_pop1(find_idx(j_data)),:));
        hold on;
    end
end

for i_data = 1:length(k_pop_data2)
    idx = pop_data2 == k_pop_data2(i_data);
    find_idx = find(idx);
    
    if length(find_idx) > max_ylim
        max_ylim = length(find_idx);
    end
    
    for j_data = 1:length(find_idx)
        plot(k_pop_data2(i_data), j_data ,'o','markersize',10,'markeredgecolor','k','markerfacecolor',my_colors(grp_pop2(find_idx(j_data)),:));
        hold on;
    end
end


grid on;
% xlim([min(pop_data) max(pop_data)])
% ylim([0, max_ylim])

place = {'음식 A를 먹은 사람들','음식 B를 먹은 사람들','대조군'};