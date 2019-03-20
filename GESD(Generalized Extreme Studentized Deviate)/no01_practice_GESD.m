clear; close all; clc;
addpath('C:\Users\biosensor1\Google 드라이브\여동훈_개인공부정리파일\프로그래밍_코드모음\아이센스\my_functions\');
% 출처: https://www.astm.org/standardization-news/images/nd15/nd15_datapoints.pdf

%% Grubb's test
% Example 1)
data = [5.3 3.1 4.9 3.9 7.8 4.7 4.3];
stem(data) % 여기서 5번째 데이터 7.8이 outlier로 볼 수도 있을듯?

xbar= mean(data);
xstd= std(data);

for i_data = 1:length(data)
    xtval(i_data) = abs(data(i_data)-xbar)/xstd;
end

idx_outlier = xtval>tinv(0.95,length(data)-1);

% Example 2) masking?
data = [5.3 3.1 4.9 3.9 7.8 4.7 4.3 8.0 4.5 5.1 3.5];
stem(data) % 5번, 8번 데이터 7.8과 8.0이 outlier로 볼 수 있다.

xbar = mean(data)
xstd = std(data)

for i_data = 1:length(data)
    xtval(i_data) = abs(data(i_data)-xbar)/xstd;
end

idx_outlier = xtval>tinv(0.95,length(data)-1)

idx_outlier_GECd = fun_GESD(data);

