clear; close all; clc;

%% 1. Create a CSV file to contain the data

my_mtx = [0,0; 3, 1.4; 6, 2.5; 9 3.1; 12 3.2; 15 1.7; 18 0];

writematrix(my_mtx, 'my_file.csv')

%%%%%%%%%%% 2. Produce a MATLAB script and functions to do the following %%%%%%%%%%%

%% a. Read the CSV file

A = xlsread('my_file.csv');

%% b. Plot the depth of the calanal along the cross-section
plot(my_mtx(:,1), my_mtx(:,2));
axis ij % this command will let the figure plot reverse the y-dir so that the graph can represent the "DEPTH" of canal.

%% c. Numerically estimate the average depth of the canal using different methods and implementations

%% i. Your own implementation ofh te trapezium method, using a loop to
% iterate over the measurement data

total_depth_trapz = 0;
x = my_mtx(:,1);
fx = my_mtx(:,2);   

for i = 1:length(x)-1
    total_depth_trapz = total_depth_trapz + (x(i+1)-x(i))*(fx(i+1)+fx(i))/2;
end
% ref: https://en.wikipedia.org/wiki/Trapezoidal_rule

%% ii. Your own implementation of the Simpson's Rule, using a loop to
% iterate over the measurement data

% coef of Simpson's rule
% ref: https://www.math24.net/simpsons-rule/#example1
coef = ones(1, length(x));
coef(2:2:end-1) = 4;
coef(3:2:end-2) = 2;

delta_x = x(2)-x(1);
total_depth_Simpson = 0;
for i = 1:length(x)
    total_depth_Simpson = total_depth_Simpson + delta_x/3*coef(i)*fx(i);
end

%% iii. Your own implementation of Simpson's rule, avoiding the use of a loop by using
% operations on vectors

total_depth_Simpson_vec = delta_x/3*(coef*fx); % vectorized summation using inner product

%% iv. MATLAB's built-in trapz() function
total_depth_MATLAB_trapz = trapz(x, fx);
