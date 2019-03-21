clear; close all; clc;

rho = 1; % density
cp = 1; % specific heat
K = 1; % thermal conductivity

A = K/rho/cp;

% domain and step
Lx = 10;

Nx = 21; Nt = 500;
dx = Lx/(Nx-1);

% Satisfy CFL condition
c = 1; % speed
C = 0.1; % Courant number
dt = C*dx/c;

% field variables
Tn = zeros(1,Nx); % temperature
x = linspace(0, Lx, Nx); % distance

% Initial condition
Tn(:) = 100;
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
figure;
for i_time = 1:Nt
    plot(whole_heat(:,i_time));
    ylim([0 100])
    xlim([1 21])
    title(sprintf('time: %.2f s',whole_time(i_time)));
    pause(0.01);
end

figure;
mesh(whole_time,1:21,whole_heat); colormap(jet)