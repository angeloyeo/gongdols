clear; close all; clc;

%% Domain
% space
Lx = 10;
dx = 0.1;
nx = fix(Lx/dx);
x = linspace(0, Lx, nx);

% Time
T = 40;

%% Field variables
% parameters
CFL = 1; % CFL = c.dt/dx
c = 1;
dt = CFL*dx/c;
total_t = 0:dt:T-dt;

%% Initial Conditions
% wn = 1/2*sin(2*pi*1/20*x);% + 1/4*sin(2*pi*1/10*x) + 1/8*sin(2*pi*1/5*x);
% wn = 1/2*sin(2*pi*1/10*x);% + 1/4*sin(2*pi*1/10*x) + 1/8*sin(2*pi*1/5*x);
wn = 1/2*sin(2*pi*3/20*x);
%% Time stepping loop
whole_wave = zeros(length(total_t),length(x)); % (time, space)
whole_wave(1,:) = wn;
whole_wave(2,:) = wn;

for i_time= 2:length(total_t)-1
    for i_space = 2:nx-1
        whole_wave(i_time+1,i_space) = 2*whole_wave(i_time,i_space) - whole_wave(i_time-1,i_space) ...
            + CFL^2 * (whole_wave(i_time,i_space+1) - 2*whole_wave(i_time,i_space) + whole_wave(i_time,i_space-1));
    end
end
% 
% for i = 1:length(total_t)
%     plot(whole_wave(i,:))
%     
%     xlim([0 100])
%     ylim([-1 1])
%     title(sprintf('%.2f s',total_t(i)));
%     pause(dt*0.1);
%     
% end

figure('color','w');
colormap(jet)
mesh(x,total_t,whole_wave);
ylabel('time'); xlabel('space (x)');
[caz, cel] = view;
% set(gca,'xtick',0:2:50)
% set(gca,'ytick',-5:5:25)
for i = 1:300
    view(caz + 360 * i / 300, cel)
    axis tight
    pause(0.02)
end

