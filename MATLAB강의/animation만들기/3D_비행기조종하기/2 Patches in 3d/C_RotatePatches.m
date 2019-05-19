%{ 
C_RotatePatches.m

Show how patch objects can be rotated using rotation matrices. Note that
it's much better to alter a patch object than to create a new one each time
a change occurs.

Matt Sheen, mws262@cornell.edu
%}

close all; clear all;
fig = figure;

%% Same code as C_CompoundPatch.m
%Compound Patch - columns are individual patches
pX = [-1 1 0; 
    0 0 0]';
pY = [-1/3 -1/3 2/3;
    -1/3 -1/3 2/3]';
pZ = [0 0 0;
    0 0.5 0]';

p1 = patch(pX,pY,pZ,'red');
p1.FaceAlpha = 0.5;

axis([-2 2 -2 2 -2 2])
view(3)


%% Rotate it:

%Keep track of the original vertices if you want rotations to be relative
%to the initial orientation
OrigVerts = p1.Vertices;

rot = angle2dcm(pi/2,0,0); %Create a rotation matrix from euler angles --- NOT the way you'll be doing it, but easy for this example.

p1.Vertices = (rot*OrigVerts')'; %Now, reasign the vertices to be the newly rotated ones.


%Put it in an animation loop:
totrot = eye(3,3);

%Rotate about one plane axis:
rot = angle2dcm(0.1,0,0);

for i = 1:25
    totrot = totrot*rot; % -- this applies the new rotation in the original plane axis
%     totrot = rot*totrot; %-- this applies the new rotation in the new
%     axis.
    p1.Vertices = (totrot*OrigVerts')';

    pause(0.1);
end


%Another axis:
rot = angle2dcm(0,0.1,0);

for i = 1:25
    totrot = totrot*rot;
%     totrot = rot*totrot;
    p1.Vertices = (totrot*OrigVerts')';

    pause(0.1);
end


%Another axis
rot = angle2dcm(0,0,0.1);

for i = 1:25
    totrot = totrot*rot;
%     totrot = rot*totrot;
    p1.Vertices = (totrot*OrigVerts')';

    pause(0.1);
end


