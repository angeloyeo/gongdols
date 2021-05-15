clear; close all; clc;

disp('Hello there!');

a = 1;
b = 2;

c = a * b + 3;

for i = 1:5
    disp(['Hi. The iteration number is: ',num2str(i)]);
end

disp(c)