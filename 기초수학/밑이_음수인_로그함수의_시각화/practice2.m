% --------------- 마찬가지로 재미가 없다. ------------------------- %

clear; close all; clc;

% y = log(x) for x<0

%%
x = linspace(-10,-eps,100);
y = log(x);

plot(x,real(y))
hold on;
plot(x,imag(y))


figure;
my_color = jet(length(x));
scatter(real(y), imag(y),10,my_color);
% xlim([min(real(y)) max(real(y))])
% ylim([min(imag(y)), max(imag(y))])
cbar = colorbar;
colormap(my_color)