% Eulerian Method
% Setup and initial conditions
h = 0.00025;  % step size
x = 0:h:5;  % interval of x
y = zeros(size(x));  % allocate the resulting y
ys = linspace(0.5, 1.5, 10);
close all;
figure;
for i_ys = 1:length(ys)
    y(1) = ys(i_ys);  % inizial value of y
    n = numel(y);  % the number of y values
    % The loop that solves the differential equation:
    for i=1:n-1
        f = (y(i)-2*sin(x(i)));
        y(i+1) = y(i) + h * f;
    end
    hold on
    plot(x, y, 'b', 'DisplayName', 'Euler method');
end
