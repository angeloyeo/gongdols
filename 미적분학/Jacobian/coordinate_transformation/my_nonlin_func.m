function [newX,newY,changeX, changeY] = my_nonlin_func(X,Y,varargin)

if nargin ==2
    whatyouneed = 4;
elseif nargin > 2
    whatyouneed = varargin{1};
end


if whatyouneed ==1
    newX = X+Y.^2; newY = Y+exp(X); % nonlin function 2 ¶Õ°í ¿Ã¶ó°¡´Â ´À³¦?
    
    
elseif whatyouneed == 2
    newX =X.*cos(Y); newY = X.*sin(Y); % nonlin function 4 cartesian to polar coordinate
elseif strcmp(whatyouneed,'polar')
    newX =X.*cos(Y); newY = X.*sin(Y); % nonlin function 4 cartesian to polar coordinate
    
    
elseif whatyouneed == 3
    newX =X.^2-Y.^2; newY = 2*X.*Y; % nonlin function 5
    

elseif strcmp(whatyouneed,'basic')
    newX = X+sin(Y/2); newY = Y+sin(X/2); % nonlin function 1 ±×³ª¸¶ Á» ³´´Ù...
else
    newX = X+sin(Y/2); newY = Y+sin(X/2); % nonlin function 1 ±×³ª¸¶ Á» ³´´Ù...
end

%
changeX = newX-X;
changeY = newY-Y;

end