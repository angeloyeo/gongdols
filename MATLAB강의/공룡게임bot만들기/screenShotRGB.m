function im = screenShotRGB(x0,y0,widthSS, heightSS)
%screenShotRGB  Make a screenshot using Java.
%   im = screenShotRGB; make a screen capture of the entire screen, it returns
%   a RGB color image  with 'uint8' class elements.
%   im = screenShotRGB(x0,y0,widthSS, heightSS); makes a screenshot of the
%   rectangle defined by the botton-left point (x0, y0) in the screen
%   coordinates, and its width, and its height.
%
%   For example, make a screen shot of the entire screen, plot and save it to a
%   file:
%     im = screenShotRGB; % make the screenshot
%     imwrite(im,'screenShot.png');
%     figure
%     image(im);
%     axis equal, axis tight
%     axis off
% 
%   screenShotRGB use the Java class 'Robot' to make the capture.

%   For more information about the Robot class see
%   http://www.mathworks.com/support/solutions/en/data/1-90E06C/?solution=1-90E06C
%   http://download.oracle.com/javase/1.4.2/docs/api/java/awt/Robot.html#cr
%   eateScreenCapture%28java.awt.Rectangle%29

%   Matlab version by Daniel Mena 12-2009.


trash = java.awt.Toolkit.getDefaultToolkit();
screenSize = trash.getScreenSize();
widthScreen = screenSize.getWidth();
heightScreen = screenSize.getHeight();
if nargin == 0
    x0 = 0;
    y0 = 0;
    widthSS = widthScreen;
    heightSS = heightScreen;
else
% % 
%     if (widthSS+x0 > (widthScreen)) || (heightSS+y0 > (heightScreen))
%         error('Rectangle is outside the screen.');
%     end
%     if (x0 > widthScreen) || (y0 > heightScreen)
%         error('Origin of the Rectangle is outside the screen.')
%     end  
%     if (x0 < 0) || (y0 < 0)
%         error('x0 and y0 must be  positive.')
%     end
% %     y0=heightScreen-(heightSS+y0);
end       
im = zeros(heightSS,widthSS,3,'uint8');
r = java.awt.Robot;
bimg = r.createScreenCapture(java.awt.Rectangle(x0, y0, widthSS, heightSS));
RGBA = bimg.getRGB(0,0,widthSS,heightSS,[],0,widthSS); % RGBA has int32 elements
RGBA = typecast(RGBA, 'uint8');

im(:,:,1) = reshape(RGBA(3:4:end),widthSS,heightSS).';
im(:,:,2) = reshape(RGBA(2:4:end),widthSS,heightSS).';
im(:,:,3) = reshape(RGBA(1:4:end),widthSS,heightSS).';
