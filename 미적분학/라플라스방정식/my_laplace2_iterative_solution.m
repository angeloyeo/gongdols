clear; close all; clc;

% create a blank scalar field
Nx = 25;
T = nan(Nx,Nx);
T(1,2:end-1)=0;
T(end,2:end-1) = 100;
T(2:end-1,1) = 0;
T(2:end-1,end) = 0;

T(2:end-1, 2:end-1)=0;

for k = 1:1000
    Tp = T;
    for x=2:Nx-1
        for y = 2:Nx-1
            T(x,y) = 0.25*(T(x+1,y) + T(x-1,y) + T(x,y+1) + T(x, y-1));
        end
    end
    
    E = T-Tp;
    e = mean(mean(E(2:end-1,2:end-1).^2));
    surf(T)
    xlim([0 25])
    ylim([0 25])
    zlabel('temperature ''c');
    disp([k e])
    if (e < 1e-3); break; end
    if k == 1
        pause(0.5)
    else
        pause(0.01)
    end
end
