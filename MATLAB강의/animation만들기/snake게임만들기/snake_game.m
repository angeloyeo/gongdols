%% Video 2
%% Matlab Gaming: Snake

clear all
close all
clc

speed = .5;
dir = 0;

screensize = get(groot,'Screensize');
dim = [(screensize(3)-screensize(4))/2 0 screensize(4) screensize(4)];

size = 40;

xPos = [0 1 2];
yPos = [0 0 0];
xMove = 1;
yMove = 0;

L = 'You played yourself bud';
turn = 1;

foodX = round((rand(1)*(size/2-1)+(rand(1)*-(size/2-1))),0);
foodY = round((rand(1)*(size/2-1)+(rand(1)*-(size/2-1))),0);

scatter(xPos,yPos,'filled','b')
hold on
scatter(foodX,foodY,'filled','r')
xlim([-size/2 size/2])
ylim([-size/2 size/2])
hold on
set(gcf,'position',dim);

set(gcf,'KeyPressFcn',@stroke)
while xPos(end) > -size/2 & ... 
        xPos(end) < size/2 & ...
        yPos(end) > -size/2 &...
        yPos(end) < size/2
    
    dir = get(gcf,'CurrentKey');
    
    switch dir
        case 'downarrow'
            if yMove ~= speed
                xMove = 0;
                yMove = -speed;
            end
            
        case 'uparrow'
            if yMove ~= -speed
                xMove = 0;
                yMove = speed;
            end
            
        case 'rightarrow'
            if xMove ~= -speed
                xMove = speed;
                yMove = 0;
            end
            
        case 'leftarrow'
            if xMove ~= speed
                xMove = -speed;
                yMove = 0;
            end
            
        otherwise
            xMove = xMove;
            yMove = yMove;
    end
    
    xPrev = xPos;
    yPrev = yPos;
    
    if [xPos(end) yPos(end)] == [foodX foodY]
        foodX = round((rand(1)*(size/2-1)+(rand(1)*-(size/2-1))),0);
        foodY = round((rand(1)*(size/2-1)+(rand(1)*-(size/2-1))),0);
        xPos(end+1) = xPos(end) + xMove;
        yPos(end+1) = yPos(end) + yMove;
        xPos(1:end-2) = xPrev(2:end);
        yPos(1:end-2) = yPrev(2:end);
    else
        xPos(end) = xPos(end) + xMove;
        yPos(end) = yPos(end) + yMove;
        xPos(1:end-1) = xPrev(2:end);
        yPos(1:end-1) = yPrev(2:end);
    end
    
    if sum((xPos(end) == xPos(1:end-1)).*(yPos(end) == yPos(1:end-1))) > 0
        xPos(end) = size;
    end
    
    clf   
    scatter(foodX,foodY,'filled','r')
    xlim([-size/2 size/2])
    ylim([-size/2 size/2])
    hold on
    
    scatter(xPos,yPos,'filled','b')
    xlim([-size/2 size/2])
    ylim([-size/2 size/2])
    hold on    
    
    drawnow
       
end

clf   
scatter(foodX,foodY,'filled','r')
xlim([-size/2 size/2])
ylim([-size/2 size/2])
hold on

scatter(xPos,yPos,'filled','b')
annotation('textbox',[.5 .5 .3 .3],'String',L,'FitBoxToText','on')
xlim([-size/2 size/2])
ylim([-size/2 size/2])
hold on
% 
% function dir = stroke(src,event)
% end