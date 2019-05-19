%{ 
FigPropertiesEx.m

This shows the hierarchy of plot objects in matlab and what sorts of
properties each one has. The goal is not to learn a specific command, but
rather how to look for properties you might want to change.

Matt Sheen, mws262@cornell.edu
%}


close all; clear all;

%Figure object
fig = figure;

%Sample plot:
sampleData = membrane(1,40);
sampleSurf = surf(linspace(-1,1,size(sampleData,1)),linspace(-1,1,size(sampleData,2)),sampleData);
%%%%%%%%%%%%%

%Hierarchy of plot "objects" -- figure > axes > plot

%1. Figure properties -- things pertaining to the whole window (also
%mouse/keyboard callbacks)
    input('Press enter to see example Figure object properties change')
    get(fig)
                    %MATLAB 2014b+ version -- more object oriented
    fig.Position = [100 100 200 200]; %x,y,width,height

                    %Older - must use set/get
    set(fig,'Position',[200 100 400 400]);
    
    
    
%2. Axes properties -- view, axis, camera properties
    input('Press enter to see example Axis object properties change')
    axis1 = fig.Children;
    get(axis1);
    
    axis1.GridLineStyle = 'none'; %ex: make the grid lines more transparent
    
    
%3. Plot/surf/patch...  properties - Alter your data and how it looks
    input('Press enter to see example Plot/Surface object properties change')
    get(sampleSurf) %sampleSurf is also fig.Children.Children
    
    %Alter data - Faster than plot,plot,plot...
    sampleSurf.ZData(50,10) = 1;
    
    %Alter the look:
    sampleSurf.LineStyle = 'none';
    sampleSurf.FaceAlpha = 0.5;




    
    
    
    




