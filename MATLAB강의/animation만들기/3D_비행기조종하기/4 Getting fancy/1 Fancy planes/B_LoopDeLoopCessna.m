%{ 
B_LoopDeLoopCessna.m

This simply shows how the imported cessna patch object in A can be plugged directly into
the loop-de-loop example with no particular complications.

Matt Sheen, mws262@cornell.edu
%}

close all; clear all;
fig = figure;

%% Make the patch object:
patchData = stlread('cessna.stl');

p1 = patch(patchData,'EdgeColor','none','FaceColor','[0.8 0.8 1.0]','FaceAlpha',0.9);

axis equal
material('metal')
camlight('headlight');

p1.FaceAlpha = 0.5;

OrigVerts = p1.Vertices;

fig.Children.Clipping = 'off'; %Still see the plane when it leaves the axis area.
axis(2*[-30 30 -30 30 -10 50])
view(3)

%% Do the loop example.
vel = 5*[-1 0 0];
rot = angle2dcm(0,-0.04,0);
dt = 0.5;
center = [0 0 0];

totalRot = eye(3,3);

for i = 1:1000
    totalRot = totalRot*rot;
    center = dt*(totalRot*vel')' + center; %transform the velocity, keep track of the center position.
    p1.Vertices = (totalRot*OrigVerts')' + repmat(center,[size(OrigVerts,1),1]); %Rotate the patch object about its center and add new center point.
   
    pause(0.01); 
end