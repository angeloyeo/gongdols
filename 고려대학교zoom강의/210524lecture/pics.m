clear; close all; clc;

%% 3을 수직선 상에 표현해주는 그림

clear v
v = VideoWriter('fig1.mp4','MPEG-4');
v.FrameRate = 50;
v.Quality = 100;
open(v);

clear F

fun_plotNumberLine(-4,4,true)
hold on;
the_num = 3;
n_step = 50;
for i_step = 1:n_step
    

    len_arrows = linspace(1, the_num, n_step);
    len_arrow = len_arrows(i_step);
    
    h = mArrow2(0,0,len_arrow,0,{'color','r','linewidth',3});
    F(i_step)=getframe(gcf);

    drawnow;
    if i_step < n_step
        delete(h)
    end
end


for i=1:length(F)
    % convert the image to a frame
    frame = F(i) ;
    writeVideo(v, frame);
end

close(v)


%% -3을 수직선 상에 표현해주는 그림

clear v
v = VideoWriter('fig2.mp4','MPEG-4');
v.FrameRate = 50;
v.Quality = 100;
open(v);

clear F

fun_plotNumberLine(-4,4,true)
hold on;
the_num = -3;
n_step = 50;
for i_step = 1:n_step
    

    len_arrows = linspace(1, the_num, n_step);
    len_arrow = len_arrows(i_step);
    
    h = mArrow2(0,0,len_arrow,0,{'color','r','linewidth',3});
    F(i_step)=getframe(gcf);

    drawnow;
    if i_step < n_step
        delete(h)
    end
end


for i=1:length(F)
    % convert the image to a frame
    frame = F(i) ;
    writeVideo(v, frame);
end

close(v)

%% 3x3을 수직선 상에 표현해주는 그림

clear v
v = VideoWriter('fig3.mp4','MPEG-4');
v.FrameRate = 50;
v.Quality = 100;
open(v);

clear F

fun_plotNumberLine(-4,10,true)
hold on;
the_num = 3;
n_step = 50;
for i_step = 1:n_step
    

    len_arrows = linspace(1, the_num, n_step);
    len_arrow = len_arrows(i_step);
    
    h = mArrow2(0,0,len_arrow,0,{'color','r','linewidth',3});
    F(i_step)=getframe(gcf);

    drawnow;
    if i_step < n_step
        delete(h)
    end
end

for i = 1:10
    F(end+1) = getframe(gcf);
end

delete(h)

for i_step = 1:n_step
    

    len_arrows = linspace(the_num, the_num^2, n_step);
    len_arrow = len_arrows(i_step);
    
    h = mArrow2(0,0,len_arrow,0,{'color','r','linewidth',3});
    F(end+1)=getframe(gcf);

    drawnow;
    if i_step < n_step
        delete(h)
    end
end


for i=1:length(F)
    % convert the image to a frame
    frame = F(i) ;
    writeVideo(v, frame);
end

close(v)

