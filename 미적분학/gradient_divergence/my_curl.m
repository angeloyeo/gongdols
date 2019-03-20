clear; close all; clc;
%% easiest example of curl: a stick on a stream

[x,y]=meshgrid(0:1/10:1.5);
u=y;
v=zeros(size(x));

figure;
quiver(x,y,u,v);
% grid on;
axis([0 1 0 1])

%% easy example for curl: Vortex
figure;
U_i = 10;% free stream velocity
C = 1000/(2*pi);% vortex strength
meshfactor = 10;
[x,y] = meshgrid(-U_i:U_i/meshfactor:U_i);


x1 = 0;
y1 = 0;
u1 = U_i - C*(y-y1)./(2*((x-x1).^2 + (y-y1).^2)); %%define the velocity component in the x
v1 = C*(x-x1)./(2*((x-x1).^2 + (y-y1).^2)); %%define the velocity component in the y

x2 = 4;
y2 = 5;
u2 = U_i + C*(y-y2)./(2*((x-x2).^2 + (y-y2).^2)); %%define the velocity component in the x
v2 = -C*(x-x2)./(2*((x-x2).^2 + (y-y2).^2)); %%define the velocity component in the y

u = u1+u2;
v = v1+v2;

[r,c]=find(isnan(u));

for i = 1:2
    u(r(i), c(i))=mean([u(r(i)-1,c(i)),u(r(i)+1,c(i))]);
    v(r(i), c(i))=mean([v(r(i)-1,c(i)),v(r(i)+1,c(i))]);
end

quiver(x,y,u,v)
xlim([-U_i, U_i])
ylim([-U_i, U_i])
set(gcf,'position',[542 137 750 627])

%%
hold on;
[verts,averts] = streamslice(x,y,u,v);
sl = streamline([verts averts]);

iverts = interpstreamspeed(x,y,u,v,verts,0.01);
streamparticles(iverts,100,'Animate',15,'FrameRate',40,'Markersize',5)

%% Vortex represented with curl

figure;
ccurl=curl(x,y,u,v);
pcolor(x,y,ccurl);
hold on
shading interp
colormap(jet);

quiver(x,y,u,v);
xlim([-U_i, U_i])
ylim([-U_i, U_i])
set(gcf,'position',[542 137 750 627])

%% ex: wind
k = 4;
load wind
x = x(:,:,k);
y = y(:,:,k);
u = u(:,:,k);
v = v(:,:,k);
figure;
cav = curl(x,y,u,v);
pcolor(x,y,cav);
shading interp
hold on
quiver(x,y,u,v,'y','color','k');
hold off
colormap('jet');