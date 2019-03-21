clear; close all; clc;

group1=[10,16,27,15,21,14,16,21,22,23,25,28,27,13,15,16,21,22,25,28];
group2=[23,26,27,23,16,18,31,33,28,36,18,21,26,28,29,33,32,16,18,23];

m1=mean(group1);
m2=mean(group2);
s1=std(group1);
s2=std(group2);
sp=sqrt(1/2*(s1^2+s2^2));
n1=length(group1);
n2=length(group2);

t=(m1-m2)/sqrt((sp^2/n1+sp^2/n2))


