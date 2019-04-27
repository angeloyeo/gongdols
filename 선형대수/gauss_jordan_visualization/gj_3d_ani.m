function gj_3d_ani(before,after,x,y,xyz_ans,varargin)


params = inputParser;
params.CaseSensitive = false;
params.addParameter('record', 'false');
params.addParameter('record_filename','record');
params.parse(varargin{:});

%Extract values from the inputParser
h_record = params.Results.record;
record_filename = params.Results.record_filename;

if h_record
    v = VideoWriter([record_filename,'.mp4'],'MPEG-4');
    open(v);
end

[az,el]=view;
n_steps = 100;
my_color = lines(3);

diff = after-before;
% figure;
for i_step = 1:n_steps
    
    tempA = before+diff/n_steps*i_step;
    
    for i =1:3 % 총 세 개의 면을 그리겠음.
        zs(1,:,:) = (tempA(1,4)-tempA(1,1)*x-tempA(1,2)*y)/(tempA(1,3)+eps);
        zs(2,:,:) = (tempA(2,4)-tempA(2,1)*x-tempA(2,2)*y)/(tempA(2,3)+eps);
        zs(3,:,:) = (tempA(3,4)-tempA(3,1)*x-tempA(3,2)*y)/(tempA(3,3)+eps);
    end
    
    surf(x,y,squeeze(zs(1,:,:)),'facecolor',my_color(1,:),'edgecolor','none')
    hold on;
    surf(x,y,squeeze(zs(2,:,:)),'facecolor',my_color(2,:),'edgecolor','none')
    surf(x,y,squeeze(zs(3,:,:)),'facecolor',my_color(3,:),'edgecolor','none')
    plot3(xyz_ans(1),xyz_ans(2),xyz_ans(3),'r.','markersize',50)
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
        line(xL, yL, zL, 'Color', 'k', 'LineWidth', 3);
    end
%     camlight
    hold off;
    view([az,el]);
    
    if h_record
        F=getframe(gcf);
        writeVideo(v,F);
    end
    pause(0.01)
    
end