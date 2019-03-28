function plot_curls(nr,ntheta,a)
[img,map] = imread('curl_color.png','png');
img_rgb = ind2rgb(img,map);
% [~,~,alpha] = imread('curl_photoshop.png');

for ir = 1:nr
    for itheta = 1:ntheta
        r = linspace(1/nr*(ir-1),1/nr*ir,100);
        theta = linspace(2*pi/ntheta*(itheta-1),2*pi/ntheta*itheta,100);
        
        [R,T]=meshgrid(r,theta);
        x = R.*cos(T);
        y = R.*sin(T);
        
        z = surface_fun(x,y,-a);
        
        warp(x,y,z,img_rgb);
        hold on
%         set(gcf,'renderer','opengl');
%         set(h,'FaceAlpha',  'texturemap', 'AlphaDataMapping', 'scaled', 'AlphaData',alpha);
    end
end
hold off;
end
