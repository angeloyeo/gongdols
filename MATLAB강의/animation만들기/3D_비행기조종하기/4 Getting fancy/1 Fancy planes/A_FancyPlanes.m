%{ 
A_FancyPlanes.m

Import 3d models as patch objects. After importing, they can be used just
like the patches we showed in previous examples.

 Requires:
 - stlread.m (from file exchange or in this folder).
 - A binary STL file, I got these from a 3D printing website,
 thingiverse.com.

Note that binary STL files seem to import much faster than ascii ones (can
convert easily with Meshlab if needed).


Matt Sheen, mws262@cornell.edu
%}
close all; clear all;

%% Make a cessna
fig1 = figure;

patchData = stlread('cessna.stl'); %THIS IS THE ONLY LINE THAT'S REALLY DIFFERENT FROM BEFORE.

p1 = patch(patchData,'EdgeColor','none','FaceColor','[0.8 0.8 1.0]','FaceAlpha',0.9);

axis equal
material('metal') %Not really needed, just makes the plane shinier.
camlight('headlight'); %... and better lit.
view(3)


%% Make an A10
fig2 = figure;

patchData = stlread('A10.stl');

p2 = patch(patchData,'EdgeColor','none','FaceColor','[0.8 0.8 1.0]','FaceAlpha',0.9);

axis equal
material('metal')
camlight('headlight');
view(3)

