%{ 
B_CompoundPatch.m

Create a multi-faced patch (sort of paper airplane-ish). 

Matt Sheen, mws262@cornell.edu
%}

close all; clear all;
fig = figure;

%Compound Patch - columns are individual patches, rows are vertices of that
%patch
pX = [-1 1 0; 
    0 0 0]';
pY = [-1/3 -1/3 2/3;
    -1/3 -1/3 2/3]';
pZ = [0 0 0;
    0 0.5 0]';

p1 = patch(pX,pY,pZ,'red');
p1.FaceAlpha = 0.5;

axis equal
view(3)