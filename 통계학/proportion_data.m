clear; close all; clc;

% proportion data

N=1000;
M=300;
X=zeros(N,1);
X(randperm(N,M))=1;

% X에서 random하게 10개의 샘플을 뽑는다고 해보자.
n=19;
n_perm=1000;
for i_perm=1:n_perm
    means(i_perm,1)=sum(X(randperm(N,n)))/n;
    histogram(means);
    pause(eps);
end

figure; histogram(means);
pop_mean=M/N;
pop_std=sqrt(pop_mean*(1-pop_mean));
std_err=pop_std/sqrt(n);
temp=get(gca,'XLim');
X=temp(1):0.01:temp(2); clear temp;
temp=get(gca,'YLim');
Y=pop_mean*temp(2)*normpdf(X,pop_mean,std_err); clear temp;

hold on; plot(X,Y);

