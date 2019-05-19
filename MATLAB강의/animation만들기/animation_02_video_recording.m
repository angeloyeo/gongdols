clear; close all; clc;

%% 원을 따라 움직이는 점 만들기
figure;

theta= linspace(0,2*pi,100);

x = cos(theta); y = sin(theta);

for i = 1:length(theta)
    plot(x,y,'color','b')
    axis square
    
    hold on;
    plot(cos(theta(i)), sin(theta(i)),'ro', 'markerfacecolor','r','markersize',15)
    F(i) = getframe(gcf);
    
%     drawnow;
    
    hold off;
end

%% video recording

v = VideoWriter('my_animation.mp4','MPEG-4');
v.FrameRate = 30;
v.Quality = 100;

open(v);
writeVideo(v, F);
close(v);









