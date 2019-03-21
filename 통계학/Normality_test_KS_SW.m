clear; close all; clc;
Group1=[10;16;27;15;21;14;16;21;22;23;25;28;27;13;15;16;21;22;25;28];
Group2=[23;26;27;23;16;18;31;33;28;36;18;21;26;28;29;33;32;16;18;23];

hist(Group1);title('histogram of Group1');
figure;
hist(Group2); title('histogram of Group2');

%% Kolmogorov-Smirmov test

% group1

[h_KS_g1,p_KS_g1,ksstat_g1]=kstest((Group1-mean(Group1))/std(Group1));

% group2

[h_KS_g2,p_KS_g2,ksstat_g2]=kstest((Group2-mean(Group2))/std(Group2));

%% Shapiro-Wilk test

% group 1

[H_SW_g1,p_SW_g1,SWstatistic_g1]=swtest((Group1-mean(Group1))/std(Group1),0.05)

% group 2

[H_SW_g2,p_SW_g2,SWstatistic_g2]=swtest((Group2-mean(Group2))/std(Group2),0.05)


%% PDF & CDF 확인

figure;

%% PDF 확인


% group 1
subplot(2,2,1);
[f,x_values]=ksdensity((Group1-mean(Group1))/std(Group1));
F=plot(x_values,f);
set(F,'LineWidth',2);
hold on;
G=plot(x_values,normpdf(x_values,0,1),'r-.');
set(G,'LineWidth',2);
title('Group 1 PDF & Normal Distribution PDF');
legend([F G],...
    'Empirical PDF','Standard-Normal PDF',...
    'Location','best');
set(gca,'fontsize',15);

% group 2
subplot(2,2,2)
[f,x_values]=ksdensity((Group2-mean(Group2))/std(Group2));
F=plot(x_values,f);
set(F,'LineWidth',2);
hold on;
G=plot(x_values,normpdf(x_values,0,1),'r-.');
set(G,'LineWidth',2);
title('Group 2 PDF & Normal Distribution PDF');
legend([F G],...
    'Empirical PDF','Standard-Normal PDF',...
    'Location','best');
set(gca,'fontsize',15);

%% CDF 확인

% group 1
subplot(2,2,3)

[f,x_values]=ecdf((Group1-mean(Group1))/std(Group1));
F=plot(x_values,f);
set(F,'LineWidth',2);
hold on;
G=plot(x_values,normcdf(x_values,0,1),'r-.');
set(G,'LineWidth',2);
title('Group 1 CDF & Normal Distribution CDF');
legend([F G],...
    'Empirical CDF','Standard-Normal CDF',...
    'Location','SE');
set(gca,'fontsize',15);
% group 2
subplot(2,2,4);

[f,x_values]=ecdf((Group2-mean(Group2))/std(Group2));
F=plot(x_values,f);
set(F,'LineWidth',2);
hold on;
G=plot(x_values,normcdf(x_values,0,1),'r-.');
set(G,'LineWidth',2);
title('Group 2 CDF & Normal Distribution CDF');
legend([F G],...
    'Empirical CDF','Standard-Normal CDF',...
    'Location','SE');
set(gca,'fontsize',15);
