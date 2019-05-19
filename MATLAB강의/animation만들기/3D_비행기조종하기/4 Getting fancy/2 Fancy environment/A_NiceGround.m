%{ 
A_NiceGround.m

Use a surface as the ground. Give it a texture and some shadows.

Matt Sheen, mws262@cornell.edu
%}

%% Use the matlab logo as a surface again:
ground = 10000*membrane(1,40)-10000; %Once again, the big numbers aren't necessary, just a relic of past stuff.
groundSurf = surf(linspace(-10000,10000,size(ground,1)),linspace(-10000,10000,size(ground,2)),ground,'LineStyle','none');

%% Add a "dirt" image as the texture.
input('Press enter to add a texture.');
texture = imread('texture.jpg'); %import the image.
groundSurf.FaceColor = 'texturemap'; %Tell the surface to use a texturemap for coloring
groundSurf.CData = texture; %Now set the color data of the surface to be the imported image data.

%% Spruce up the lighting to give some depth
input('Press enter to add shadows.');
material('dull'); %It's nice to have a shiny plane and a dull ground.
camlight('headlight'); %Make the lighting from straight on rather than from inside the surface. We get some shadows this way.