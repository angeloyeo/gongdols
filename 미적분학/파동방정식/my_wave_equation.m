clear;

%% Domain
% space
Lx = 10;
dx = 0.1;
nx = fix(Lx/dx);
x = linspace(0, Lx, nx);

% Time
T = 20;

%% Field variables
%variables
wn =zeros(nx,1);
wnm1 = wn; % w at time n-1
wnp1 = wn; % w at time n+1

% parameters
CFL = 1; % CFL = c.dt/dx
c = 1;
dt = CFL*dx/c;
total_t = 0:dt:T-dt;

%% Initial Conditions
% wn(1:length(x)/2) = linspace(0,0.5,50);
% wn(length(x)/2+1:end) = linspace(0.5,0,50);

% wn(1:30) = linspace(0,0.5,30);
% wn(31:end) = linspace(0.5,0,70);

wn = 1/2*sin(2*pi*1/20*x) + 1/4*sin(2*pi*1/10*x);
wnp1(:)=wn(:);

%% Time stepping loop
t=0;
while(t<T)
    
    wn([1 end])=0;
    
    % Absorbing boundary conditions
%     wnp(1) = wn(2) + ((CFL-1)/(CFL+1))*(wnp1(2)-wn(1));
%     wnp(end) = wn(end-1) + ((CFL-1)/(CFL+1))*(wnp1(end-1) -wn(end));

    % Solution
    t = t+dt;
    wnm1 = wn; wn = wnp1;
    
    % Source
%     wn(50) = dt^2*20*sin(20*pi*t/T);
    
    for i = 2:nx-1
        wnp1(i) = 2*wn(i) - wnm1(i) ...
            + CFL^2 * (wn(i+1) - 2*wn(i) + wn(i-1));
    end
    
    % Check convergence
    
    % Visualize at selected steps
    
    clf;
    plot(x,wn);
    title(sprintf('t = %.2f', t));
    axis([0 Lx -1 1]);
    shg; pause(0.01);
end


