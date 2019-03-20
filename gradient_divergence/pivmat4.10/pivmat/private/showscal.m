function fr=showscal(f,varargin)
%SHOWSCAL  Display scalar field(s)
%   See SHOWF for the documentation of this command

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 2.70,  Date: 2017/02/01
%   This function is part of the PIVMat Toolbox


% History:
% 2004/04/01: v1.00, first version.
% 2004/06/22, v1.01, changed help text
% 2004/07/29, v1.02, added option 'pause'
% 2004/09/30, v1.03, bug min/max fixed and contours added
% 2005/02/03, v1.04, cosmetics
% 2005/02/07, v1.05, displays the name of the field in the title
% 2005/02/09, v1.06, bug corrected about 'name' and 'setname'
% 2005/02/24, v1.07, added texunderscore for the title
% 2005/05/25, v1.08, cosmetics.
% 2005/09/02, v1.09, arg check added.
% 2005/09/09, v1.10, SHOWSCAL returns the movie only if asked (save time);
% 2005/10/02, v1.20, the unit is displayed in the colorbar Y-Label. The
%                    name of the field is displayed using Latex syntax.
% 2005/10/06, v1.21, option 'name' suppressed (redundant with ~'notitle')
% 2005/10/11, v1.22, new syntax showscal('file_name');
% 2005/10/14, v1.23, bug fixed texunderscore
% 2005/10/18, v1.24, pause mode improved; texliteral replaces texunderscore
% 2005/10/21: v1.25, bug Y-axis up/down-ward fixed
% 2006/05/30: v1.26, white borders
% 2006/07/13: v2.00, New syntax. New options 'CLim', 'Loop', 'Back',
%                    'Surfl', 'Mesh'. Pause and exit during a movie.
% 2006/07/??: v2.01, new option 'keepcamerasettings'
% 2006/10/20: v2.02, modal window
% 2006/10/30: v2.10, new key press control. Exit if the window is closed.
%                    new option 'title' ('notitle' removed)
% 2006/11/03, v2.11, frame number displayed only if >1.
% 2007/01/04, v2.12, title format changed (% instead of \)
% 2007/04/05: v2.13, do not set figure to 'modal' if it is docked
% 2007/04/12: v2.20, new option 'colormap', and '%t0' in title
% 2007/05/21: v2.21, if scalar field is a .IMX or .IM7 file, use 'colormap
%                    gray by default.
% 2007/06/08: v2.22, new option 'command'
% 2007/06/21: v2.30, new key press control : / and *. New command 'ampclim'
% 2008/07/26: v2.40, bugs fixed:  - colorbar limits correctly taken for
%                    contour and contourf
% 2008/08/16: v2.50, (x,y) aspect ratio fixed for 3D figures
%                    'keepcamarasettings' removed, 'resetcamerasettings'
%                    added. Camera can be moved during a movie.
% 2008/09/11: v2.51, bug fixed when the bounds of the colormap were equal
% 2009/11/17: v2.52, bug fixed for 'clim','each'
% 2010/05/04: v2.53, texliteral removed for titles
% 2011/04/01, v2.54, does not display setname if empty
% 2012/07/05: v2.60, all the help text is now given in SHOWF.
% 2013/01/06: v2.61, now title in mode 'interpreter none'
% 2017/01/31: v2.62, if scalar field is AVI or MP4, use colormap gray
% 2017/02/01: v2.70, new option 'savevideo'
% 2017/02/27: v2.71, uses gray colormap for images converted from im2pivmat


modalwindow = false;  % new v2.02

if nargin==0
    f = loadvec;
    if isempty(f)
        return
    end
end

if (ischar(f) || iscellstr(f) || isnumeric(f))
    f = loadvec(f);
end

if isfield(f,'vx')
    f = vec2scal(f,'norm');
end


%  Handle 2D/3D graphics

h=gcf;   % handle to the current window (create one if no window)
figure(h); % brings to front, new v2.13
set(h,'Color',[1 1 1]); % added v1.30

