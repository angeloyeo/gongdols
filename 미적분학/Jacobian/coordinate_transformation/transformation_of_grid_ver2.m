clear; close all; clc;

% addpath('C:\Users\icbab\Google 드라이브\여동훈_개인공부정리파일\MATLAB코드모음\다른사람_참고code\VideoRecorder\');

[X,Y]=ndgrid(-6:1:6);

% A = [2 -3;1 1];
A=[2,1;1,2]; % shear
% angle = pi/3; A = [cos(angle) -sin(angle); sin(angle) cos(angle)]; %rotation
% A = [0, 1; 1, 0]; % permutation
% A = [1,0;0,0]; % projection
% vector = [1,2]'; A = vector*vector'; % projection on a vector
n_steps = 100;
figure;
set(gcf,'color','w');
set(gca,'nextplot','replacechildren');
% v = VideoWriter('Shear_transform.mp4','MPEG-4');

% open(v);
for i_steps = 0:n_steps
    step_mtx = (A-eye(2))/n_steps*i_steps;
    
    new_xy = (eye(2)+step_mtx)*[X(:), Y(:)]';
    new_XY = reshape(new_xy,[2,size(X,1),size(X,1)]);
    for i = -3:3
        for j =-4:0
            line([i i],[-j j],'color',[128 128 128]/255);
            hold on;
            
            line([-j j],[i, i],'color',[128 128 128]/255);
        end
    end
    plot(squeeze(new_XY(1,:,:)), squeeze(new_XY(2,:,:)),'-','color',[255, 102, 102]/255);
    plot(squeeze(new_XY(1,:,:))', squeeze(new_XY(2,:,:))','-','color',[255, 102, 102]/255);
    
    axis equal
    
    xlim([-4,4])
    ylim([-4,4])
    
    new_xy = (eye(2)+step_mtx)*eye(2);
    axis off
    
    %     mArrow2(0,0,new_xy(1,1), new_xy(2,1),{'color',[0,153,51]/255,'linewidth',3});
    %     mArrow2(0,0,new_xy(1,2), new_xy(2,2),{'color',[255 102 0]/255,'linewidth',3});
%     
%     F=getframe(gcf);
%     writeVideo(v,F);
% pause;
    drawnow;
    if i_steps<n_steps
        cla
    end
end
% text(1.2714, 0.3325, '$$\hat{i}_{new}$$','interpreter','latex','fontsize',15)
% text(-2.8949, 0.3325, '$$\hat{j}_{new}$$','interpreter','latex','fontsize',15)
% close(v);

%% 비선형 변환
clear; close all
n_steps = 50;
clear F
range = 6;
figure;
set(gcf,'color','w');

for i_step = 0:n_steps
    for i_x = -range:range
        Y = linspace(-range,range,100);
        X = i_x*ones(1,100);
        
        %%% 함수 %%%
        [newX,newY]=my_nonlin_func(X,Y);
        
        changeX = newX-X;
        changeY = newY-Y;
        
        new_X = X+changeX*i_step/n_steps;
        new_Y = Y+changeY*i_step/n_steps;
        
        plot(new_X,new_Y,'b'); hold on;
        plot(new_Y,new_X,'b');
        xlabel('x'); ylabel('y');
        
        grid on;
        xlim([-4,4])
        ylim([-4,4])
    end
    %     F(i_step+1)=getframe(gcf);
    drawnow;
    %     pause;
    hold off;
    
end
%
% % create the video writer with 1 fps
% writerObj = VideoWriter('nonlinear_transform3.avi');
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


%% 비선형 변환 + local linearity

close all
n_steps = 20;

ROI = [1,1];
delta = 0.1;
num_lines_ROI = 5; % each for X, Y axis
xs_ROI = linspace(ROI(1)-delta*floor(num_lines_ROI/2),ROI(1)+delta*floor(num_lines_ROI/2),num_lines_ROI);
ys_ROI = linspace(ROI(2)-delta*floor(num_lines_ROI/2),ROI(2)+delta*floor(num_lines_ROI/2),num_lines_ROI);

range = 6;
h_ROI =1;
for i_step = 0:n_steps
    for i_x = -range:range
        Y = linspace(-range,range,100);
        X = i_x*ones(1,100);
        
        %%% 함수 %%%
        [newX,newY, changeX, changeY]=my_nonlin_func(X,Y);
        
        new_X = X+changeX*i_step/n_steps;
        new_Y = Y+changeY*i_step/n_steps;
        
        plot(new_X,new_Y,'b'); hold on;
        xlabel('x'); ylabel('y');
        
        
    end
    
    for i_y = -range:range
        X = linspace(-range,range,100);
        Y = i_y*ones(1,100);
        
        %%% 함수 %%%
        [newX,newY, changeX, changeY]=my_nonlin_func(X,Y);
        
        new_X = X+changeX*i_step/n_steps;
        new_Y = Y+changeY*i_step/n_steps;
        
        plot(new_X,new_Y,'r'); hold on;
        xlabel('x'); ylabel('y');
        
        
    end
    
    if h_ROI == 1
        for i_x_ROI = 1:num_lines_ROI
            Y = linspace(-range,range,100);
            X = xs_ROI(i_x_ROI)*ones(1,100);
            
            %%% 함수 %%%
            [newX,newY, changeX, changeY]=my_nonlin_func(X,Y);
            
            new_X = X+changeX*i_step/n_steps;
            new_Y = Y+changeY*i_step/n_steps;
            
            plot(new_X,new_Y,'b');
        end
        
        for i_y_ROI = 1:num_lines_ROI
            X = linspace(-range,range,100);
            Y = ys_ROI(i_y_ROI)*ones(1,100);
            
            %%% 함수 %%%
            [newX,newY, changeX, changeY]=my_nonlin_func(X,Y);
            
            new_X = X+changeX*i_step/n_steps;
            new_Y = Y+changeY*i_step/n_steps;
            
            plot(new_X,new_Y,'r');
        end
        
        [newROI(1), newROI(2), change_ROIX, change_ROIY]=my_nonlin_func(xs_ROI(1),ys_ROI(1));
        
        new_ROI(1) = ROI(1)+change_ROIX*i_step/n_steps;
        new_ROI(2) = ROI(2)+change_ROIY*i_step/n_steps;
        
        mArrow2(new_ROI(1)-delta*4,new_ROI(2)-delta*4,new_ROI(1)-delta*3,new_ROI(2)-delta*3,{'color','r','linestyle','none'});
    end
    grid on;
    xlim([-4 4])
    ylim([-4 4])
%     xlim([-20 20])
%     ylim([-20 20])
    hold off;
    drawnow;
%         pause;
    
end