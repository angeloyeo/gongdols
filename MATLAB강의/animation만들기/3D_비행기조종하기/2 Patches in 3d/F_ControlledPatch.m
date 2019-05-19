function F_ControlledPatch
%{ 
F_ControlledPatch.m

Basically, the loop-de-loop example with keyboard controls.

Use W-S for pitch.
A-S for roll.
Q-E for yaw.

Matt Sheen, mws262@cornell.edu
%}


close all

fig = figure;
hold on

%Convenient, but not absolutely necessary figure properties:
fig.Position = [600 600 1500 1200]; %Change figure position and size
%Change the axis properties a bit:
fig.Children.Visible = 'off'; %Turn off the white box of the axis
fig.Children.Clipping = 'off'; %Keep the axis from clipping the plane when the plane leaves the area.
fig.Children.Projection = 'perspective'; %Makes objects in the forground appear larger than objects in the rear.


%Set the keyboard callbacks to listen for key press and releases
set(fig,'WindowKeyPressFcn',@KeyPress,'WindowKeyReleaseFcn', @KeyRelease);
%These are flags for when the keys are pressed. They are changed by the
%callbacks and read inside the animation loop.
fig.UserData.e = false;
fig.UserData.q = false;
fig.UserData.a = false;
fig.UserData.d = false;
fig.UserData.w = false;
fig.UserData.s = false; %The UserData field of figure objects lets us pass whatever we want along with the figure object
         

camva(60); %Set the camera view angle -- more about this in the Camera folder of the example set.

%% Compound Patch - columns are individual patches -- same again as example B
pY = [-1 1 0; 
    0 0 0]';
pX = [-1/3 -1/3 2/3;
    -1/3 -1/3 2/3]';
pZ = [0 0 0;
    0 0.5 0]';

p1 = patch(pX,pY,pZ,'red');
p1.FaceAlpha = 0.5;

vert = p1.Vertices;


forwardVec = [1 0 0]';
rot = eye(3,3);
pos = [0,0,0];

vel = 5;

hold off
axis(0.2*[-10 10 -10 10 -10 10])


%% Start an animation loop
tic
told = 0;
while(ishandle(fig)) %Loop continues until you close the window.
  tnew = toc;
  
  %Check for keystroke callbacks.
  if fig.UserData.e
      rot = rot*angle2dcm(0.05,0,0); %Rotation matrix generated for whichever key is pressed
  end
  if fig.UserData.q
      rot = rot*angle2dcm(-0.05,0,0);
  end
  if fig.UserData.s
      rot = rot*angle2dcm(0,-0.05,0);
  end
  if fig.UserData.w
      rot = rot*angle2dcm(0,0.05,0);
  end
  if fig.UserData.a
      rot = rot*angle2dcm(0,0,-0.05);
  end
  if fig.UserData.d
      rot = rot*angle2dcm(0,0,0.05);
  end
  
  %Now change the orientation/position -- same as example E
  pos = vel*(rot*forwardVec*(tnew-told))' + pos;

  p1.Vertices = (rot*vert')' + repmat(pos,[size(vert,1),1]);

    told = tnew;
    pause(0.01);
    
end
end


%Keyboard callbacks, these just change a few flags when keys are
%pressed/released.
function KeyPress(varargin)
     fig = varargin{1};
     key = varargin{2}.Key;
     if strcmp(key,'e') 
         fig.UserData.e = true;
     elseif strcmp(key,'q')
         fig.UserData.q = true;
     elseif strcmp(key,'a')
         fig.UserData.a = true;
     elseif strcmp(key,'d')
         fig.UserData.d = true;
     elseif strcmp(key,'w')
         fig.UserData.w = true;
     elseif strcmp(key,'s')
         fig.UserData.s = true;
     end
end

function KeyRelease(varargin)
     fig = varargin{1};
     key = varargin{2}.Key;
     if strcmp(key,'e') 
         fig.UserData.e = false;
     elseif strcmp(key,'q')
         fig.UserData.q = false;
     elseif strcmp(key,'a')
         fig.UserData.a = false;
     elseif strcmp(key,'d')
         fig.UserData.d = false;
     elseif strcmp(key,'w')
         fig.UserData.w = false;
     elseif strcmp(key,'s')
         fig.UserData.s = false;
     end
end