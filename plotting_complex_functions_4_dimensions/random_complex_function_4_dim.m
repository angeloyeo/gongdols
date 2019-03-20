clear all; close all; clc;
real_axis=linspace(-2,2,30);
imag_axis=linspace(-2,2,30);

fz= zeros(length(real_axis),length(imag_axis));
for iter_r=1:length(real_axis)
    for iter_i=1:length(imag_axis)
        z=real_axis(iter_r)+1j*imag_axis(iter_i);
        fz(iter_r,iter_i)=100*z./(z.^2+1);
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

plot3(real_axis,zeros(size(real_axis)),abs(100*real_axis./(real_axis.^2+1)),'r','linewidth',5)

% r = (0:0.025:1)';                        % create a matrix of complex inputs
% theta = pi*(-1:0.05:1);
% z = r*exp(1i*theta);
% w = z.^3;                                % calculate the complex outputs
% 
% surf(real(z),imag(z),real(w),imag(w))    % visualize the complex function using surf
% xlabel('Real(z)')
% ylabel('Imag(z)')
% zlabel('Real(w)')
% cb = colorbar;
% cb.Label.String = 'Imag(w)';