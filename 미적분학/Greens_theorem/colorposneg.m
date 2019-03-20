function colorposneg
% colorposneg
% Use colormap which shows negative values green & blue, positive values yellow & red, zero white
caxis('auto');
C = caxis;
C2 = max(C(2),0);
C1 = min(C(1),0);
R = max(-C1,C2);
caxis([-R,R])
q = (C2-C1)/(2*R);
colormap(posneg(round(100/q)))

%%%%%%%%
function J = posneg(m)
%     colormap similar to jet, but with white instead of green in the center
if nargin < 1
   m = size(get(gcf,'colormap'),1);
end
x = linspace(-2.5,2.5,m)';        % consider x in [-2.5,2.5]
f = @(x) max(0,min(1,2-abs(x)));  % function for green
J = [f(x-1),f(x),f(x+1)];

