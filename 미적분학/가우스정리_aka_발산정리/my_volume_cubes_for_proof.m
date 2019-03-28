clear; close all; clc;

lc = 1; % length of cube
figure;
set(gcf,'color','w')
my_vertices = [0 0 0; 0 lc 0; lc lc 0; lc 0 0; 0 0 lc; 0 lc lc; lc lc lc; lc 0 lc];
% my_vertices = my_vertices - lc/2*ones(size(my_vertices));
my_faces = [1 2 3 4; 2 6 7 3; 4 3 7 8; 1 5 8 4;  5 6 7 8; 1 2 6 5];

patch('Vertices', my_vertices, 'Faces', my_faces, 'FaceColor', 'r');
%

%% 작은 큐브를 z방향으로 쌓아보자.

lc_s = 0.2;
n_lc_s = round(lc/lc_s);

for i = 1:n_lc_s
    my_vertices = [0 0 0; 0 lc_s 0; lc_s lc_s 0; lc_s 0 0; 0 0 lc_s; 0 lc_s lc_s; lc_s lc_s lc_s; lc_s 0 lc_s];
    my_vertices(:,3)=my_vertices(:,3)+lc_s*(i-1);
    my_vertices(:,1)=my_vertices(:,1)+0.5-0.1;
    my_vertices(:,2)=my_vertices(:,2)+0.5-0.1;
    % my_vertices = my_vertices - lc/2*ones(size(my_vertices));
    my_faces = [1 2 3 4; 2 6 7 3; 4 3 7 8; 1 5 8 4;  5 6 7 8; 1 2 6 5];

    patch('Vertices', my_vertices, 'Faces', my_faces, 'FaceColor', 'g');
end

%%
grid on
camlight

xlim([-1.2 1.2]+0.5)
ylim([-1.2 1.2]+0.5)
zlim([-1.2 1.2]+0.5)

view(3)
xlabel('x');
ylabel('y');
zlabel('z');

axis vis3d
alpha(0.3)


%% splitting cubes



