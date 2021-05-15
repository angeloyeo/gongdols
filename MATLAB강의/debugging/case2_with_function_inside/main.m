clear; close all; clc;

disp('Hello there!');

a = 1;
b = 2;

cc = my_addition(a, b);


for i = 1:5
    disp(['Hi. The iteration number is: ',num2str(i)]);
end

disp(cc)

function  c = my_addition(a, b)

c = a + b;
end