% true if a 3D figure, false for a 2D figure  (new v2.50)
Fig3D = any(strncmpi('surf',varargin,4)) || ...
    any(strncmpi('mesh',varargin,4)) || ...
    any(strcmpi('contour3',varargin));

% if the actual and previous figure are both 3D, keep the camera settings
% (except if option 'resetcamerasettings' is present)
if Fig3D && strcmpi(get(h,'UserData'),'PivMat3DFig') && ~any(strncmpi(varargin,'resetcamerasettings',5))
    cp = get(gca,'CameraPosition');
    cuv = get(gca,'CameraUpVector');
    cva = get(gca,'CameraViewAngle');
    view = get(gca, 'View');
end

% Set the 'UserData' field for a 3D Fig
if Fig3D
    set(h,'UserData','PivMat3DFig');
else
    set(h,'UserData','PivMat2DFig');
end

% The bounds of the color map are specified after the property 'clim',
% or as the 2nd input argument:
bound = 0; % default value
if any(strncmpi(varargin,'clim',4))
    bound = varargin{1+find(strncmpi(varargin,'clim',4),1,'last')};
elseif any(strncmpi(varargin,'ampclim',4))  % new v2.30
    ampl = varargin{1+find(strncmpi(varargin,'ampclim',4),1,'last')};
    bound = [mean(f(1).w(:))-ampl mean(f(1).w(:))+ampl];
else
    if nargin>=2
        bound = varargin{1};   % {1} is the second input argument
    end
end
if ~isnumeric(bound)
    if strncmpi(bound,'each',2)
        bound=-1;
    else
        bound=0;
    end
end

if length(bound)>1   % when an interval is specified
    min_sf=bound(1);
    max_sf=bound(2);
else
    if bound==0     % normalise with all the frames (option 'all')
        max_sf = max(max(abs([f.w])));
        min_sf = min(min([f.w]));
        if min_sf<0
            max_sf = max([abs(max_sf) abs(min_sf)]);
            min_sf = -max_sf;
        elseif (max_sf - min_sf) < max_sf/5   % new 2.21
            av = mean(mean(abs([f.w])));
            di = max([max_sf-av, av-min_sf]);
            max_sf = av+di;
            min_sf = av-di;
        else
            min_sf = 0;
        end
    elseif bound>0             % if a single positive number is given
        if min(f(1).w(:))<0
            min_sf = -bound;  % use [-bound bound] is S is a signed field
        else
            min_sf = 0;       % use [0 bound] is S is a non-negative field
        end
        max_sf = bound;
    else
        bound=-1;  % normalise with each frame (option 'each')
    end
end

% new v2.51 (bug when bounds are equal), fixed 2.52
if bound>=0
    if min_sf==max_sf
        min_sf=min_sf-1;
        max_sf=max_sf+1;
    end
end

%  number of contour lines
if any(strncmpi(varargin,'contour',4)),
    try
        ncont = varargin{1+find(strncmpi(varargin,'contour',4),1,'last')};
    catch
        ncont=8;
    end
    if ~isnumeric(ncont),
        ncont = 8;
    end
end


% commands to be executed during movie
commandstring = '';
if any(strncmpi(varargin,'command',3))  % new v2.22
    commandstring = varargin{1+find(strncmpi(varargin,'command',3),1,'last')};
end

% save video (new v2.70)
videoobject = [];
if any(strncmpi(varargin,'savevideo',3))
    videoobject = varargin{1+find(strncmpi(varargin,'savevideo',3),1,'last')};
    open(videoobject);
end

% add scalar profiles embedded in the figure (v2.71)
if any(strncmpi(varargin,'vprofile',4))
    x0v = varargin{1+find(strncmpi(varargin,'vprofile',4),1,'last')};
    for k=1:length(x0v)
        [i0v(k),j0v] = matrixcoordf(f(1), x0v(k), f(1).y(1));
    end
