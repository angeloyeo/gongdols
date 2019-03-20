function makebospattern(n,diam,figtype,filename)
%MAKEBOSPATTERN  Random dot pattern for SS / BOS / FS-SS applications
%   MAKEBOSPATTERN(N,D) makes a figure filled with N randomly distributed
%   dots of diameter D for SS (Synthetic Schlieren), BOS (Background-
%   oriented Schlieren) or FS-SS (Free-Surface SS) applications.
%
%   The figure format is portrait (ie, vertical) A4, 210x297 mm, and the
%   particle diameter D is in mm. Typical values are N=50000, D=1.
%
%   MAKEBOSPATTERN(N,D,'b') makes black points on a white ground (by
%   default). MAKEBOSPATTERN(N,D,'w') makes white points on a black ground.
%
%   MAKEBOSPATTERN(N,D,'..',FILENAME) saves the result in a 300-DPI TIFF
%   figure. Use the standard Windows viewer to print the figure.
%
%   Notes:
%     - If you zoom the figure, the particles are not resized: particles
%     are drawn in absolute units (points), while the paper size is in
%     physical units (centimeters).
%     - a 'particle' is a set of 4 concentric circles with increasing (or
%     decreasing) gray levels. The 'particle diameter' D is the diameter of
%     the outer circle; the inner circle has diameter 0.3*D. Depending on
%     the printer quality, the outer circle may not print correctly, so the
%     actual size may appear slightly larger or smaller than the requested
%     size.
%     - for FS-SS applications, see the function SURFHEIGHT for the
%     surface height reconstruction.
%
%   Example:
%      makebospattern(50000,1,'w','myfig');
%
%   See also PRINT, SURFHEIGHT


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.21,  Date: 2009/04/14.
%   This function is part of the PIVMat Toolbox


% History:
% 2006/06/26: v1.00, first version ('makepidpattern')
% 2006/07/03: v1.10, S in mm; black/white option; saves in a TIFF file.
% 2006/07/05: v1.11, no need to set the PaperPosition and Background mode.
% 2007/05/29: v1.12, minor additional statistics
% 2008/09/05: v1.20, now entitled 'makebospattern'; included in PIVMat.
% 2009/04/14: v1.21, help text changed (BOS->SS)


% default values:
if ~exist('n','var'), n=50000; end
if ~exist('diam','var'), diam=1; end
if ~exist('figtype','var'), figtype='b'; end

h=gcf;

% Window size:
set(h,'Position',[360 80 560/sqrt(2) 560]);
set(gca,'Position',[0 0 1 1]);   % location of the figure in the window
set(gca,'PlotBoxAspectRatio',[1/sqrt(2) 1 1]);

% Printing settings:
set(h,'PaperUnits','centimeters');
set(h,'PaperOrientation','portrait');
set(h,'PaperType','A4');
%set(h,'PaperSize',[21 29.7]);
set(h,'PaperPosition',[0 0 21 29.7]);
set(h,'PaperPositionMode','manual');
set(h,'InvertHardcopy','off');   % keep the user background mode

switch lower(figtype),
    case 'b'                      % black points on a white ground
        col{1} = 0.8*ones(1,3);
        col{2} = 0.6*ones(1,3);
        col{3} = 0.4*ones(1,3);
        col{4} = 0 * ones(1,3);
        set(h,'Color',[1 1 1]);
    case 'w'                      % white points on a black ground
        col{1} = 0.4*ones(1,3);
        col{2} = 0.6*ones(1,3);
        col{3} = 0.8*ones(1,3);
        col{4} = 1 * ones(1,3);
        set(h,'Color',[0 0 0]);
end

x=rand(1,n);
y=rand(1,n);

s = diam * 72/25.4;   % diameter, in points units (1 point = 1/72 inch = 25.4/72 mm)
plot(x,y,'o','MarkerFaceColor',col{1},'MarkerEdgeColor',col{1},'Markersize',s);
hold on
plot(x,y,'o','MarkerFaceColor',col{2},'MarkerEdgeColor',col{2},'Markersize',0.7*s);
plot(x,y,'o','MarkerFaceColor',col{3},'MarkerEdgeColor',col{3},'Markersize',0.5*s);
plot(x,y,'o','MarkerFaceColor',col{4},'MarkerEdgeColor',col{4},'Markersize',0.3*s);
hold off

axis off;

%display some info:
disp(' ');
disp('PID pattern parameters:');
switch lower(figtype)
    case 'b'
        disp(['  ' num2str(n) ' black particles on a 210x297 mm (A4) paper']);
    case 'w'
        disp(['  ' num2str(n) ' white particles on a 210x297 mm (A4) paper']);
end
disp(['  Particle diameter = ' num2str(diam) ' mm.']);
disp(['  ' num2str(n/(210*297)) ' particles / mm^2']);
disp(['  filled surface ratio = ' num2str((n*pi*diam^2/4)/(297*210))]);
disp(' ');
disp('Assuming a 1280x1024 camera, with 210 mm = 1024 pixels:');
pdiam = diam/210*1024;
disp(['  particle diameter = ' num2str(pdiam) ' pixels']);
if pdiam<1.3
    disp('  * Warning: particles too small *');
elseif pdiam>4
    disp('  * Warning: particles too big *');
end
ncam = n  * (5/4) / sqrt(2);  % number of particles in a 5/4 camera field (eg, 1280x1024).
ppp = ncam / (1280*1024);
disp(['  ' num2str(ppp) ' particles / pixel^2']);
if ppp>0.2
    disp('  * Warning: high density *');
elseif ppp<0.02
    disp('  * Warning: low density *');
end
disp(' ');

disp('Particles per interrogation window:');
winsize = [6 8 12 16 32 64];
for nws=1:length(winsize)
    ppw (nws) = winsize(nws)^2 * ncam / (1280*1024);
    disp(['  ' num2str(ppw (nws)) ' particles / ' num2str(winsize(nws)) '^2-window']);
end
optws = sqrt(5*(1280*1024)/ncam);
disp(['  Optimal window size: ' num2str(optws,3) '^2']);
dif=abs(ppw-5);
ind=find(dif==min(dif));
disp(['  Closest window size: ' num2str(winsize(ind)) '^2']);
disp(' ');

% save the figure:
if exist('filename','var')
    print('-dtiff','-r500',filename);
    disp(['''' filename ''' saved']);
end

