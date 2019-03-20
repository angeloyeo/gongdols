% 원본 출처: http://www2.math.umd.edu/~petersd/241/html/ex30.html

clear; close all; clc;

%% (1) Consider a 2D vector field in a circle
%{
    The vector field is F = ( -y*(1-x-y)+x/4, 2-x^2+y/4 ), 
    the region R consists of the points (x,y) with x^2+y^2<=1. 
    Let C be the boundary curve (counterclockwise). Find a parametrization of C. Plot the vector field together with C.
%}

syms x y z t real
Pi = sym('pi');
F = [ -y*(1-x-y)+x/4, 2-x^2+y/4 ];       % vector field F
vectorfield(F,-1:.2:1,-1:.2:1); hold on  % plot vector field
X = cos(t); Y = sin(t);                  % parametrization r=[X,Y] of curve
P = ezplot(X,Y,[0,2*pi]);                % plot curve
set(P,'Color','black','LineWidth',2)     % make curve black, thicker
hold off

%% (2a) Find the work integral W for the vector field F and the curve C.
Fr = subs(F,{x,y},{X,Y})                 % substitute curve parametrization in F
rp = diff([X,Y],t)                       % velocity vector
W = int(dot(Fr,rp),t,0,2*Pi)


%% (2b) Find the work integral W by using Green's theorem.
% Use polar coordinates. Make a plot of the vector field together with the 3rd curl component.

G = curl([F,0],[x y z])                 % need vector field of 3 components for curl
g = G(3)                                % 3rd component of curl

syms r theta real
X = r*cos(theta); Y = r*sin(theta);     % polar coordinates
gr = subs(g,{x,y},{X,Y})                % substitute polar coordinates for x,y in g
W2 = int(int(gr*r,r,0,1),theta,0,2*Pi)  % integrate gr*r*dr*dtheta
                                        % gives same result as (2a)!

vectorfield(F,-1:.2:1,-1:.2:1); hold on % plot vector field
P = ezplot(cos(t),sin(t),[0,2*pi]);     % plot curve
set(P,'Color','black','LineWidth',2)
ezpcolor(g,[-1.2 1.2 -1.2 1.2]); hold off % plot 3rd curl component
colorbar; colorposneg
title('colors show curl: blue is clockwise, red is counterclockwise')

%% (3a) Find the flux integral for the vector field F and the curve C.
X = cos(t); Y = sin(t);                 % parametrization r=[X,Y] of curve
Fr = subs(F,{x,y},{X,Y})                % substitute curve parametrization in F
Xp = diff(X,t); Yp = diff(Y,t);         % find X',Y'

I = int(dot(Fr,[Yp,-Xp]),t,0,2*Pi)      % integrate F(r(t))*[Y',-X'] (dot product)

%% (3b) Find the flux integral by using Green's theorem
g = divergence(F,[x y])                 % find the divergence of F
syms r theta real
X = r*cos(theta); Y = r*sin(theta);     % polar coordinates
gr = subs(g,{x,y},{X,Y})                % substitute polar coordinates for x,y in g
I2 = int(int(gr*r,r,0,1),theta,0,2*Pi)  % integrate gr*r*dr*dtheta
                                        % gives same result as (3a)!

vectorfield(F,-1:.2:1,-1:.2:1); hold on    % plot vector field F
P = ezplot(cos(t),sin(t),[0,2*pi]);        % plot the curve
set(P,'Color','black','LineWidth',2)
ezpcolor(g,[-1.2 1.2 -1.2 1.2]); hold off  % plot divergence
colorbar; colorposneg
title('colors show divergence: blue is sink, red is source')
