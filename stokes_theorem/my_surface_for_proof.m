clear; close all; clc;

[x,y] = meshgrid(linspace(-3,3,1000));

z1 = 5-x.^2-y.^2+10;
z2 = 11-x-y;

figure;
surf(x,y,z1,'FaceColor', [0.5 1.0 0.5],'EdgeColor','none');
hold on;
surf(x,y,z2,'FaceColor', [1 0.5 0.5],'EdgeColor','none');
view([49.2200, 21.0400]); camlight; axis vis3d
xlabel('x'); ylabel('y'); zlabel('z');
% Take the difference between the two surface heights and find the contour
% where that surface is zero.
zdiff = z1 - z2;
C = contours(x, y, zdiff, [0 0]);
% Extract the x- and y-locations from the contour matrix C.
xL = C(1, 2:end);
yL = C(2, 2:end);
% Interpolate on the first surface to find z-locations for the intersection
% line.
zL = interp2(x, y, z1, xL, yL);
% Visualize the line.
figure;

line(xL, yL, zL, 'Color', 'k', 'LineWidth', 3);
hold on;
line(xL, yL, 'color','k','linewidth',2,'linestyle','-.');


my_ROI = ((x-1/2).^2+(y-1/2).^2)<9/2;


x(~my_ROI)=NaN;
y(~my_ROI)=NaN;
surf(x,y,z1,'FaceColor', [0.5 1.0 0.5], 'EdgeColor', 'none')
view([49.2200, 21.0400]); camlight; axis vis3d

grid on
xlabel('x'); ylabel('y'); zlabel('z')
title('z_1>z_2 where z_1 = 15-x^2-y^2, z_2 = 11-x-y')