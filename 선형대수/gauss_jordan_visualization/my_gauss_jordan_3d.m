clear; close all; clc;

A = [2 1 -2; 3 -2 4; -4 4 5];
b = [2 4 1]';

xyz_ans = A\b;

[x,y] = meshgrid(-5:5);
sizex = [size(x)];
zs = zeros(3,sizex(1), sizex(2));

for i =1:3 % 총 세 개의 면을 그리겠음.
    zs(1,:,:) = (b(1)-A(1,1)*x-A(1,2)*y)/(A(1,3)+eps);
    zs(2,:,:) = (b(2)-A(2,1)*x-A(2,2)*y)/(A(2,3)+eps);
    zs(3,:,:) = (b(3)-A(3,1)*x-A(3,2)*y)/(A(3,3)+eps);
end

surf(x,y,squeeze(zs(1,:,:)),'facecolor',[255 102 102]/255,'edgecolor','k')
hold on;
surf(x,y,squeeze(zs(2,:,:)),'facecolor',[51 204 51]/255,'edgecolor','k')
surf(x,y,squeeze(zs(3,:,:)),'facecolor',[102 204 255]/255,'edgecolor','k')
plot3(xyz_ans(1),xyz_ans(2),xyz_ans(3),'r.','markersize',50)
xlim([-15 15])
ylim([-15 15])
zlim([-15 15])
xlabel('x'); ylabel('y'); zlabel('z')
view(3)
% intersections
for i = 1:3
    zdiff = squeeze(zs(i,:,:) - zs(rem(i,3)+1,:,:));
    C = contours(x, y, zdiff, [0 0]);
    % Extract the x- and y-locations from the contour matrix C.
    xL = C(1, 2:end);
    yL = C(2, 2:end);
    % Interpolate on the first surface to find z-locations for the intersection
    % line.
    zL = interp2(x, y, squeeze(zs(i,:,:)), xL, yL);
    % Visualize the line.
    line(xL, yL, zL, 'Color', 'k', 'LineWidth', 3);
end

%% Gauss Jordan Elimination

Ab = [A b];

% step 1) scaling row 1
Ab1 = Ab;
Ab1(1,:) = Ab1(1,:)/Ab1(1,1);

% step 2) subtract row 2 from row 1
Ab2 = Ab1;
Ab2(2,:) = Ab2(2,:)-Ab2(1,:)*Ab2(2,1);

% step 3) subtract row 3 from row 1
Ab3 = Ab2;
Ab3(3,:) = Ab3(3,:)-Ab3(1,:)*Ab3(3,1);

% step 4) scaling row 2
Ab4 = Ab3;
Ab4(2,:) = Ab4(2,:)/Ab4(2,2);

% step 5) subtract row 3 from row 2
Ab5 = Ab4;
Ab5(3,:) = Ab5(3,:)-Ab5(2,:)*Ab5(3,2);

% step 6) scale row 3
Ab6 = Ab5;
Ab6(3,:) = Ab6(3,:)/Ab6(3,3);

% step 7) subtract row 2 from row 3
Ab7 = Ab6;
Ab7(2,:) = Ab7(2,:)-Ab7(3,:)*Ab7(2,3);

% step 8) subtract row 1 from row 2
Ab8 = Ab7;
Ab8(1,:) = Ab8(1,:)-Ab8(2,:)*Ab8(1,2);

% step 9) subtract row 1 from row 3
Ab9 = Ab8;
Ab9(1,:) = Ab9(1,:)-Ab9(3,:)*Ab9(1,3);

%% animation
close all;
figure;
axis; view(3)
% step 1) scaling row 1
gj_3d_ani(Ab, Ab1, x, y, xyz_ans)

% step 2) subtract row 2 from row 1
gj_3d_ani(Ab1, Ab2, x, y, xyz_ans)

% step 3) subtract row 3 from row 1
gj_3d_ani(Ab2, Ab3, x, y, xyz_ans)

% step 4) scaling row 2
gj_3d_ani(Ab3, Ab4, x, y, xyz_ans)

% step 5) subtract row 3 from row 2
gj_3d_ani(Ab4, Ab5, x, y, xyz_ans)

% step 6) scale row 3
gj_3d_ani(Ab5, Ab6, x, y, xyz_ans)

% step 7) subtract row 2 from row 3
gj_3d_ani(Ab6, Ab7, x, y, xyz_ans)

% step 8) subtract row 1 from row 2
gj_3d_ani(Ab7, Ab8, x, y, xyz_ans)

% step 9) subtract row 1 from row 3
gj_3d_ani(Ab8, Ab9, x, y, xyz_ans)