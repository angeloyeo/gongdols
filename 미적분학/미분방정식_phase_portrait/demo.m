clear; close all; clc;

f = @(t,Y) [Y(2); -sin(Y(1))];

y1 = linspace(-2, 8, 20);
y2 = linspace(-2, 2, 20);

[x,y] = meshgrid(y1,y2);
size(x)
size(y)

u = zeros(size(x));
v = zeros(size(x));

% we can use a single loop over each element to compute the derivatives at
% each point (y1, y2)
t=0; % we want the derivatives at each point at t=0, i.e. the starting time
for i = 1:numel(x)
    Yprime = f(t,[x(i); y(i)]);
    u(i) = Yprime(1);
    v(i) = Yprime(2);
end

quiver(x,y,u,v,'r'); figure(gcf)
xlabel('y_1')
ylabel('y_2')
axis tight equal;

hold on

for y20 = [0 0.5 1 1.5 2 2.5]
    [ts,ys] = ode45(f,[0,50],[0;y20]);
    plot(ys(:,1),ys(:,2),'b')
    plot(ys(1,1),ys(1,2),'bo') % starting point
    plot(ys(end,1),ys(end,2),'ks') % ending point
end
hold off
xlim([-2, 8])
