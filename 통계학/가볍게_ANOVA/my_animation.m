clear; close all; clc;

n_step = 100;
tt = linspace(0, 3, n_step);
xx = linspace(-10, 10, n_step); % 20 fr/s for 3 seconds
xx = sigmoid(xx);

%% When mu's get away from each other
mu1 = [-2, 1, 2];
mu2 = [-4, 2, 5];

x = linspace(-10,10,1000);
figure('position', [1921, 41, 1920, 1080], 'color', 'w');  

newVid = VideoWriter('mu_away', 'MPEG-4'); % New
newVid.FrameRate = 20;
newVid.Quality = 100;
open(newVid);

for i_step = 1:n_step

    yy1 = normpdf(x, xx(i_step) * (mu2(1)-mu1(1)) + mu1(1), 1);
    yy2 = normpdf(x, xx(i_step) * (mu2(2)-mu1(2)) + mu1(2), 1);
    yy3 = normpdf(x, xx(i_step) * (mu2(3)-mu1(3)) + mu1(3), 1);
    set(gca,'position', [0.13, 0.33, 0.75, 0.33])
    plot(x, yy1,'linewidth',3);
    hold on;
    plot(x, yy2,'linewidth',3);
    plot(x, yy3,'linewidth',3);
    xlabel('$$x$$','interpreter','latex');
    ylabel('pdf','interpreter','latex');
    grid on;
    set(gca,'fontsize',12);
    set(gca,'fontname','?�눔고딕')
    writeVideo(newVid, getframe(gcf));

    drawnow;
    if i_step < n_step
        cla
    end
end

for i = 1:30
    writeVideo(newVid, getframe(gcf))
end

close(newVid)
%% When mu's gets closer to each other
mu1 = [-4, 2, 5];
mu2 = [-0.2, 0.5, 1.2];

x = linspace(-10,10,1000);
figure('position', [1921, 41, 1920, 1080], 'color', 'w');  

newVid = VideoWriter('mu_closer', 'MPEG-4'); % New
newVid.FrameRate = 20;
newVid.Quality = 100;
open(newVid);

for i_step = 1:n_step

    yy1 = normpdf(x, xx(i_step) * (mu2(1)-mu1(1)) + mu1(1), 1);
    yy2 = normpdf(x, xx(i_step) * (mu2(2)-mu1(2)) + mu1(2), 1);
    yy3 = normpdf(x, xx(i_step) * (mu2(3)-mu1(3)) + mu1(3), 1);

    set(gca,'position', [0.13, 0.33, 0.75, 0.33])
    plot(x, yy1,'linewidth',3);
    hold on;
    plot(x, yy2,'linewidth',3);
    plot(x, yy3,'linewidth',3);
    xlabel('$$x$$','interpreter','latex');
    ylabel('pdf','interpreter','latex');
    grid on;
    set(gca,'fontsize',12);
    set(gca,'fontname','?�눔고딕')
    writeVideo(newVid, getframe(gcf));

    drawnow;
    if i_step < n_step
        cla
    end
end

for i = 1:30
    writeVideo(newVid, getframe(gcf))
end

close(newVid)
%% When sigma's get smaller
sig1 = [2, 1, 1.5];
sig2 = [0.2, 0.1, 0.2];
x = linspace(-10,10,1000);
figure('position', [1921, 41, 1920, 1080], 'color', 'w');  

newVid = VideoWriter('sig_smaller', 'MPEG-4'); % New
newVid.FrameRate = 20;
newVid.Quality = 100;
open(newVid);


for i_step = 1:n_step

    yy1 = normpdf(x, mu1(1), xx(i_step) * (sig2(1)-sig1(1)) + sig1(1));
    yy2 = normpdf(x, mu1(2), xx(i_step) * (sig2(2)-sig1(2)) + sig1(2));
    yy3 = normpdf(x, mu1(3), xx(i_step) * (sig2(3)-sig1(3)) + sig1(3));

    set(gca,'position', [0.13, 0.33, 0.75, 0.33])
    plot(x, yy1,'linewidth',3);
    hold on;
    plot(x, yy2,'linewidth',3);
    plot(x, yy3,'linewidth',3);
    xlabel('$$x$$','interpreter','latex');
    ylabel('pdf','interpreter','latex');
    grid on;
    set(gca,'fontsize',12);
    set(gca,'fontname','?�눔고딕')
    
    writeVideo(newVid, getframe(gcf));

    
    ylim([0, 1.2])
    drawnow;
    if i_step < n_step
        cla
    end
end

for i = 1:30
    writeVideo(newVid, getframe(gcf))
end

close(newVid)
%% When sigma's get bigger
sig1 = [0.2, 0.1, 0.2];
sig2 = [3, 4, 2];
x = linspace(-10,10,1000);
figure('position', [1921, 41, 1920, 1080], 'color', 'w');  

newVid = VideoWriter('sig_bigger', 'MPEG-4'); % New
newVid.FrameRate = 20;
newVid.Quality = 100;
open(newVid);


for i_step = 1:n_step

    yy1 = normpdf(x, mu1(1), xx(i_step) * (sig2(1)-sig1(1)) + sig1(1));
    yy2 = normpdf(x, mu1(2), xx(i_step) * (sig2(2)-sig1(2)) + sig1(2));
    yy3 = normpdf(x, mu1(3), xx(i_step) * (sig2(3)-sig1(3)) + sig1(3));

    set(gca,'position', [0.13, 0.33, 0.75, 0.33])

    plot(x, yy1,'linewidth',3);
    hold on;
    plot(x, yy2,'linewidth',3);
    plot(x, yy3,'linewidth',3);
    xlabel('$$x$$','interpreter','latex');
    ylabel('pdf','interpreter','latex');
    grid on;
    set(gca,'fontsize',12);
    set(gca,'fontname','?�눔고딕')
    ylim([0, 0.4])
    
    writeVideo(newVid, getframe(gcf));

    
    drawnow;
    if i_step < n_step
        cla
    end
end

for i = 1:30
    writeVideo(newVid, getframe(gcf))
end

close(newVid)