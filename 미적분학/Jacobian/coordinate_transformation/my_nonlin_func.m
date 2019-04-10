function [newX,newY,changeX, changeY] = my_nonlin_func(X,Y)

% newX = X+sin(Y/2); newY = Y+sin(X/2); % nonlin function 1 ±×³ª¸¶ Á» ³´´Ù...
% newX = X+Y.^2; newY = Y+exp(X); % nonlin function 2 ¶Õ°í ¿Ã¶ó°¡´Â ´À³¦?
% newX =X.*cos(Y); newY = X.*sin(Y); % nonlin function 3 cartesian to polar coordinate
newX =X.^2-Y.^2; newY = 2*X.*Y; % nonlin function 4
% 
changeX = newX-X;
changeY = newY-Y;

end