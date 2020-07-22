clear all; close all; clc;

addpath(genpath('./'))

fs=10000;

t=0:1/fs:0.3-1/fs;

sigA=sin(2*pi*100*t);
sigB=sin(2*pi*13*t-pi/3);
sigC=sin(2*pi*500*t);

%% 원래 신호 
figure; 

subplot(311)
plot(sigA);
subplot(312)
plot(sigB);
subplot(313)
plot(sigC);

sigSum1=0.8*sigA+0.4*sigB+0.1*sigC;
sigSum2=0.9*sigB+0.1*sigC+0.1*sigA;
sigSum3=0.78*sigC+0.2*sigB+0.1*sigA;

sigSum=[sigSum1; sigSum2; sigSum3];

%% 합쳐진 신호
figure; 

subplot(311)
plot(sigSum(1,:));
subplot(312)
plot(sigSum(2,:));
subplot(313)
plot(sigSum(3,:));


%% ICA로 복원한 신호
% fastica는 아래의 웹페이지에서 받을 수 있음.
% https://research.ics.aalto.fi/ica/fastica/code/dlcode.shtml

figure;
[icasig]=fastica(sigSum,'numOfIC',3, 'displayMode', 'signals');
% 
% subplot(311)
% plot(icasig(1,:));
% subplot(312)
% plot(icasig(2,:));
% subplot(313)
% plot(icasig(3,:));
