clear all; close all; clc;
real_axis=linspace(-2,2,30);
imag_axis=linspace(-pi,pi,30);

fz= zeros(length(real_axis),length(imag_axis));
for iter_r=1:length(real_axis)
    for iter_i=1:length(imag_axis)
        z=real_axis(iter_r)+1j*imag_axis(iter_i);
        fz(iter_r,iter_i)=exp(z);
    end
end

surf(real_axis,imag_axis,abs(fz'),angle(fz'));
xlabel('Real(f(z))');
ylabel('Imag(f(z))');
zlabel('Mag(f(z))');
h = colorbar;
ylabel(h, 'Phase(f(z))')
hold on

plot3(real_axis,zeros(size(real_axis)),abs(exp(real_axis)),'r','linewidth',5)