end
if any(strncmpi(varargin,'hprofile',4))
    y0h = varargin{1+find(strncmpi(varargin,'hprofile',4),1,'last')};
    for k=1:length(y0h)      
        [i0h,j0h(k)] = matrixcoordf(f(1), f(1).x(1), y0h(k));
    end
end

%colormap
cmap='jet';    % default colormap
if ~isempty(strfind(f(1).name,'.im')) | ~isempty(strfind(f(1).name,'.avi')) | ~isempty(strfind(f(1).name,'.mp4'))
    cmap='gray';   % colormap gray for IM7/IMX fields (new 2.21)
end
if isfield(f(1),'source')
    if ~isempty(strfind(f(1).source,'image'))
        cmap='gray';
    end
end
 
if any(strncmpi(varargin,'cmap',2))
    try
        cmap = varargin{1+find(strncmpi(varargin,'cmap',2),1,'last')};
    catch
        cmap = 'jet';
    end
end

pausemode = any(strncmpi(varargin,'pause',2));



% Default title (new v2.10, changed v2.11 & 2.54)
if length(f)==1
    if isempty(f.setname)
        tit='%n';
    else
        tit='%s/%n';
    end
else
    tit = '%s [#%i]';
end
%tit = '%s/%n [#%i]'; % default title in PIVMAT 1.51: 'setname/name [#frame]'
%tit = '%n, t = %t s [#%i]'; % other example for title: 'name, t = time s [#frame]'
%tit = '%s [#%i], t = %t s'; % other example for title: 'setname [#frame], t = time s'
if any(strncmpi(varargin,'title',3))
    tit = varargin{1+find(strncmpi(varargin,'title',3),1,'last')};
end

%new v2.20:
if strfind(tit,'%t0')
    timf=getpivtime(f,'0');
    tit=strrep(tit,'%t0','%t');
elseif strfind(tit,'%t')
    timf=getpivtime(f);
end

if any(strncmpi(varargin,'backward',5))
    i=length(f);
    incr=-1;
else
    i=1;
    incr=1;
end

i_go = 1; %default value for the 'jump' dialog (new v2.02)



% empty the character buffer (for pause mode), new v1.27
if length(f)>1
    set(h,'CurrentCharacter',char(0));
end

