clear; close all; clc;

X=randn(1000,1);

m=3; n=15;
n_perm=1000;
% F_perm=zeros(n_perm,1);
for i_perm=1:n_perm
    cla
    
    for i_m=1:m
        X_smpl(:,i_m)=X(randperm(1000,n));
    end
    s_wit=sqrt(sum(std(X_smpl).^2))/sqrt(3);
    
    
    m_total=mean(mean(X_smpl));
    temp=mean(X_smpl)-m_total;
    s_xbar=sqrt(sum(temp.^2)/(m-1));
    
    s_bet=sqrt(n)*(s_xbar);
    
    F=s_bet^2/s_wit^2;
    F_perm(i_perm,1)=F;
    clear F s_bet s_xbar temp m_total s_with X_smpl
    h=histogram(F_perm);
    pause(eps);
end

figure;
histogram(F_perm);
hold on;
x=0:0.01:10;
ylims=get(gca,'ylim');
y=ylims(2)*fpdf(x,m-1,m*(n-1));
h2=plot(x,y,'r','linewidth',3);

xlabel('F-values'); ylabel('# observations');
title('comparison between theory and NOGADA')

F_crit=finv(0.95,m-1,m*(n-1));
F_nogada=quantile(F_perm,0.95);
h3=line([F_crit F_crit],ylims,'color','r','linestyle','-.','linewidth',2);
h4=line([F_crit F_crit],ylims,'color','k','linestyle','--');

legend([h2, h3, h4] ,'F-distribution','theoretic crit F','NOGADA crit F');