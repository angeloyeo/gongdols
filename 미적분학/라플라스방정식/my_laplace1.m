clear; close all; clc;

% create a blank scalar field
T = nan(5,5);
T(1,2:end-1)=0;
T(end,2:end-1) = 100;
T(2:end-1,1) = 50;
T(2:end-1,end) = 75;

% create A and b matrix

B = [-4 1 0; 1 -4 1; 0 1 -4];
A1 = blkdiag(B,B,B);
R = A1(1,:)*0; R(4) = 1;

A2 = toeplitz(R,R);
A = A1+A2;

b = [-75 0 -50 -75 0 -50 -175 -100 -150]';

p = pinv(A'*A)*A*b;

% assign field values
T(2, 2:end-1) = p(1:3);
T(3, 2:end-1) = p(4:6);
T(4, 2:end-1) = p(7:9);

mesh(T);