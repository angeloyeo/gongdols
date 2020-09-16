clear; close all; clc;
data = [162, 164, 164, 166, 166, 166, ones(1,6) * 168, ones(1,5) * 170, ones(1,4) * 172, ones(1,3) * 174, ones(1,3) * 176, 178, 178, 180];

%% Fig 1. 표본 추출 및 표본 평균 소개

figure('position',[125.800000000000,287.400000000000,1331.20000000000,420.000000000000]);
subplot(1,2,1);

k_data = unique(data);

for i_data = 1:length(k_data)
    idx = data == k_data(i_data);
    find_idx = find(idx);
    
    for i_idx = 1:sum(idx)
        plot(data(find_idx(i_idx)), i_idx, 'o','markersize',30,'markerfacecolor',ones(1,3) * 0.8, 'markeredgecolor','k');
        hold on;
    end
    pause;
end

set(gca,'xtick', 160:4:180)
xlim([160 182])
ylim([0.5 8.78])
xlabel('키 (cm)');
ylabel('count');
grid on;
title('3학년 1반 전체 학생의 키 (n=30)');
set(gca,'fontsize',12)

% 파란색 표시
blue = [164,2; 166,1; 168,1];
plot(blue(:,1), blue(:,2),  'o','markersize',30,'markerfacecolor',ones(1,3) * 0.8, 'markeredgecolor',lines(1),'linewidth',4);

% 빨간색 표시
red = [168, 4; 170, 3; 178, 2];
plot(red(:,1), red(:,2),  'o','markersize',30,'markerfacecolor',ones(1,3) * 0.8, 'markeredgecolor',[1, 0.325 0.098],'linewidth',4);

subplot(1,2,2);
plot(round(mean(blue,1)), 1, 'o','markersize',30,'markerfacecolor',ones(1,3) * 0.8, 'markeredgecolor',lines(1), 'linewidth',4);
hold on;
plot(round(mean(red,1)), 1, 'o','markersize',30,'markerfacecolor',ones(1,3) * 0.8, 'markeredgecolor',[1, 0.325, 0.098],'linewidth',4);

set(gca,'xtick', 160:4:180)
xlim([160 182])
ylim([0.5 8.78])
xlabel('키 (cm)');
ylabel('count');
grid on;
title('3학년 1반 학생의 표본 평균 분포 (sample size = 3)');
set(gca,'fontsize',12)

%% Fig 2. 무수히 많은 표본 추출 & 평균

newVid = VideoWriter('D:\angeloyeo.github.io\pics\2020-09-15-CLT_meaning\pic2', 'MPEG-4'); % New
newVid.FrameRate = 7;
newVid.Quality = 100;
open(newVid);

figure('position',[125.800000000000,287.400000000000,1331.20000000000,420.000000000000],'color','w');

mns2draw = [];
my_max = 8.78;

n_step = 100;
sample_size = 3;

