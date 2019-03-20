clear all; close all; clc;

temp=500;
completedata=[randn(temp,1)*1-1 randn(temp,1)*0.5+5 1*ones(temp,1);...
    randn(temp,1)*1+9 randn(temp,1)*0.5+2 2*ones(temp,1);...
    randn(temp,1)*0.5+9 randn(temp,1)*0.5+7 3*ones(temp,1);];

plot(completedata(1:500,1),completedata(1:500,2),'r.');
hold on;
plot(completedata(501:1000,1),completedata(501:1000,2),'g.');
plot(completedata(1001:1500,1),completedata(1001:1500,2),'b.');

%% x 축 방향으로 dimension을 줄여주면 다음과 같이 된다.
figure;
plot(completedata(1:500,1),zeros(500,1),'r+',completedata(501:1000,1),zeros(500,1),'g+',completedata(1001:1500,1),zeros(500,1),'b+');

%% LDA 방법을 이용하면 다음과 같다.

X=completedata; %Label input data as X
classes = X(:,3);%seperate Classes from data
X = X(:,1:2); % Seperate data from classes
[SB SW] = findscatter(X,classes);% Find Scatter Matrix
temp=inv(SW)*SB;%Calculate Product of inverse of SW and SB
[V,D] = eig(temp);%Find eigen vectors and eigen values
V = fliplr(V);%Sort Eigen vectors in decreasing order of eigen values
c=1;%Number of dimensions required in reduced form
w = V(:,1:c);%Calculate w
X = X'; %Take X transpose for multiplication
Y = w'*X;%Calculate Y
Y=Y'; %Take Y transpose for plotting
figure;
plot(Y(1:500,1),zeros(500,1),'r+',Y(501:1000,1),zeros(500,1),'g+',Y(1001:1500,1),zeros(500,1),'b+');%plot

centroids_overall=[mean(completedata(:,1)) mean(completedata(:,2))];

% eigen 1 길이
eig1_len=D(1,1);
% eigen 1 방향
eig1_dir=V(:,1);

% eigen 2 길이
eig2_len=D(2,2);
% eigen 2 방향
eig2_dir=V(:,2);
figure(1);
quiver(centroids_overall(1),centroids_overall(2),eig1_len*eig1_dir(1),eig1_len*eig1_dir(2))
quiver(centroids_overall(1),centroids_overall(2),eig2_len*eig2_dir(1),eig2_len*eig2_dir(2))
legend('class 1','class 2','class3','eig1','eig2')
