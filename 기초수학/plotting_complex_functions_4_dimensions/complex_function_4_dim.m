clear all; close all; clc;
real_axis=linspace(-2,2,30);
imag_axis=linspace(-2,2,30);

fz= zeros(length(real_axis),length(imag_axis));
for iter_r=1:length(real_axis)
    for iter_i=1:length(imag_axis)
        z=real_axis(iter_r)+1j*imag_axis(iter_i);
        fz(iter_r,iter_i)=z.^2+1;
    end
end

surf(real_axis,imag_axis,abs(fz'),angle(fz'));
xlabel('Real(f(z))');
ylabel('Imag(f(z))');
zlabel('Mag(f(z))');
% title('z=c^2+1, c=x+jy');
h = colorbar;
ylabel(h, 'Phase(f(z))')
hold on

plot3(real_axis,zeros(size(real_axis)),[real_axis.^2+1],'r','linewidth',5)
