clear; close all; clc;

%% 동일한 모집단에서 뽑았을 때. 
pop_1=randn(5000,1);
n_comp = 1000;
n_samp = 100;

clear i p1
for i = 1:n_comp
    nums1 = randperm(5000,n_samp);
    nums2 = randperm(5000,n_samp);

    [~,p1(i)]=ttest2(pop_1(nums1), pop_1(nums2));
end

histogram(p1,20)
xlim([0 1])

%% 서로 다른 두 모집단에서 뽑았을 때

pop_2 = randn(2500,1)-0.15;
pop_3 = randn(2500,1)+0.15;

clear i p2
for i = 1:n_comp
    nums3 = randperm(2500,n_samp);
    nums4 = randperm(2500,n_samp);
    
    [~,p2(i)]=ttest2(pop_2(nums3), pop_3(nums4));
end

figure;
histogram(p2,20);
xlim([0 1])

%% p1+p2
figure;
histogram([p1 p2],20)
    