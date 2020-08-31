clear; close all; clc;

lc = 1; % length of cube

my_vertices = [0 0 0; 0 lc 0; lc lc 0; lc 0 0; 0 0 lc; 0 lc lc; lc lc lc; lc 0 lc];
% my_vertices = my_vertices - lc/2*ones(size(my_vertices));
my_faces = [1 2 3 4; 2 6 7 3; 4 3 7 8; 1 5 8 4;  5 6 7 8; 1 2 6 5];

patch('Vertices', my_vertices, 'Faces', my_faces, 'FaceColor', 'r');
%

grid on
camlight

xlim([-1.2 1.2]+0.5)
ylim([-1.2 1.2]+0.5)
zlim([-1.2 1.2]+0.5)

view(3)
xlabel('$$x$$','interpreter','latex');
ylabel('$$y$$','interpreter','latex');
zlabel('$$z$$','interpreter','latex');

axis vis3d
alpha(1)


%% splitting cubes

n_split_x = 1;
n_split_y = 2;
n_split_z = 1;

for i_split = 1:(n_split_x-1)
    split_vertices = [i_split/n_split_x 0 0; i_split/n_split_x 1 0;i_split/n_split_x 1 1;i_split/n_split_x 0 1];
    split_face = [1 2 3 4];
    patch('vertices',split_vertices,'faces',split_face,'facecolor','g');
end

for i_split = 1:(n_split_y-1)
    split_vertices = [0 i_split/n_split_y 0;1 i_split/n_split_y 0;1 i_split/n_split_y 1;0 i_split/n_split_y 1];
    split_face = [1 2 3 4];
    patch('vertices',split_vertices,'faces',split_face,'facecolor','g');
end

for i_split = 1:(n_split_z-1)
    split_vertices = [0 0 i_split/n_split_z;0 1 i_split/n_split_z;1 1  i_split/n_split_z; 1 0 i_split/n_split_z];
    split_face = [1 2 3 4];
    patch('vertices',split_vertices,'faces',split_face,'facecolor','g');
end

view(3)


hold on;
% for x, y split
for i_x = 1:(n_split_x-1)
    for i_y = 1:(n_split_y-1)
        line([i_x/n_split_x i_x/n_split_x],[i_y/n_split_y i_y/n_split_y],[0 1],'linestyle','--')
    end
end

% for y, z split
for i_y = 1:(n_split_y-1)
    for i_z = 1:(n_split_z-1)
        line([0 1],[i_y/n_split_y i_y/n_split_y],[i_z/n_split_z i_z/n_split_z],'linestyle','--')
    end
end


% for x, z split
for i_x = 1:(n_split_x-1)
    for i_z = 1:(n_split_z-1)
        line([i_x/n_split_x i_x/n_split_x],[0 1],[i_z/n_split_z i_z/n_split_z],'linestyle','--')
    end
end

%% alpha
alpha(0.5)

%% 녹화를 위한 회전
set(gcf,'color','w')
for i = 1:360
    disp(i)
    camorbit(1, 0, 'data')
    drawnow
end