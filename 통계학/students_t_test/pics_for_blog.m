clear; close all; clc;

%% pic 1
mksize = 15;
XLIMs = [-5, 7];
YLIMs = [0.5, 6.5];
% 왼쪽 그림
figure('position',[488, 437, 317, 324]);
subplot(2,1,1);
xx = [-2, -1, -1, 0, 2];
yy = [1, 1, 2, 1, 1];
plot(xx, yy, 'o', 'markersize',mksize,'markerfacecolor',lines(1),'markeredgecolor','none');
xlim(XLIMs)
ylim(YLIMs)
grid on;
xlabel('x');
ylabel('count')

subplot(2,1,2);
xx = [0, 1, 2, 3, 4];
yy = [1, 1, 1, 1, 1];
plot(xx, yy, 'o', 'markersize',mksize,'markerfacecolor',[0.85, 0.325, 0.098],'markeredgecolor','none');
xlim(XLIMs)
ylim(YLIMs)
grid on;

xlabel('x');
ylabel('count')

% 오른쪽 그림
figure('position',[809 437 317 324]);
subplot(2,1,1);
xx = [-3, -3, -2, -2, -2, -1, -1, -1, -1, -1, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2]
yy = [1, 2, 1, 2, 3, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2, 3, 1, 2];
plot(xx, yy, 'o', 'markersize',mksize,'markerfacecolor',lines(1),'markeredgecolor','none');
xlim(XLIMs)
ylim(YLIMs)
grid on;

xlabel('x');
ylabel('count')
subplot(2,1,2);
xx = [-1, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 6];
yy = [1, 1, 2, 1, 2, 3, 4, 1, 2, 3, 4, 5, 1, 2, 3, 4, 1, 2, 3, 1];
plot(xx, yy, 'o', 'markersize',mksize,'markerfacecolor',[0.85, 0.325, 0.098],'markeredgecolor','none');
xlim(XLIMs)
ylim(YLIMs)
grid on;

xlabel('x');
ylabel('count')

%% pic 3
load('C:\gongdols\통계학\sampling_and_standard_error\data.mat')

k_data = unique(data);
my_order = [];

for i_data = 1:length(k_data)
    idx = data == k_data(i_data);
    
    for i_idx = 1:sum(idx)
        my_order = [my_order, i_idx];
    end
end

figure('position',[125.800000000000,287.400000000000,1331.20000000000,420.000000000000],'color','w');

tvals2draw = [];
my_max = 8.78;

n_step = 100;
sample_size = 6;

xx_T = linspace(-5, 5, 100);
yy_T_orig = pdf('T', xx_T, sample_size*2-2);

for i = 1:n_step
    k_data = unique(data);
    data_sort = sort(data);
    
    idx_perm1 = randperm(length(data),sample_size);
    idx_perm2 = randperm(length(data),sample_size);
    subplot(1,2,1);
    
    for i_data = 1:length(k_data)
        idx = data == k_data(i_data);
        find_idx = find(idx);
        
        for i_idx = 1:sum(idx)
            plot(data(find_idx(i_idx)), i_idx, 'o','markersize',mksize,'markerfacecolor',ones(1,3) * 0.8, 'markeredgecolor','k');
            hold on;
        end
    end
    xlim([8 22])
    ylim([0, 40])
    grid on;
    xlabel('height(cm)');
    ylabel('count');
    title('금성에 사는 외계인 150명의 키');
    
    h1 = plot(data_sort(idx_perm1), my_order(idx_perm1),'o','markersize',mksize,'markerfacecolor','r',...
        'markeredgecolor','none');
    h2 = plot(data_sort(idx_perm2), my_order(idx_perm2),'o','markersize',mksize,'markerfacecolor','b',...
        'markeredgecolor','none');
    legend([h1,h2], '표본 그룹 1', '표본 그룹 2')
    subplot(1,2,2);
    k_data = unique(tvals2draw);
    
    for i_data = 1:length(k_data)
        idx = tvals2draw == k_data(i_data);
        find_idx = find(idx);
        
        for i_idx = 1:sum(idx)
            plot(tvals2draw(find_idx(i_idx)), i_idx, 'o','markersize',mksize ,'markerfacecolor',ones(1,3) * 0.8, 'markeredgecolor','k');
            hold on;
        end
        
        if sum(idx) > my_max
            my_max = sum(idx);
        end
        
    end
    
    [~,~,~,stats] = ttest2(data_sort(idx_perm1),data_sort(idx_perm2));
    temp_t = stats.tstat;
    temp_t = round(temp_t);
    
    ycoord = sum(tvals2draw == temp_t) + 1;
    plot(temp_t, ycoord, 'o','markersize',mksize,'markerfacecolor',ones(1,3) * 0.8, ...
        'markeredgecolor',[1, 0.325 0.098],'linewidth',4);
    hold on;
    tvals2draw = [tvals2draw temp_t];
    xlim([-5 5])
    if i== 1
        ylim([0, 40]);
        y_height = 40;
    end
    
    if ycoord > 40
        ylim([0, ycoord]);
        y_height = ycoord;
    end
    yy_T = yy_T_orig./max(yy_T_orig) * y_height;
    plot(xx_T, yy_T,'color',lines(1),'linewidth',2) 

    grid on;
    xlabel('t-value');
    ylabel('count');
    title('n=6인 샘플 집단 2개를 100번 뽑고 그 때 마다의 t-value 분포 확인');
    
    drawnow;
    %     pause;
    
    if i < n_step
        subplot(1,2,1); cla;
        subplot(1,2,2); cla;
    else
        subplot(1,2,2); cla;
        
        k_data = unique(tvals2draw);
        
        for i_data = 1:length(k_data)
            idx = tvals2draw == k_data(i_data);
            find_idx = find(idx);
            
            for i_idx = 1:sum(idx)
                plot(tvals2draw(find_idx(i_idx)), i_idx, 'o','markersize',mksize ,'markerfacecolor',ones(1,3) * 0.8, 'markeredgecolor','k');
                hold on;
            end
            
            if sum(idx) > my_max
                my_max = sum(idx);
            end
            
        end
    end
    
    plot(xx_T, yy_T,'color',lines(1),'linewidth',2) 

end
%% t-분포는 dof가 커질 수록 normal distribution에 가까워진다.
figure;
dofs = 5:5:50;
xx = linspace(-10, 10, 500);

my_colors = jet(length(dofs));

for i_dof = 1:length(dofs)
    
    yy = pdf('T',xx, dofs(i_dof));
    
    plot(xx, yy,'color',my_colors(i_dof,:))
    hold on;
end

yy_normal = pdf('Normal', xx, 0, 1);
plot(xx, yy_normal,'color','k','linewidth',3)

