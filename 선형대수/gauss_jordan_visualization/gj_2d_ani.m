function gj_2d_ani(before,after,x,xy_ans,varargin)

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

n_steps = 100;

diff = after-before;
% figure;
for i_step = 1:n_steps
    tempA = before+diff/n_steps*i_step;
    
    y1 = (-tempA(1,1)*x+tempA(1,3))/(tempA(1,2)+eps);
    y2 = (-tempA(2,1)*x+tempA(2,3))/(tempA(2,2)+eps);
    
    plot(x,y1);
    hold on;
    plot(x,y2);
    plot(xy_ans(1,1), xy_ans(2,1),'r.','markersize',20)
    grid on;
    hold off;
    xlim([-5 5])
    ylim([-5 5])
    
    if h_record
        F=getframe(gcf);
        writeVideo(v,F);
    end
    
    pause(0.01);

end