function rot = fun_ypr2rotation(yaw,pitch,roll)

% Âü°í site: http://planning.cs.uiuc.edu/node102.html
a = yaw;
b = pitch;
c = roll;

rot = [cos(a)*cos(b) cos(a)*sin(b)*sin(c)-sin(a)*cos(c) cos(a)*sin(b)*cos(c)+sin(a)*sin(c);
    sin(a)*cos(b) sin(a)*sin(b)*sin(c)+cos(a)*cos(c) sin(a)*sin(b)*cos(c)-cos(a)*sin(c);
    -sin(b) cos(b)*sin(c) cos(b)*cos(c)];