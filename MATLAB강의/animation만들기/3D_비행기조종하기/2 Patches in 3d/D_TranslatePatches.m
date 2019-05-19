%{ 
D_TranslatePatches.m

Show how patch objects can be translated in space. In this example, I pick
a velocity relative to the plane and move it in that direction

Matt Sheen, mws262@cornell.edu
%}

close all; clear all;
fig = figure;

%% Same code as B
%Compound Patch - columns are individual patches
pX = [-1 1 0; 
    0 0 0]';
pY = [-1/3 -1/3 2/3;
    -1/3 -1/3 2/3]';
pZ = [0 0 0;
    0 0.5 0]';

p1 = patch(pX,pY,pZ,'red');
p1.FaceAlpha = 0.5;

axis([-2 2 -1 3 -2 2])
view(3)


%% Now to translate it:
OrigVerts = p1.Vertices; %Keep track of the original vertices of the patch.

vel = 0.01*[0 1 0]; %Velocity vector

for i = 1:200  
    p1.Vertices = OrigVerts + i*repmat(vel,[size(OrigVerts,1),1]); %We need to add the displacement to ALL the vertices. Hence, repmat lets us duplicate the displacement to match the dimensions of the patch vertex matrix.
    pause(0.05); 
end