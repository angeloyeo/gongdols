% Filename: example6.m
% Description: m-file to plot trigonometric Fourier Series
% representation of an "odd" square wave and even triangle wave.

clear; clc; close all; % clear memory and command window, close all figures

t = -1.5:0.005:3.5; % times over which to plot FS

Nval = [1, 3, 5, 51]; % upper limits for n in summation
figure(1);
% Build square wave using increasing number of terms
for in = 1:length(Nval),
    v = 0;
    subplot(2,2,in);
    plot([-1.5, -1, -1,  0, 0, 1,  1,  2, 2, 3,  3, 3.5],...
          [1,    1, -1, -1, 1, 1, -1, -1, 1, 1, -1,  -1],'k--','LineWidth',1);
    hold on;
    for n = 1:2:Nval(in),
        addto = 4*sin(n*pi*t)/(n*pi);
        v     = v + addto;
        plot(t,addto,'b--','LineWidth',1);
    end
    plot(t,v,'r-','LineWidth',2);
    hold off;
    xlabel('time, sec','FontSize',14); ylabel('FS Approx to v(t)','FontSize',14);
    title(['Fourier Series Approx w/',num2str(Nval(in)),' Terms'],'FontSize',14);
end

Nval = [2, 4, 6, 50]; % upper limits for n in summation
figure(2);
% Build triangle wave using increasing number of terms
for in = 1:length(Nval),
    v = -1/2*ones(1,length(t));
    subplot(2,2,in);
    plot([-1.5, -1, 0, 1, 2,  3, 3.5],...
         [-0.5, -1, 0,-1, 0, -1,-0.5],'k--','LineWidth',1);
    hold on;
    plot(t,v,'b--','LineWidth',1);
    for n = 1:2:Nval(in),
        addto = 4*cos(n*pi*t)/(n*n*pi*pi);
        v     = v + addto;
        plot(t,addto,'b--','LineWidth',1);
    end
    plot(t,v,'r-','LineWidth',2);
    hold off;
    xlabel('time, sec','FontSize',14); ylabel('FS Approx to v(t)','FontSize',14);
    title(['Fourier Series Approx w/',num2str(Nval(in)),' Terms'],'FontSize',14);
end