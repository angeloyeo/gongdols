clear; close all; clc;

rho = 1; % density
cp = 1; % specific heat
% K = 1; % thermal conductivity

% domain and step
Lx = 10;
Ly = 10;


Nx = 51; Nt = 500;
Ny = 51;
dx = Lx/(Nx-1);
dy = Ly/(Ny-1); % dy should be equal to dx

% Satisfy CFL condition
c = 1; % speed
C = 0.05; % Courant number
dt = C*dx/c;

% field variables
Tn = zeros(Ny,Nx); % temperature
x = linspace(0, Lx, Nx); % x distance
y = linspace(0, Ly, Ny); % y distance

[X,Y] = meshgrid(x,y);

K= ones(Ny, Nx);
K(20:25, 30:35) = 0.0001;

% Initial condition
Tn(:,:) = 0;
t = 0;

% loop
for n = 1:Nt
    Tc = Tn;
    
    t= t+dt;
    % New temperature
    for i = 2:Nx-1
        for j = 2:Ny-1
        Tn(j,i) = Tc(j,i) + ...
            dt*(K(j,i)/rho/cp) * ...
            ((Tc(j,i+1) + Tc(j+1,i) -4*Tc(j,i) + Tc(j,i-1) + Tc(j-1,i))/dx/dx);
        end
    end
    
    % Source term
    Sx = round(5*Nx/Lx);
    Sy = round(5*Ny/Ly);
    if (t<1)
        Tn(Sy, Sx) = Tn(Sy,Sx)+dt*1000/rho/cp;
    end
    
    % Boundary Conditions
    Tn(1,:) = 0;
    Tn(end,:) = 0;  
    Tn(:,1) = 0;
    Tn(:,end) = Tn(:,end-1);
    
    % Visualize
    mesh(x, y, Tn); axis([0, Lx 0, Ly, 0 50]); colormap(jet);
    title(sprintf('Time = %f seconds', t));
    pause(0.01);
    
end
