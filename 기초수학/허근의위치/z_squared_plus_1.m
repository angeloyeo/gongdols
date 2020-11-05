clear; close all; clc;

%% real space
x=linspace(-2,2,30);
y=x.^2+1;

plot(x,y,'k');
hold on;
line([-2 2],[0 0],'linestyle','-.')
line([0 0],[-1 5],'linestyle','-.')
ylim([-1 5])
title('y=x^2+1')

%% complex plane

ang=0:0.01:2*pi; 
xp=cos(ang);
yp=sin(ang);
figure;plot(xp,yp);
axis square
xlim([-1.5 1.5])
ylim([-1.5 1.5])
xlabel('Real Axis');
ylabel('Imaginary Axis');
x_points =[1.0627, 0.0394, -1.15, 0.0481];
y_points =[-0.0787,1.1, -0.0787, -1.1];
text(x_points(1),y_points(1),'1');
text(x_points(2),y_points(2),'i');
text(x_points(3),y_points(3),'-1');
text(x_points(4),y_points(4),'-i');
title('complex plane')

h1 = annotation('arrow');  % store the arrow information in ha
h1.Parent = gca;           % associate the arrow the the current axes
h1.X = [0 0];          % the location in data units
h1.Y = [0 1.5];

h2 = annotation('arrow');  % store the arrow information in ha
h2.Parent = gca;           % associate the arrow the the current axes
h2.X = [0 0];          % the location in data units
h2.Y = [0 -1.5];


h3 = annotation('arrow');  % store the arrow information in ha
h3.Parent = gca;           % associate the arrow the the current axes
h3.X = [0 1.5];          % the location in data units
h3.Y = [0 0];

h4 = annotation('arrow');  % store the arrow information in ha
h4.Parent = gca;           % associate the arrow the the current axes
h4.X = [0 -1.5];          % the location in data units
h4.Y = [0 0];

%% complex space

real_axis=linspace(-2,2,30);
imag_axis=linspace(-2,2,30);

fz= zeros(length(real_axis),length(imag_axis));
for iter_r=1:length(real_axis)
    for iter_i=1:length(imag_axis)
        z=real_axis(iter_r)+1j*imag_axis(iter_i);
        fz(iter_r,iter_i)=z.^2+1;
    end
end
figure;
surf(real_axis,imag_axis,abs(fz'),angle(fz'));
xlabel('Real(f(z))');
ylabel('Imag(f(z))');
zlabel('Mag(f(z))');
% h = colorbar;
% ylabel(h, 'Phase(f(z))')
hold on

plot3(real_axis,zeros(size(real_axis)),[real_axis.^2+1],'r','linewidth',5)