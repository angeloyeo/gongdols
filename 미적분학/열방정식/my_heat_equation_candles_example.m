clear; close all; clc;

rho = 1; % density
cp = 1; % specific heat
K = 1; % thermal conductivity

A = K/rho/cp;

% domain and step
Lx = 21;

Nx = 100; Nt = 500;
dx = Lx/(Nx-1);

% Satisfy CFL condition
c = 1; % speed
C = 0.1; % Courant number
dt = C*dx/c;

% field variables
Tn = zeros(1,Nx); % temperature
x = linspace(0, Lx, Nx); % distance

% Initial condition
% Tn(:) = 100;
Tn(:) = 100*normpdf(x,1/3*Lx,2)+ 100*normpdf(x,2/3*Lx,2);
plot(Tn); ylim([0 30])
t = 0;

% loop
whole_heat = zeros(Nx,Nt); % (space, time)
whole_heat(:,1) = Tn; % initial condition
whole_heat(1,1) = 0; whole_heat(end,1) = 0; % BC for initial condition

for n = 2:Nt
    Tc = Tn;
    
    t= t+dt;
    for i = 2: Nx-1
        Tn(i) =Tc(i) +dt *A *((Tc(i+1) - 2*Tc(i) + Tc(i-1))/dx/dx);
    end
    
    % Boundary condition
    Tn(1) = 0; Tn(end) = 0; % Dirichlet condition
    whole_heat(:,n) = Tn;
    
end

whole_time = 0:dt:Nt*dt-dt;

%%

figure;
for i_time = 1:Nt
    plot(x,whole_heat(:,i_time));
    ylim([0 30])
    xlim([0 21])
    title(sprintf('time: %.2f s',whole_time(i_time)));
    pause(0.01);
end


%%
close all;
figure('color','w');
colormap(jet)
mesh(whole_time,x,whole_heat);
xlabel('time (s)');
ylabel('length of rod');
zlabel('temperature')
[caz, cel] = view;
set(gca,'xtick',0:2:50)
set(gca,'ytick',-5:5:25)
for i = 1:300
    view(caz + 360 * i / 300, cel)
    axis tight
    ylim([-5, 25])
    xlim([0, Nt*dt])
    pause(0.02)
end

