%{ 
A_SimplePatch.m

This shows how to create a simple patch object (a triangle in this case) by
specifying the vertices.

Matt Sheen, mws262@cornell.edu
%}

close all; clear all;
fig = figure;

%Simple Patch
pX = [-1 1 0]';
pY = [-1/3 -1/3 2/3]';
pZ = [0 0 0]';

p1 = patch(pX,pY,pZ,'red'); %Make the patch object
p1.FaceAlpha = 0.5; % A little transparent for easier viewing.

axis equal
view(3)