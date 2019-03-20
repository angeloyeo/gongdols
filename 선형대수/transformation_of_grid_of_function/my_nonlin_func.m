function [newX,newY,changeX, changeY] = my_nonlin_func(X,Y)

% newX = X+sin(Y); newY = Y+sin(X); % nonlin function 1
% newX = X+Y.^2; newY = Y+exp(X); % nonlin function 2
newX =X.*Y; newY = X.*log(Y); % nonlin function 3

changeX = newX-X;
changeY = newY-Y;

end