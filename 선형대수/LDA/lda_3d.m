%%
clc;
clear all;
close all;

%% make 3d data

c1count = 100;
c1mean  = [10 4 1];
c1var   = 2;
c1 = [c1mean(1)+c1var*randn(c1count,1) c1mean(2)+c1var*randn(c1count,1) c1mean(3)+c1var*randn(c1count,1)];

c2count = 152;
c2mean  = [2 10 5];
c2var   = 3;
c2 = [c2mean(1)+c2var*randn(c2count,1) c2mean(2)+c2var*randn(c2count,1) c2mean(3)+c2var*randn(c2count,1)];

c3count = 112;
c3mean  = [3 1 10];
c3var   = 3;
c3 = [c3mean(1)+c3var*randn(c3count,1) c3mean(2)+c3var*randn(c3count,1) c3mean(3)+c3var*randn(c3count,1)];

%% do LDA with 3-d
% Number of observations of each class
n1      = size(c1,1);
n2      = size(c2,1);
n3      = size(c3,1);

%Mean of each class
mu1     = mean(c1);
mu2     = mean(c2);
mu3     = mean(c3);

% Average of the mean of all classes
mu      = (mu1+mu2+mu3)/3;

% Center the data (make it mean zero)
d1      = c1 - repmat(mu1, n1, 1);
d2      = c2 - repmat(mu2, n2, 1);
d3      = c3 - repmat(mu3, n3, 1);

% Calculate the within class variance (SW)
s1      = d1'*d1;
s2      = d2'*d2;
s3      = d3'*d3;
sw      = s1 + s2 + s2;

% if more than 2 classes calculate between class variance (SB)
sb1     = n1*(mu1-mu)'*(mu1-mu);
sb2     = n2*(mu2-mu)'*(mu2-mu);
sb3     = n3*(mu3-mu)'*(mu3-mu);
SB      = sb1+sb2+sb2;
%%% 1. old method
%invsw   = inv(sw);
%v       = invsw*SB;
%%% 2. better method
v       = sw \ SB;

% find eigen values and eigen vectors of the (v)
[evec, eval] = eig(v);
[eval order] = sort(diag(eval),'descend');  %# sort eigenvalues in descending order

% Sort eigen vectors according to eigen values (descending order)
evec = evec(:,order);

% chose v by the size of eigen value(ex, negelect some eigne vectors if the corresponding eigen value is sufficiently small,
%v       = evec(greater eigen value)

%% plot LDA result, 3d, 2d, 1d respectively 

figure(1);
plot3( c1(:,1), c1(:,2), c1(:,3), 'ro' );
hold on;
plot3( c2(:,1), c2(:,2), c2(:,3), 'bo' );
plot3( c3(:,1), c3(:,2), c3(:,3), 'go' );
hold off;
legend('class1', 'class2', 'class3');
title('LDA Dataset');
grid on
axis square
%axis ([0 10 0 10 0 10 ]);

figure(2);
v2      = v(:, 1:3);
y1      = c1*v2;
y2      = c2*v2;
y3      = c3*v2;
plot3( y1(:,1), y1(:,2), y1(:,3), 'ro' );
hold on; plot3( y2(:,1), y2(:,2), y2(:,3), 'bo' );
plot3( y3(:,1), y3(:,2), y3(:,3), 'go' ); hold off;
title('3d LDA Result');
grid on
axis square
%axis ([0 10 0 10 0 10 ]);
legend('class1', 'class2', 'class3');

figure(3);
v3      = v(:, 2:3);
y1      = c1*v3;
y2      = c2*v3;
y3      = c3*v3;
plot( y1(:,1), y1(:,2), 'ro' );
hold on; plot( y2(:,1), y2(:,2), 'bo' );
plot( y3(:,1), y3(:,2), 'go' );  hold off;
title('3d -> 2d LDA Result');
grid on
axis square
legend('class1', 'class2', 'class3');

figure(4);

v4      = v(:, 3:3);
y1      = c1*v4;
y2      = c2*v4;
y3      = c3*v4;
plot(y1(:,1), 0,'ro','MarkerSize',10);  %# Plot data set 1
hold on;
plot(y2(:,1), 0,'bo','MarkerSize',10);  %# Plot data set 2
plot(y3(:,1), 0,'go','MarkerSize',10);  %# Plot data set 2
hold off;
title('3d -> 1d LDA Result');
legend('class1', 'class2', 'class3');