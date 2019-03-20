clear; close all; clc;

% A = [1,2,3; 1,2,1;3,5,4];
% A = [1 2 3;2,1,4;3,4,1]; % shear
% A = [1,0,0;0,2,0;0,0,3]; % scaling
% A = [0,1,0; 1,0,0; 0,0,1] % xy permutation
% A = [1,0,0; 0,0,1; 0,1,0] % yz permutation
% A = [0,0,1; 0,1,0; 1,0,0] % xz permutation
% angle = pi/4; A = [1,0,0;0,cos(angle),-sin(angle);0,sin(angle),cos(angle)]; % rotation around x
% A=[1,0,0;0,1,0;0,0,0]; % projection on xy plane
vector1 = [-1,2,1]'; vector2 = [1,1,1]'; A = [vector1/norm(vector1) vector2/norm(vector2)]*[vector1/norm(vector1) vector2/norm(vector2)]'; % projection onto a plane defined with vectors 1 & 2

%% animation with dots
[X,Y,Z] = ndgrid(-1:0.3:1);
n_steps = 100;
n_cam=200;
step_mtx = eye(3);
newXYZ=A*[X(:), Y(:), Z(:)]';
xyz_min=min(min(min([newXYZ(:),newXYZ(:),newXYZ(:)]')))*1.5;
xyz_max=max(max(max([newXYZ(:),newXYZ(:),newXYZ(:)]')))*1.5;
LIMS = [xyz_min, xyz_max];

dot_colors = jet(length(X(:)));

figure(2)
set(gcf,'color','w')
scatter3(X(:),Y(:),Z(:),30,dot_colors,'filled');
xlim(LIMS); ylim(LIMS); zlim(LIMS);
% axis off
grid on;
hold on;
% line([xyz_min, xyz_max], [0,0], [0,0],'linewidth',3)
% line([0,0], [xyz_min, xyz_max], [0,0],'linewidth',3)
% line([0,0], [0,0], [xyz_min, xyz_max],'linewidth',3)
xlabel('x'); ylabel('y'); zlabel('z')
hold off;
pause;
for i_steps = 1:n_steps+n_cam
    step_mtx = (A-eye(3))/n_steps*i_steps;
    if i_steps<=n_steps
        new_xyz = (eye(3)+step_mtx)*[X(:), Y(:), Z(:)]';
        scatter3(new_xyz(1,:), new_xyz(2,:), new_xyz(3,:),30,dot_colors,'filled');
        grid on; hold on;
%         line([xyz_min, xyz_max], [0,0], [0,0],'linewidth',3)
%         line([0,0], [xyz_min, xyz_max], [0,0],'linewidth',3)
%         line([0,0], [0,0], [xyz_min, xyz_max],'linewidth',3)
        hold off;
        xlim(LIMS); ylim(LIMS); zlim(LIMS);
        xlabel('x'); ylabel('y'); zlabel('z')
    else
        az=-37.5+360*(i_steps-n_steps)/n_cam;
        el=30;
        view(az,el)
    end
%     F(i_steps)=getframe(gcf);
    
    
    pause(0.01);
end
% 
% % create the video writer with 1 fps
% writerObj = VideoWriter('3d_to_2d_transformation.avi');
% writerObj.FrameRate = 30;
% % set the seconds per image
% % open the video writer
% open(writerObj);
% % write the frames to the video
% for i=1:length(F)
%     % convert the image to a frame
%     frame = F(i) ;
%     writeVideo(writerObj, frame);
% end
% % close the writer object
% close(writerObj);



%% SVD
[U,S,V] = svd(A);
hold on;
for i = 1:3
    mArrow3([0,0,0],[U(1,i)*S(i,i),U(2,i)*S(i,i),U(3,i)*S(i,i)],'color','b');
    hold on;
end

for i = 1:3
    mArrow3([0,0,0],[V(1,i),V(2,i),V(3,i)],'color','g');
end
set(gcf,'position',[249 86 763 637  ]);
clear F
for i_steps = 1:600
    F(i_steps)=getframe(gcf);
    
    az=-37.5+360*(i_steps)/600;
    el=30;
    view(az,el)
    xlim(LIMS); ylim(LIMS); zlim(LIMS);
    drawnow
end

% create the video writer with 1 fps
writerObj = VideoWriter('3d_to_2dSVD.avi');
writerObj.FrameRate = 30;
% set the seconds per image
% open the video writer
open(writerObj);
% write the frames to the video
for i=1:length(F)
    % convert the image to a frame
    frame = F(i) ;
    writeVideo(writerObj, frame);
end
% close the writer object
close(writerObj);
