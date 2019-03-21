clear; close all; clc;

N=1000; % size of population (the number of elements in population)
n=50; % degree of freedom in chi-square distribution
Z=randn(N,1);
n_perm=1000;

mu=mean(Z);
sigma=std(Z);

for i_perm=1:n_perm
    X=Z(randperm(N,n));
    
    chi2(i_perm)=sum((X-mu).^2/sigma^2);
%     histogram(chi2);
%     pause(eps);
end
histogram(chi2);
hold on;
xlims=get(gca,'XLim');
ylims=get(gca,'Ylim');
chi2pdf_x=xlims(1):0.01:xlims(2);
Y=chi2pdf(chi2pdf_x,n);
if Y(1)==inf
    Y(1)=10;
end
max(Y);
Y_resized=Y/max(Y)*ylims(2);
plot(chi2pdf_x,Y_resized,'linewidth',2);

nogada_chi2_5per=quantile(chi2,0.95);
theoretical_chi2_5per=chi2inv(0.95,n);

h_nogada=line([nogada_chi2_5per nogada_chi2_5per],[ylims(1) ylims(2)],'color','r','linestyle','-.');
h_theoretical=line([theoretical_chi2_5per theoretical_chi2_5per],[ylims(1) ylims(2)],'color','k','linestyle','--');

legend([h_nogada h_theoretical],'NOGADA 5%','theoretical 5%')

title(['chi-square distribution via NOGADA and theoretical pdf / k=',num2str(n)]);





%% 아래는 잘못 한 예임... Sum ( (O-E)^2/E)를 통해서 chisquare distribution을 유도하면 안됨.
% clear; close all; clc;
%
% % proportion data
%
% N=1000;
% M=300;
% X=zeros(N,1);
% X(randperm(N,M))=1;
%
% % X에서 random하게 n개와 k개의 sample을 뽑는다고 해보자.
% n=20;
% k=25;
% n_perm=1000;
%
% for i_perm=1:n_perm
%     temp=X(randperm(N,n+k));
%     smpl1(:,i_perm)=temp(1:n);
%     smpl2(:,i_perm)=temp(n+1:end);
%     clear temp;
% end
% % CLT 조건을 만족하는가?
%
% CLT1=n*M/N;
% CLT2=n*(1-M/N);
% CLT3=k*M/N;
% CLT4=k*(1-M/N);
%
% if (CLT1>5)&&(CLT2>5)&&(CLT3>5)&&(CLT4>5)
%     disp('CLT 조건을 만족');
% else
%     error('CLT 조건을 만족하지 않음. Fiser exact test 하길 바람.');
% end
%
% cont_table=zeros(2,2,n_perm);
% cont_table(1,1,:)=sum(smpl1);
% cont_table(1,2,:)=n-sum(smpl1);
% cont_table(2,1,:)=sum(smpl2);
% cont_table(2,2,:)=k-sum(smpl2);
%
% expect_table=repmat([...
%     (n+k)*(M/N)*(n/(n+k)) (n+k)*(1-M/N)*(n/(n+k));...
%     (n+k)*(M/N)*(k/(n+k)) (n+k)*(1-M/N)*(k/(n+k))],[1,1,n_perm]);
%
% % 이렇게 하면 1000개의 chi square 값을 얻을 수 있게 된다.
%
% chi_square=squeeze(sum(sum(((abs(cont_table-expect_table)-1/2).^2)./expect_table,1),2)); % continuity correction 적용
% nogada_5percent=quantile(chi_square,0.95)
% theoretical_5percent=chi2inv(0.95,1)
% histogram(chi_square);
%
% xlim_temp=get(gca,'XLim');
% ylim_temp=get(gca,'YLim');
% X=0.01:0.01:xlim_temp(2);
%
% Y=chi2pdf(X,1);
% Y_changed=ylim_temp(2)*Y/max(Y);
% hold on;
% plot(X,Y_changed)
