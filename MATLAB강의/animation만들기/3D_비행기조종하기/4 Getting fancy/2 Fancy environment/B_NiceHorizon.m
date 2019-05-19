%{ 
B_NiceHorizon.m

Same stuff as before, now add a horizon.

We do this by adding a huge sphere
around the whole thing and then setting a colormap to be a gradient of
blues going from dark at the top to light at the bottom.

Matt Sheen, mws262@cornell.edu
%}

close all; clear all;
fig = figure;
hold on

%% Make the sky sphere -- just make a sphere surface and map a blue gradient to it.
skymap = winter; %We'll use the colormap "winter" which is defined by matlab.

% Here's a gradient I made up that's a bit more horizon-like. You can
% experiment.
% flipud([logspace(-0.5,0,1000)',logspace(-0.5,0,1000)',logspace(-0.001,0,1000)']);

[skyX,skyY,skyZ] = sphere(50); %create the surface data for a sphere.
sky = surf(500000*skyX,500000*skyY,500000*skyZ,'LineStyle','none','FaceColor','interp'); %Make a sphere object.
colormap(skymap) %Give it colormap we defined above.

%All the code from here on out is from previous examples.

%% Add ground and texture (as in A_NiceGround.m)
ground = 10000*membrane(1,40)-10000;
groundSurf = surf(linspace(-10000,10000,size(ground,1)),linspace(-10000,10000,size(ground,2)),ground,'LineStyle','none','AmbientStrength',0.3,'DiffuseStrength',0.8,'SpecularStrength',0,'SpecularExponent',10,'SpecularColorReflectance',1);

%Add ground texture and shading.
texture = imread('texture.jpg');
groundSurf.FaceColor = 'texturemap';
groundSurf.CData = texture;
camlight('headlight');

axis([-10000 10000 -10000 10000 -10000 10000])
hold off

fig.Children.Visible = 'off';
fig.Children.Clipping = 'off';
fig.Children.Projection = 'perspective';



%% Now let's view it using the same stuff as in Example A in folder 2.
origPos = [8000,8000,0]';
campos(origPos);
origTarget = [0,0,-10000];
camtarget(origTarget);
camva(40)

%pan around the scene
for i = 1:500
    campos(angle2dcm(0.01*i,0,0)*origPos);
    pause(0.01);
    
end

%look up a bit
for i = 1:500
    camtarget(origTarget+[0 0 20]*i);
    pause(0.01);
    
end

%"fly" forward
dir = camtarget - campos;
for i = 1:500
    camtarget(camtarget + 0.01*dir);
    campos(campos + 0.01*dir)
    pause(0.01);
    
end


