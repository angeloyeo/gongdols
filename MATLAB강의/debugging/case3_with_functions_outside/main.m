clear; close all; clc;

disp('Hello there!');

a = 1;
b = 2;

cc = my_addition(a, b);

for i = 1:5
    disp(['Hi. The iteration number is: ',num2str(i)]);
end

ii=1;
while(1)
    disp('aaaa');
    if ii == 5
        break;
    end
    ii=ii+1;
end

disp(cc)

