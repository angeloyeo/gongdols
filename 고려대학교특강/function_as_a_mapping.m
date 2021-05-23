clear; close all; clc;

n = 150;
xx = linspace(-4,4,n);
my_polynomial = [1, -2, -3, 4];
yy = polyval(my_polynomial, xx);

n_step = 150;

newVid = VideoWriter('pic1', 'MPEG-4'); % New
newVid.FrameRate = 30;
newVid.Quality = 100;
open(newVid);

figure('position',[490, 110, 900, 650],'color','w');
for i_step = 1:n_step
    yy2plot = (yy - zeros(1, n)) * i_step / n_step + zeros(1, n);
    plot2DPlane(-4,4,-6,6,false);
    hold on;
    
    if i_step == 1
        
        plot(xx, zeros(1,n),'linewidth',2);
        xlim([-3, 4])
        ylim([-6, 6])
        grid on;
        xlabel('$$x$$','interpreter','latex');
        ylabel('$$y = f(x)$$','interpreter','latex');
        title('$$y=f(x)=x^3-2x^2-3x+4$$','interpreter','latex')

        for i = 1:29 % 첫 장면에서 1.5초 대기할 수 있도록
            
            writeVideo(newVid, getframe(gcf))
        end
        drawnow;
        cla;
    end
    plot2DPlane(-4,4,-6,6,false);

    plot(xx, yy2plot,'linewidth',2);
    xlim([-3, 4])
    ylim([-6, 6])
    grid on;
    xlabel('$$x$$','interpreter','latex');
    ylabel('$$y = f(x)$$','interpreter','latex');
    title('$$y=f(x)=x^3-2x^2-3x+4$$','interpreter','latex')
    drawnow;

    writeVideo(newVid, getframe(gcf))
    
    if i_step < n_step
        cla;
    end
end

for i = 1:30 % 마지막 장면에서 1.5초 더 대기할 수 있도록
    writeVideo(newVid, getframe(gcf))
end

close(newVid)
