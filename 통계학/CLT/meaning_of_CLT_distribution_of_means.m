clear; close all; clc;

% 이 matlab code에서 CLT의 의미.
% 유한한 갯수의 구성요소로 구성된 모집단에서 임의의 n개의 샘플을 추출해 평균을 구해주는 과정을
% 무한번에 가깝게 반복해주게 되면 histogram의 모양은 정규분포에 가까워진다.

%% defining variables 

pop_size=1000;
pop_mn=160;
pop_sd=10;

%% population의 분포가 uniform distribution인 경우
% X=pop_mn+pop_sd*(2*rand(pop_size,1)-1);

%% population의 분포가 poisson distribution인 경우
poisson_lambda=4;
X=pop_mn+poissrnd(poisson_lambda,pop_size,1)-poisson_lambda;

%% population의 분포가 beta distribution인 경우
% A=0.5; B=0.5;
% X=pop_mn+pop_sd*betarnd(A,B,[pop_size,1])-0.5*pop_sd;

%% population의 분포가 normal distribution인 경우
% X=pop_mn+pop_sd*randn(pop_size,1);


%% histogram of population
hist(X)
title('histogram of population');
xlabel('height'); ylabel('# of observations');

%% fontsize
set(gca,'fontsize',15);

%% picking random N variables

figure;
N=100;
n_iter=500;
% mns=zeros(n_iter,1);
clear mns
for i_iter=1:n_iter
    mns(i_iter,1)=mean(X(randperm(size(X,1),N)));
    hist(mns);
    drawnow
end

figure; hist(mns)
title('distribution of means'); xlabel('mean of height'); ylabel('# of observation');

%% making t-distributions

figure;
N=100;
n_iter=500;
% mns=zeros(n_iter,1);
clear mns ts
mu=mean(X);

% 수동 조작시에만 사용
% i_iter=i_iter+1;


for i_iter=1:n_iter
    rand_smpls=X(randperm(size(X,1),N));
    mn=mean(rand_smpls);
    stds=std(rand_smpls);
    sem=stds/sqrt(N);
    ts(i_iter,1)=((mn-mu)/sem);
    clear mn stds sem
    hist(ts);
    drawnow
end

figure; hist(ts)
title('distribution of t-values'); xlabel('t-values'); ylabel('frequency');

T_cal=quantile(ts,0.975);
T_theo=tinv(0.975,N-1);

hold on;
xlim_gca=get(gca,'xlim');
ylim_gca=get(gca,'ylim');
t_xaxis=linspace(xlim_gca(1),xlim_gca(2),500);
t_distribution=max(ylim_gca)/0.4*tpdf(t_xaxis,N-1);
h_t_dist=plot(t_xaxis,t_distribution,'r','linewidth',3);

h1=line([T_cal T_cal],[0 max(ylim_gca)],'color','red','linestyle','-.')
h2=line([T_theo T_theo],[0 max(ylim_gca)],'color','black','linestyle','--')
legend([h_t_dist h1 h2],'t-distribution','calculated','theoretical','location','best')