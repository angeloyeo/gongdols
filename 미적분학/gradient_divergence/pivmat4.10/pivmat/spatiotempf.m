function [st,X,Y] = spatiotempf(f,X,Y)
%SPATIOTEMPF   Spatio-temporal diagram
%   ST = SPATIOTEMPF(F, X, Y), where F is an array of scalar fields,
%   returns a spatio-temporal matrix ST(M,N), in which each line M is given
%   by the value of F(M) taken along the line(s) joining the points X,Y, 
%   specified in physical units (eg., in mm). To specify a single line
%   from (x0,y0) to (x1,y1), use X = [x0,x1], Y = [y0,y1].
%
%   ST = SPATIOTEMPF(F) allows the user to select lines using the mouse
%   (double-click to finish line selection).
%   [ST,X,Y] also returns the selected lines.
%
%   The value of the field along the lines is interpolated using Matlab's
%   function INTERP2.
%
%   See also PROBEF, MATRIXCOORDF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.00,  Date: 2017/01/31
%   This function is part of the PIVMat Toolbox


% History:
% 2017/01/31: v1.00, first version


if nargin==1
    disp('Select lines. Double-click when finished.');
    [X,Y] = getline;    
    disp(['Selected lines: X=[' num2str(X') '], Y=[' num2str(Y') ']']);
    hold on
    plot(X,Y);
    hold off
end

xp = []; yp = [];
for i=1:(length(X)-1)
    len = sqrt( (X(i+1)-X(i))^2 + (Y(i+1)-Y(i))^2 );  
    Np = ceil(len/abs(f(1).x(2)-f(1).x(1)));
    xp = [xp linspace(X(i), X(i+1), Np)];
    yp = [yp linspace(Y(i), Y(i+1), Np)];
end

for i = 1:numel(f)
    st(i,:) = interp2(f(i).x, f(i).y, f(i).w', xp, yp);
end
