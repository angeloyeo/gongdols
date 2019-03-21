clear all; close all; clc;
 
n=500;      %n=number of datapoints
a(:,1)=normrnd(0,1,n,1);        %n random Gaussian values with mean 0, std.dev. 1
a(:,2)=normrnd(0,1,n,1);        %Repeat for the 2nd dimension.
b(:,1)=normrnd(0,1,n,1);        %n random Gaussian values with mean 0, std.dev. 1
%For b, the 2nd dimension is correlated with the 1st.
b(:,2)=b(:,1)*0.5+0.5*normrnd(0,1,n,1);
 
subplot(211);
plot(a(:,1),a(:,2),'.');
subplot(212);
plot(b(:,1),b(:,2),'r.');


figure;
scatter(b(:,1)+80,b(:,2)+75)
% xlim([-5 5]); ylim([-5 5])
xlabel('수학 점수'); ylabel('영어 점수');
grid on