exit=false;
firstframe=true;
while ~exit
    if bound==-1
        max_sf=max(max(abs(f(i).w)))/1.5;
        min_sf=min(min(f(i).w));
        if min_sf<0, min_sf=-max_sf; end
    end
    
    % exit if the window has been closed (new v2.10)
    if ~ishandle(h)
        return
    end
    
    if any(strcmpi(varargin,'contour'))
        contour(f(i).x, f(i).y, f(i).w', linspace(min_sf, max_sf, ncont));
        caxis([min_sf max_sf]);
    elseif any(strcmpi(varargin,'contourf'))
        contourf(f(i).x, f(i).y, f(i).w', linspace(min_sf, max_sf, ncont));
        caxis([min_sf max_sf]);
    elseif any(strcmpi(varargin,'contour3'))
        contour3(f(i).x, f(i).y, f(i).w', linspace(min_sf, max_sf, ncont));
        %surface(f(i).x, f(i).y, f(i).w','EdgeColor',[.8 .8 .8],'FaceColor','none')
    elseif any(strcmpi(varargin,'surfc'))
        surfc(f(i).x, f(i).y,  f(i).w');
    elseif any(strcmpi(varargin,'surf'))
        surf(f(i).x, f(i).y, f(i).w');
    elseif any(strcmpi(varargin,'surfl'))
        surfl(f(i).x, f(i).y, f(i).w');
    elseif any(strcmpi(varargin,'mesh'))
        mesh(f(i).x, f(i).y, f(i).w');
    elseif any(strcmpi(varargin,'meshc'))
        meshc(f(i).x, f(i).y, f(i).w');
    else
        imagesc(f(i).x,f(i).y,f(i).w',[min_sf max_sf]);
    end
    
    if Fig3D
        shading interp
        axis([min(f(i).x) max(f(i).x) min(f(i).y) max(f(i).y) min_sf max_sf]);
        zlabel([f(i).namew ' (' f(i).unitw ')']);
        % Fix the (x,y) aspect ratio (new v2.50)
        ar =get(gca,'DataAspectRatio');
        ar(1:2) = min(ar(1:2));
        set(gca,'DataAspectRatio',ar);
    else
        axis image
        hc=colorbar; % changed v1.20
        set(get(hc,'YLabel'),'String',[namefield(f(i).namew) ' (' f(i).unitw ')']);
    end
    
    colormap(cmap); % new v2.20
    
    %new v2.01, modified v2.50
    if exist('cp','var')
        set(gca, 'CameraPosition', cp, 'CameraUpVector', cuv, 'CameraViewAngle', cva, ...
            'View', view); % new v2.01
    end
    
    % new v1.25
    if isfield(f(i),'ysign')
        if strfind(f(i).ysign,'upward')
            axis xy;
        else
            axis ij;
        end
    else
        error('PIVMat:showscal:oldFileFormat',...
            'Y axis orientation not defined. Please reload the vector field with loadvec.');
    end
    
    % add scalar profil embedded in the figure (v2.71)
    if any(strncmpi(varargin,'vprofile',4))
        for k=1:length(i0v)
            ratio(k) = 0.1*(f(i).x(end)-f(i).x(1)) / max(abs(f(i).w(i0v(k),:)));
        end
        ratio = min(ratio);
        hold on
        for k=1:length(i0v)
            plot(x0v(k) + ratio*f(i).w(i0v(k),:), f(i).y, 'r-');
            plot(x0v(k) + 0    *f(i).w(i0v(k),:), f(i).y, 'r-');
        end
        hold off
    end
    if any(strncmpi(varargin,'hprofile',4))
        for k=1:length(j0h)
            ratio(k) = 0.1*(f(i).y(end)-f(i).y(1)) / max(abs(f(i).w(:,j0h(k))));
        end
        ratio = min(ratio);
        if strfind(f(1).ysign,'down'), ratio=-ratio; end
        hold on
        for k=1:length(j0h)
            plot(f(i).x, y0h(k) + ratio*f(i).w(:,j0h(k)), 'g-');
            plot(f(i).x, y0h(k) + 0    *f(i).w(:,j0h(k)), 'g-');
        end
        hold off
    end
    
    xlabel([f(i).namex ' (' f(i).unitx ')']);
    ylabel([f(i).namey ' (' f(i).unity ')']);
    
    % title of the figure
    titdisp=tit;
    titdisp = strrep(titdisp,'%s', (f(i).setname));  % changed v2.53
    titdisp = strrep(titdisp,'%n', (f(i).name));
    if findstr(titdisp,'%t')  %changed v2.20
        titdisp = strrep(titdisp,'%t', num2str(timf(i),'%6.3f'));
    end
    titdisp = strrep(titdisp,'%i', num2str(i));
    title(titdisp,'interpreter','none');  % changed v2.61
    
    if pausemode && (length(f)>1) % new v2.10
        set(h,'name','*Paused*');
    else
        set(h,'name','');
    end
    
    if ~isempty(commandstring)   % new v2.22
        eval(commandstring);
    end
    
    if length(f)>1 % refresh only for a movie; don't refresh still images
        if modalwindow && ~strcmpi(get(h,'WindowStyle'),'docked')
            set(h,'WindowStyle','modal'); % new v2.03, modified v2.13
        end
        drawnow;
        
        % small temporisation, to allow Windows to recognize the new window
        % (otherwise the key control of the movie does not work). v2.10
        if firstframe
            pause(0.1);
            firstframe=false;
        end
    end
    
    % save movie (old method, obsolete in Matlab 2016)
    if nargout   
        fr(i) = getframe(h);  % use this command to include the legends in the movie
        %fr(i)=getframe;  % use this command to NOT include the legends in the movie
    end
    
    % save frame, new method (new v2.70)
    if ~isempty(videoobject)
        writeVideo(videoobject, getframe(h));
    end
    
    if length(f)==1
        exit=true;  % for a single image
    else
        if pausemode
            try % an error occurs if the window is closed.
                waitforbuttonpress;
            catch
                return
            end
        end
        try % an error occurs if the window is closed.
            key=double(get(h,'CurrentCharacter'));
            set(h,'CurrentCharacter',char(0));
        catch
            return
        end
        if ~isempty(key)
            switch key
                case {29,31,13,110} % arrows right or down, keys 'enter' or 'n'
                    i=i+incr;
                    pausemode = true;
                case {28,30,98} % arrows left or up, and key 'b'
                    i=i-incr;
                    pausemode = true;
                case {3,27,113,120} % keys 'esc', 'x', 'q'
                    exit = true; % force to quit the while loop
                case {106,103}  % key 'j','g' (jump, go)
                    i_go = str2double(inputdlg('Jump to frame #','Jump to frame #',1,{num2str(i_go)}));
                    if ~isempty(i_go) && isnumeric(i_go)
                        i = i_go;
                    end
                case {47}  % key '/'   % new V2.3
                    if min_sf>0
                        [max_sf, min_sf] = stretchclim(max_sf, min_sf, 2);
                    else
                        max_sf = max_sf/2;
                        min_sf = min_sf/2;
                    end
                case {42} % key '*'
                    if min_sf>0
                        [max_sf, min_sf] = stretchclim(max_sf, min_sf, 1/2);
                    else
                        max_sf = max_sf*2;
                        min_sf = min_sf*2;
                    end
                case 32   % space bar: toggle pausemode
                    pausemode = ~pausemode;  % switch between pause and not-pause modes
            end
        else % if no key pressed, simply go to the next frame
            i=i+incr;
        end
        
        % border confitions:
        if i>length(f)
            if any(strncmpi(varargin,'loop',2))
                i=1; % go back to the first frame
            else
                exit=true;
            end
        end
        if i==0
            if any(strncmpi(varargin,'loop',2))
                i=length(f); % go to the last frame
            else
                exit=true;
            end
        end
        
        % Delay (in sec.)
        if any(strncmpi(varargin,'delay',3)),
            nsec = varargin{1+find(strncmpi(varargin,'delay',3),1,'last')};
            if isnumeric(nsec)
                pause(nsec);
            end
        end
        
    end
    
    % if camera moved during a movie, store the new camera settings (new
    % v2.50)
    if exist('cp','var')
        cp = get(gca,'CameraPosition');
        cuv = get(gca,'CameraUpVector');
        cva = get(gca,'CameraViewAngle');
        view = get(gca, 'View');
    end
end

if ~isempty(videoobject)
    close(videoobject);
end

if strcmpi(get(h,'WindowStyle'),'modal')
    set(h,'WindowStyle','normal'); % new v2.02, modified v2.13
end


%%%%%%%%%%%%%%%%%%

function estr=namefield(str)  % new v1.20
switch lower(str)
    case 'norm', estr='|u_x^2 + u_y^2|^{1/2}';
    case 'ux', estr='u_x';
    case 'uy', estr='u_y';
    case {'curl','rot'}, estr='\omega'; %'\omega_z';
    case 'div', estr='\partial u_x/\partial x + \partial u_y/\partial y';
    otherwise, estr=str;
end



%%%%%%%%%%%%%%%%%%

function [newmax_sf, newmin_sf] = stretchclim(max_sf, min_sf, climratio) % new v1.30
newmax_sf = ((1+climratio)*max_sf + (1-climratio)*min_sf)/2;
newmin_sf = ((1-climratio)*max_sf + (1+climratio)*min_sf)/2;
