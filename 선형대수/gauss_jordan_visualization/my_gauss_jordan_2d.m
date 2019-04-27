clear; close all; clc;

%% 2D case

A = [2 1; 4 3];
b = [2,3]';

xy_ans = A\b;

x = linspace(-5,5);
y1 = (-A(1,1)*x+b(1))/A(1,2);
y2 = (-A(2,1)*x+b(2))/A(2,2);

plot(x,y1);
hold on;
plot(x,y2);
plot(xy_ans(1,1), xy_ans(2,1),'r.','markersize',20)
grid on;


%% Gauss Jordan Elimination
% augmented matrix Ab
Ab = [A b];

% step 1) scaling row 1
Ab1=Ab;
Ab1(1,:)=Ab1(1,:)/Ab1(1,1);


% step 2) subtract row 2 from row 1
Ab2 = Ab1;
Ab2(2,:) = Ab2(2,:)-Ab2(1,:)*Ab(2,1);


% step 3) scaling row 2
Ab3 = Ab2;
Ab3(2,:) = Ab3(2,:)/Ab3(2,2);


% step 4) subtract row 1 from row 2
Ab4 = Ab3;
Ab4(1,:) = Ab4(1,:)-Ab4(2,:)*Ab4(1,2);


%% animation
close all;

XLIMs = get(gca,'xlim');
YLIMs = get(gca,'ylim');
% step 1) Ab -> Ab1
disp('step 1) scaling row 1');
gj_2d_ani(Ab,Ab1,x,xy_ans)
disp('press any key to continue');
pause;

% step 2) Ab1-> Ab2
disp('step 2) subtract row 2 from row 1');
gj_2d_ani(Ab1, Ab2, x, xy_ans)
disp('press any key to continue');
pause;

% step 3) Ab2-> Ab3
disp('step 3) scaling row 2');
gj_2d_ani(Ab2, Ab3, x, xy_ans)
disp('press any key to continue');
pause;

% step 4) Ab3 -> Ab4
disp('step 4) subtract row 1 from row 2');
gj_2d_ani(Ab3, Ab4, x, xy_ans)
disp('press any key to continue');
pause;
