clear all; close all; clc;

load fisheriris

xdata = meas(51:end,3:4);
group = species(51:end);
figure;
svmStruct = svmtrain(xdata,group,'kernel_function','rbf','rbf_sigma',0.1,'ShowPlot',true);