for i = 1:n_step
    
    data = [162, 164, 164, 166, 166, 166, ones(1,6) * 168, ones(1,5) * 170, ones(1,4) * 172, ones(1,3) * 174, ones(1,3) * 176, 178, 178, 180];
    ycoords = [1 1,2, 1,2,3, 1,2,3,4,5,6, 1,2,3,4,5, 1,2,3,4, 1,2,3, 1,2,3, 1,2, 1];
    
    idx_perm = randperm(30,sample_size);
    k_data = unique(data);
    
    subplot(1,2,1);
    
    for i_data = 1:length(k_data)
        idx = data == k_data(i_data);
        find_idx = find(idx);
        
        for i_idx = 1:sum(idx)
            plot(data(find_idx(i_idx)), i_idx, 'o','markersize',30,'markerfacecolor',ones(1,3) * 0.8, 'markeredgecolor','k');
            hold on;
        end
    end
    
    set(gca,'xtick', 160:4:180)
    xlim([160 182])
    ylim([0.5 8.78])
    xlabel('키 (cm)');
    ylabel('count');
    grid on;
    title('3학년 1반 전체 학생의 키 (n=30)');
    set(gca,'fontsize',12)
    
    plot(data(idx_perm), ycoords(idx_perm), 'o','markersize',30,'markerfacecolor',ones(1,3) * 0.8, 'markeredgecolor',[1, 0.325, 0.098],'linewidth',4);
    
    subplot(1,2,2);
    
    k_data = unique(mns2draw);
    
    for i_data = 1:length(k_data)
        idx = mns2draw == k_data(i_data);
        find_idx = find(idx);
        
        for i_idx = 1:sum(idx)
            plot(mns2draw(find_idx(i_idx)), i_idx, 'o','markersize',30 / my_max * 8.78 ,'markerfacecolor',ones(1,3) * 0.8, 'markeredgecolor','k');
            hold on;
        end
        
        if sum(idx) > my_max
            my_max = sum(idx);
        end
        
    end
    
    temp_mean= mean(data(idx_perm));
    
    temp_mean = round(temp_mean);
    
    if rem(temp_mean,2) ~= 0 % round 했는데 홀수로 나오는 경우 짝수로 만들어주려고 함.
        if (temp_mean - mean(data(idx_perm))) > 0 && (temp_mean - mean(data(idx_perm))) < 0.5 % 1을 올리는게 더 좋은 경우
            temp_mean = temp_mean + 1;
        else
            temp_mean = temp_mean - 1;
        end
    end
    
    ycoord = sum(mns2draw == temp_mean) + 1;
    plot(temp_mean, ycoord, 'o','markersize',30,'markerfacecolor',ones(1,3) * 0.8, 'markeredgecolor',[1, 0.325 0.098],'linewidth',4);
    hold on;
    mns2draw = [mns2draw temp_mean];
    
    set(gca,'xtick', 160:4:180)
    xlim([160 182])
    ylim([0.5 my_max])
    
    
    xlabel('키 (cm)');
    ylabel('count');
    grid on;
    title(['3학년 1반 학생의 표본 평균 분포 (sample size = ',num2str(sample_size),')']);
    set(gca,'fontsize',12)
    
    writeVideo(newVid, getframe(gcf))
    drawnow;
    %     pause;
    
    if i < n_step
        subplot(1,2,1); cla;
        subplot(1,2,2); cla;
    else
        subplot(1,2,2); cla;
        
        k_data = unique(mns2draw);
        
        for i_data = 1:length(k_data)
            idx = mns2draw == k_data(i_data);
            find_idx = find(idx);
            
            for i_idx = 1:sum(idx)
                plot(mns2draw(find_idx(i_idx)), i_idx, 'o','markersize',30 / my_max * 8.78 ,'markerfacecolor',ones(1,3) * 0.8, 'markeredgecolor','k');
                hold on;
            end
            
            if sum(idx) > my_max
                my_max = sum(idx);
            end
            
        end
    end
end
close(newVid)

%% Fig 3. 임의의 distribution으로부터 데이터를 얻고 sampling

