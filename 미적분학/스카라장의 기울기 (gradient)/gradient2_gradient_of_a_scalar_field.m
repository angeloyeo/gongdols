clear; close all; clc;

% Some data: 
[lon,lat,z] = meshgrid(-0.5:0.1:0.5,-0.5:0.1:0.5,-0.5:0.1:0.5); 
T=20*exp(-lon.^2-lat.^2-z.^2);

% Plot dataset: 
pcolor3(lon,lat,z,T); 
% Add labels: 
xlabel('longitude')
ylabel('latitude')
zlabel('elevation (m)') 
title('temperature or something') 
axis tight
colorbar
%% Gradient
[fx,fy,fz]=gradient(T);

% 위의 수치적 gradient와는 값이 다름.
% 위의 수치적 gradient에서는 위치 간 간격이 미소길이보다는 크기 때문에 차이가 생기는 것으로 생각됨.
% clear fx fy fz
% for i=1:size(T,1)
%     for j=1:size(T,2)
%         for k=1:size(T,3)
%             fx(i,j,k)=(-2)*lon(i,j,k)*exp(-lon(i,j,k)^2-lat(i,j,k)^2-z(i,j,k)^2);
%             fy(i,j,k)=(-2)*lat(i,j,k)*exp(-lon(i,j,k)^2-lat(i,j,k)^2-z(i,j,k)^2);
%             fz(i,j,k)=(-2)*z(i,j,k)*exp(-lon(i,j,k)^2-lat(i,j,k)^2-z(i,j,k)^2);
%         end
%     end
% end


hold on;
quiver3(lon,lat,z,fx,fy,fz);