clear; close all; clc;

% 아래의 위키피디아 예제에서부터 가져온 데이터임
% https://en.wikipedia.org/wiki/Naive_Bayes_classifier
% 또, 코드의 진행 방식은 아래의 페이지를 참고하였음.
% https://chrisalbon.com/machine_learning/naive_bayes/naive_bayes_classifier_from_scratch/

data = struct('gender',[],'height',[],'weight',[],'footsize',[]);
data.gender = {'male','male','male','male','female','female','female','female'};
data.height = [6,5.92,5.58,5.92,5,5.5,5.42,5.75] * 30.48; % feet to cm
data.weight = [180,190,170,165,100,150,130,150] * 0.453592; % lbs to kg
data.footsize = [12,11,12,10,6,8,7,9] * 25.4; % inch to mm
    
person = struct('gender',[],'height',[],'weight',[],'footsize',[]);
person.height = 6 * 30.48;
person.weight = 130 * 0.453592;
person.footsize = 8 * 25.4;

%% 데이터로부터 prior 계산

n_male = sum(strcmp(data.gender,'male'));
n_female = sum(strcmp(data.gender,'female'));

total_ppl = length(data.gender);

P_male = n_male / total_ppl;
P_female = n_female / total_ppl;

%% Likelihood 계산을 위한 parameter 계산

idx_male = strcmp(data.gender,'male');

% means for male
male_height_mean = mean(data.height(idx_male));
male_weight_mean = mean(data.weight(idx_male));
male_footsize_mean = mean(data.footsize(idx_male));

% variance for male
male_height_var = var(data.height(idx_male));
male_weight_var = var(data.weight(idx_male));
male_footsize_var = var(data.footsize(idx_male));


idx_female = strcmp(data.gender,'female');

% means for male
female_height_mean = mean(data.height(idx_female));
female_weight_mean = mean(data.weight(idx_female));
female_footsize_mean = mean(data.footsize(idx_female));

% variance for male
female_height_var = var(data.height(idx_female));
female_weight_var = var(data.weight(idx_female));
female_footsize_var = var(data.footsize(idx_female));

%% 시각화

gaussian = @(x, mu, var) 1/sqrt(2*pi*var).*exp(-(x-mu).^2/(2*var)); % 가우스분포 함수
my_color = lines(2);

%%%%%%%%% height %%%%%%%%%
% height for male
male_height_mtx = [male_height_mean + 5 * sqrt(male_height_var), ...
    male_height_mean - 5 * sqrt(male_height_var)];
male_height_xx = linspace(min(male_height_mtx), max(male_height_mtx), 100);
male_height_yy = gaussian(male_height_xx, male_height_mean, male_height_var);


% height for female
female_height_mtx = [female_height_mean + 5 * sqrt(female_height_var), ...
    female_height_mean - 5 * sqrt(female_height_var)];
female_height_xx = linspace(min(female_height_mtx), max(female_height_mtx), 100);
female_height_yy = gaussian(female_height_xx, female_height_mean, female_height_var);

figure
h1 = plot(male_height_xx,male_height_yy,'linewidth',2,'color',my_color(1,:));
hold on;
h2 = plot(female_height_xx,female_height_yy,'linewidth',2,'color',my_color(2,:));
legend([h1, h2], '남자 키', '여자 키')
xlabel('키 (cm)');
ylabel('probability density');
grid on;


%%%%%%%%% weight %%%%%%%%%
% weight for male
male_weight_mtx = [male_weight_mean + 5 * sqrt(male_weight_var), ...
    male_weight_mean - 5 * sqrt(male_weight_var)];
male_weight_xx = linspace(min(male_weight_mtx), max(male_weight_mtx), 100);
male_weight_yy = gaussian(male_weight_xx, male_weight_mean, male_weight_var);

% weight for female
female_weight_mtx = [female_weight_mean + 5 * sqrt(female_weight_var), ...
    female_weight_mean - 5 * sqrt(female_weight_var)];
female_weight_xx = linspace(min(female_weight_mtx), max(female_weight_mtx), 100);
female_weight_yy = gaussian(female_weight_xx, female_weight_mean, female_weight_var);

figure
h1 = plot(male_weight_xx,male_weight_yy,'linewidth',2,'color',my_color(1,:));
hold on;
h2 = plot(female_weight_xx,female_weight_yy,'linewidth',2,'color',my_color(2,:));
legend([h1, h2], '남자 몸무게', '여자 몸무게')
xlabel('몸무게 (kg)');
ylabel('probability density');
grid on;


%%%%%%%%% footsize %%%%%%%%%
% footsize for male
male_footsize_mtx = [male_footsize_mean + 5 * sqrt(male_footsize_var), ...
    male_footsize_mean - 5 * sqrt(male_footsize_var)];
male_footsize_xx = linspace(min(male_footsize_mtx), max(male_footsize_mtx), 100);
male_footsize_yy = gaussian(male_footsize_xx, male_footsize_mean, male_footsize_var);

% footsize for female
female_footsize_mtx = [female_footsize_mean + 5 * sqrt(female_footsize_var), ...
    female_footsize_mean - 5 * sqrt(female_footsize_var)];
female_footsize_xx = linspace(min(female_footsize_mtx), max(female_footsize_mtx), 100);
female_footsize_yy = gaussian(female_footsize_xx, female_footsize_mean, female_footsize_var);

figure
h1 = plot(male_footsize_xx,male_footsize_yy,'linewidth',2,'color',my_color(1,:));
hold on;
h2 = plot(female_footsize_xx,female_footsize_yy,'linewidth',2,'color',my_color(2,:));
legend([h1, h2], '남자 발사이즈', '여자 발사이즈')
xlabel('발사이즈 (mm)');
ylabel('probability density');
grid on;


%% 새로운 데이터 포인트에 대해서 posterior 계산

p_x_given_y = @(x, mean_y, variance_y) 1/sqrt(2*pi*variance_y) * exp(-(x-mean_y)^2/(2*variance_y)); % 조건부확률 함수

posterior_male = P_male * p_x_given_y(person.height, male_height_mean, male_height_var) * ...
    p_x_given_y(person.weight, male_weight_mean, male_weight_var) * ...
    p_x_given_y(person.footsize, male_footsize_mean, male_footsize_var);

posterior_female = P_female * p_x_given_y(person.height, female_height_mean, female_height_var) * ...
    p_x_given_y(person.weight, female_weight_mean, female_weight_var) * ...
    p_x_given_y(person.footsize, female_footsize_mean, female_footsize_var);

if posterior_male > posterior_female
    disp('이 사람은 남자입니다');
else
    disp('이 사람은 여자입니다');
end



