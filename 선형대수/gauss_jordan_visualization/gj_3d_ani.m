function gj_3d_ani(before,after,x,y,xyz_ans,varargin)


params = inputParser;
params.CaseSensitive = false;
params.addParameter('record', false);
params.addParameter('record_filename','record');
params.parse(varargin{:});

%Extract values from the inputParser
h_record = params.Results.record;
record_filename = params.Results.record_filename;

if h_record
    v = VideoWriter([record_filename,'.mp4'],'MPEG-4');
    v.Quality = 100;
    v.FrameRate = 60;
    open(v);
end

% [az,el]=view;
az = 143;
el = 31;
n_steps = 200;
% n_steps = 1;
my_color = lines(3);

diff = after-before;
% figure;
for i_step = 1:n_steps
    
    tempA = before+diff/n_steps*i_step;
    
    for i =1:3 % 총 세 개의 면을 그리겠음.
        zs(i,:,:) = (tempA(i,4)-tempA(i,1)*x-tempA(i,2)*y)/(tempA(i,3)+eps);
        surf(x,y,squeeze(zs(i,:,:)),'facecolor',my_color(i,:),'edgecolor','k')
        hold on;
    end

    set(gcf,'color','w')
    
    plot3(xyz_ans(1),xyz_ans(2),xyz_ans(3),'r.','markersize',50)
%     light('Position',[9,9,15],'Style','local')
    light('Position',[0.5,0,1.5],'Style','local')

    for i =1:3
        mArrow3([xyz_ans(1),xyz_ans(2),xyz_ans(3)],[xyz_ans(1)+tempA(i,1),xyz_ans(2)+tempA(i,2),xyz_ans(3)+tempA(i,3)],'color',my_color(i,:),'stemWidth',0.2);
%         mArrow3([xyz_ans(1),xyz_ans(2),xyz_ans(3)],[xyz_ans(1)+tempA(i,1),xyz_ans(2)+tempA(i,2),xyz_ans(3)+tempA(i,3)],'color',my_color(i,:),'stemWidth',0.05);
    end
%         
    xlim([-15 15])
    ylim([-15 15])
    zlim([-15 15])


    xlabel('x'); ylabel('y'); zlabel('z')
    
    % intersections
    for i = 1:3
        zdiff = squeeze(zs(i,:,:) - zs(rem(i,3)+1,:,:));
        C = contours(x, y, zdiff, [0 0]);
        % Extract the x- and y-locations from the contour matrix C.
        xL = C(1, 2:end);
        yL = C(2, 2:end);
        % Interpolate on the first surface to find z-locations for the intersection
        % line.
        zL = interp2(x, y, squeeze(zs(i,:,:)), xL, yL);
        % Visualize the line.
        line(xL, yL, zL, 'Color', 'r', 'LineWidth', 2);
    end
%     camlight
    hold off;
    view([az,el]);
    grid on;
    if h_record
        F=getframe(gcf);
        writeVideo(v,F);
    end
    pause(0.01)
%         cla;

    
end
end