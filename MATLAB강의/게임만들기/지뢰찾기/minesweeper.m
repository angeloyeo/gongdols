clear; close all; clc;

%% canvas

figure;
set(gcf,'color','w');
set(gca,'visible','off');

% plotting grid
n_rows = 6;
n_cols = 6;

vert_u=[0.5:1:(n_cols+0.5); ones(1,n_cols+1)*(n_cols+0.5)]';
vert_d=vert_u;
vert_d(:,2) = vert_d(:,2)-n_cols;

hori_l = fliplr(vert_d);
hori_r = fliplr(vert_u);


for i=1:n_cols+1
    line([vert_u(i,1) vert_d(i,1)],[vert_u(i,2) vert_d(i,2)],'color','k') % vertical lines
    hold on;
end

for i=1:n_rows+1
    line([hori_l(i,1) hori_r(i,1)],[hori_l(i,2) hori_r(i,2)],'color','k') % horizontal_lines
end