for pic_num = 3:5
    newVid = VideoWriter(['D:\angeloyeo.github.io\pics\2020-09-15-CLT_meaning\pic',num2str(pic_num)], 'MPEG-4'); % New
    newVid.FrameRate = 7;
    newVid.Quality = 100;
    open(newVid);
    
    % defining variables
    close all;
    pop_size=30;
    pop_mn=170;
    pop_sd=10;
    
    if pic_num == 3
        % population의 분포가 uniform distribution인 경우
        data =pop_mn+pop_sd*(2*rand(pop_size,1)-1);
    elseif pic_num ==4
        % population의 분포가 poisson distribution인 경우
        poisson_lambda=4;
        data =pop_mn+poissrnd(poisson_lambda,pop_size,1)-poisson_lambda;
    elseif pic_num ==5
        % population의 분포가 beta distribution인 경우
        A=0.5; B=0.5;
        data=pop_mn+pop_sd*betarnd(A,B,[pop_size,1])-0.5*pop_sd;
    else
        warning('out of expectation!');
    end
    
    for i_data = 1:length(data)
        temp = round(data(i_data));
        
        if rem(temp,2) ~= 0 % round 했는데 홀수로 나오는 경우 짝수로 만들어주려고 함.
            a = temp - round(temp);
            if a > 0 && a < 0.5
                temp = temp + 1;
            else
                temp = temp - 1;
            end
        end
        
        data(i_data) = temp;
    end
    
    data = sort(data);
    [uniq_data, ia, ic] = unique(data);
    ycoords = [];
    
    for i_data = 1:length(uniq_data)
        ycoords = [ycoords 1:sum(data == uniq_data(i_data))];
    end
    
    
    figure('position',[125.800000000000,287.400000000000,1331.20000000000,420.000000000000],'color','w');
    
    mns2draw = [];
    my_max = 8.78;
    
    n_step = 100;
    sample_size = 3;
    
    for i = 1:n_step
        k_data = unique(data);
        
        idx_perm = randperm(30,sample_size);
        subplot(1,2,1);
        
        for i_data = 1:length(k_data)
            idx = data == k_data(i_data);
            find_idx = find(idx);
            
            for i_idx = 1:sum(idx)
                plot(data(find_idx(i_idx)), i_idx, 'o','markersize',30,'markerfacecolor',ones(1,3) * 0.8, 'markeredgecolor','k');
                hold on;
            end
        end
        
        set(gca,'xtick', 160:4:180)
        xlim([160 182])
        ylim([0.5 8.78])
        xlabel('키 (cm)');
        ylabel('count');
        grid on;
        title('3학년 1반 전체 학생의 키 (n=30)');
        set(gca,'fontsize',12)
        
        plot(data(idx_perm), ycoords(idx_perm), 'o','markersize',30,'markerfacecolor',ones(1,3) * 0.8, 'markeredgecolor',[1, 0.325, 0.098],'linewidth',4);
        
        subplot(1,2,2);
        
        k_data = unique(mns2draw);
        
        for i_data = 1:length(k_data)
            idx = mns2draw == k_data(i_data);
            find_idx = find(idx);
            
            for i_idx = 1:sum(idx)
                plot(mns2draw(find_idx(i_idx)), i_idx, 'o','markersize',30 / my_max * 8.78 ,'markerfacecolor',ones(1,3) * 0.8, 'markeredgecolor','k');
                hold on;
            end
            
            if sum(idx) > my_max
                my_max = sum(idx);
            end
            
        end
        
%         data(idx_perm)
        temp_mean= mean(data(idx_perm));
        
        temp_mean = round(temp_mean);
        
        if rem(temp_mean,2) ~= 0 % round 했는데 홀수로 나오는 경우 짝수로 만들어주려고 함.
            if (temp_mean - mean(data(idx_perm))) > 0 && (temp_mean - mean(data(idx_perm))) < 0.5 % 1을 올리는게 더 좋은 경우
                temp_mean = temp_mean + 1;
            else
                temp_mean = temp_mean - 1;
            end
        end
        
        ycoord = sum(mns2draw == temp_mean) + 1;
        plot(temp_mean, ycoord, 'o','markersize',30,'markerfacecolor',ones(1,3) * 0.8, 'markeredgecolor',[1, 0.325 0.098],'linewidth',4);
        hold on;
        mns2draw = [mns2draw temp_mean];
        
        set(gca,'xtick', 160:4:180)
        xlim([160 182])
        ylim([0.5 my_max])
        
        
        xlabel('키 (cm)');
        ylabel('count');
        grid on;
        title(['3학년 1반 학생의 표본 평균 분포 (sample size = ',num2str(sample_size),')']);
        set(gca,'fontsize',12)
        writeVideo(newVid, getframe(gcf))
        
        drawnow;
        %     pause;
        
        if i < n_step
            subplot(1,2,1); cla;
            subplot(1,2,2); cla;
        else
            subplot(1,2,2); cla;
            
            k_data = unique(mns2draw);
            
            for i_data = 1:length(k_data)
                idx = mns2draw == k_data(i_data);
                find_idx = find(idx);
                
                for i_idx = 1:sum(idx)
                    plot(mns2draw(find_idx(i_idx)), i_idx, 'o','markersize',30 / my_max * 8.78 ,'markerfacecolor',ones(1,3) * 0.8, 'markeredgecolor','k');
                    hold on;
                end
                
                if sum(idx) > my_max
                    my_max = sum(idx);
                end
                
            end
        end
    end
    close(newVid)

end