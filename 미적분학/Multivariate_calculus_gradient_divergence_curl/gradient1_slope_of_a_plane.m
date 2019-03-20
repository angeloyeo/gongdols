clear; close all; clc;

%%

% f(x,y)= x^2+xy+y^2 그리기
x=-1:0.2:1;
y=-1:0.2:1;

for i_x=1:length(x)
    for i_y=1:length(y)
        f(i_x,i_y)=x(i_x)^2+x(i_x)*y(i_y)+y(i_y)^2;
    end
end

surf(x,y,f)
xlabel('x'); ylabel('y'); zlabel('f(x,y)')
hold on;

%% Gradient

% x방향 성분 quiver 그리기

u_x=zeros(length(x),length(y));
v_x=zeros(length(x),length(y));
w_x=zeros(length(x),length(y));

for i_x=1:length(x)
    for i_y=1:length(y)
        u_x(i_x,i_y)=2*x(i_x)+y(i_y);
    end
end

quiver3(x,y,f,u_x,v_x,w_x)

% y방향 성분 quiver 그리기

u_y=zeros(length(x),length(y));
v_y=zeros(length(x),length(y));
w_y=zeros(length(x),length(y));

for i_x=1:length(x)
    for i_y=1:length(y)
        v_y(i_x,i_y)=x(i_x)+2*y(i_y);
    end
end

quiver3(x,y,f,u_y,v_y,w_y)

% xy방향 성분 quiver 그리기

u_xy=zeros(length(x),length(y));
v_xy=zeros(length(x),length(y));
w_xy=zeros(length(x),length(y));

for i_x=1:length(x)
    for i_y=1:length(y)
        u_xy(i_x,i_y)=2*x(i_x)+y(i_y);
        v_xy(i_x,i_y)=x(i_x)+2*y(i_y);
    end
end

quiver3(x,y,f,u_xy,v_xy,w_xy)

