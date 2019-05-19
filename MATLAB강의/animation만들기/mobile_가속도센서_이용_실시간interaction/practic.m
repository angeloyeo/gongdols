clear; close all; clc;
% https://kr.mathworks.com/help/supportpkg/mobilesensor/ug/use-logged-sensor-data.html

connector on
m = mobiledev;
m.logging = 1;

%%
[o,t] = orientlog(m);
connector off;
%%

A = [0 0 0];
B = [1 0 0];
C = [0 1 0];
D = [0 0 1];
E = [0 1 1];
F = [1 0 1];
G = [1 1 0];
H = [1 1 1];
P = [A;B;F;H;G;C;A;D;E;H;F;D;E;C;G;B];
plot3(P(:,1),P(:,2),P(:,3))
Porig = P;

%%
figure;
%  roll = -0.3064; pitch = -1.2258; yaw = 9.8066;
while(1)
    o = m.orientation
    yaw = deg2rad(o(1,1));
    pitch = deg2rad(o(1,2));
    roll = deg2rad(o(1,3));
%     dcm = angle2dcm(yaw, pitch, roll);
    dcm = fun_ypr2rotation(yaw,pitch,roll);
    P = Porig*dcm;
    plot3(P(:,1),P(:,2),P(:,3)) % rotated cube
    xlim([-2 2])
    ylim([-2 2])
    zlim([-2 2])
    pause(0.1);

%     drawnow;
    
end
