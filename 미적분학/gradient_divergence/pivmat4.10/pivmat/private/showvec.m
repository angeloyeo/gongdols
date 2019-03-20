function mov=showvec(f,varargin)
%SHOWVEC  Display vector field(s)
%   See SHOWF for the documentation of this command

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 3.10,  Date: 2017/02/10
%   This function is part of the PIVMat Toolbox


% History:
% 2004/04/01: v1.00, first version.
% 2004/06/22: v1.10, changed axis, and added the option 'bound'
% 2004/06/29, v1.11, syntax bug fixed
% 2004/02/07: v1.12, displays the name and setname in the title.
% 2004/02/09: v1.13, bug corrected about 'name' and 'setname'
% 2005/02/18: v1.14, changed title
% 2005/02/24: v1.15, added texunderscore for the title
% 2005/09/01: v1.16, cosmetics.
% 2005/09/09: v1.20, SHOWVEC returns the movie only if asked (save time);
%                    NPT can be in the form [NPTX, NPTY];
% 2005/09/28: v1.21, syntax SHOWVEC(FILENAME) allowed.
% 2005/10/03: v1.22, title shortened (showscal v1.11 now displays the units
%                    in the colorbar Y-Label). bug "axis ij" fixed.
% 2005/10/04: v1.23, option SA added.
% 2005/10/18: v1.24, option 'pause' added in bgmode; texliteral replaces
%                    texunderscore
% 2005/10/21: v1.25, bug Y-axis up/down-ward fixed. mode='' means no bg
% 2005/12/20: v1.26, bug fixed with bounds.
% 2006/03/10: v1.27, accepts numeric input (call loadvec)
% 2006/04/28: v1.28, minor changes (argument check)
% 2006/05/19: v1.29, bug fixed (showvec turned the other figures with black
%                    lines)
% 2006/05/30: v1.30, white borders
% 2006/07/13: v2.00, new syntax, with 'PropertyName', PropertyValue
% 2006/07/26: v2.01, checks for the field 'vx'
% 2006/09/18, v2.02, new option 'jump'
% 2006/10/20, v2.03, modal window
% 2006/10/29, v2.10, new key press control. Exit if the window is closed.
%                    new option title
% 2006/11/03, v2.11, frame number displayed only if >1.
% 2007/01/04, v2.12, title format changed (% instead of \)
% 2007/04/05, v2.13, do not set figure to 'modal' if it is docked
% 2007/04/12: v2.20, new options 'colormap', 'colorvec', and '%t0' in title
% 2007/07/13: v2.21, new option 'smin'
% 2007/07/27: v2.22, new option 'lups'
% 2008/07/11: v2.23, new quiver_nozero (does not work for the moment)
% 2009/02/18: v2.24, new 'streamline'
% 2009/12/01: v2.30, absolute scaling of the length of the velocity vectors
% 2009/12/10: v2.31, new options Reynolds stress tensors
% 2010/01/19, v2.32, added 'interpreter none'
% 2011/03/25, v2.33, also accepts 'uz','vz','u' and 'v'
% 2011/04/01, v2.34, does not display setname if empty
% 2012/05/31, v2.35, remove the 'modalwindow' feature (introduced in
%                    v2.03), which caused blinking of non-docked windows
% 2012/07/06, v2.40, new key control: + and - to change the scale arrow
%                    (for Antoine!). All the doc is now given in SHOWF.
% 2012/11/09, v2.50, now quiver works in 'Autoscale off' mode.
%                    option 'scalemode' removed
% 2013/02/22, v3.00, works with 3D fields
% 2015/08/27, v3.01, added eps2D, eps3d, epsaxi
% 2016/04/26: v3.02, scalearrow<0 does not display the arrows
% 2017/02/10: v3.10, new option 'savevideo'

modalwindow = false; % new v2.03 ; changed v2.35

if nargin==0
    f = loadvec;
    if isempty(f)
        return
    end
end

if (ischar(f) || iscellstr(f) || isnumeric(f))
    f = loadvec(f);
end

if ~isfield(f(1),'vx') % new v2.01
    error('PIVMat:showvec:invalidArgument','The input is not a vector field');
end

% The background mode is specified after the property 'Background',
% or as the 2nd input argument:
listbgmode = {'','off','norm','norm2d','norm3d','ux','uy','uz','vx','vy','vz','u','v','w','ken','angle','rad','deg',...
    'curl', 'rot',  'absrot', 'div', 'ens', 'strain', 'duxdx', 'duxdy', 'duydx', 'duydy', 'duzdx', 'duzdy', 'q',...
    'curl1','rot1', 'absrot1','div1','ens1','strain1','eps1','duxdx1','duxdy1','duydx1','duydy1','duzdx1', 'duzdy1','q1',...
    'smin','lups','txx','txy','tyx','tyy','tzz','tyz','tzy','txz','tzx','ux2','uy2','uz2',...
    'uxuy','uyux','uxuz','uzux','uyuz','uzuy','uxux','uyuy','uzuz',...
    'tauxx','tauxy','tauyx','tauyy','tauzz','tauxz','tauzx','tauyz','tauzy',...
    'eps','epsilon','eps2d','eps3d','epsaxi',...
    };
if isfield(f(1),'vz') % default value (new v3.00)
    bgmode = 'uz';
else
    bgmode = 'norm'; 
end
if any(strncmpi(varargin,'background',5))
    pbg = find(strncmpi(varargin,'background',5),1,'last');
    if nargin>(pbg+1)
        if any(strcmpi(listbgmode, varargin{1+pbg}))
            bgmode = varargin{1+pbg};
        end
    end
else
    if nargin>=2 % background specified as the 2nd argument
        if any(strcmpi(listbgmode, varargin{1}))
            bgmode = varargin{1};
        end
    end
end
if isempty(bgmode)
    bgmode = 'off';
end

% The Arrow Spacing is specified after the property 'Spacing',
npt = ceil(min([length(f(1).x) length(f(1).y)])/32); % default value
if any(strncmpi(varargin,'spacing',4))
    npt = varargin{1+find(strncmpi(varargin,'spacing',4),1,'last')};
end
if ~isnumeric(npt)
    error('PIVMat:showvec:invalidArgument','Unexpected value after the property ''Spacing''');
end
if length(npt)==1, npt=[npt npt]; end


% Streamline (v2.24):
if any(strncmpi(varargin,'streamline',6))
    try
        stepsl = varargin{1+find(strncmpi(varargin,'streamline',6),1,'last')};
    catch
        stepsl = 16;
    end
    if length(stepsl)==1, stepsl=[stepsl stepsl]; end
    
    [msx,msy] = meshgrid(f(1).x,f(1).y);
    [sx,sy] = meshgrid(f(1).x(1:stepsl(1):end),f(1).y(1:stepsl(2):end));
    
    % code to send starting points on the left and right borders:
    %vect = f(1).y(1:stepsl:end);
    %sy = [vect vect];
    %sx = [f(1).x(1)*ones(1,numel(vect)) f(1).x(end)*ones(1,numel(vect))];
end


% The colormap is specified after the property 'clim'
bound = 0; % default value: option 'all'
if any(strncmpi(varargin,'clim',4))
    bound = varargin{1+find(strncmpi(varargin,'clim',4),1,'last')};
end
if ~isnumeric(bound)
    if strcmpi(bound,'all'),
        bound=0;
    end
end

% Background field
if ~strcmpi(bgmode, 'off')
    bgfield = vec2scal(f, bgmode);
    if bound==0,
        max_sf = max(max(abs([bgfield.w]))); % normalised 1.5 removed (v1.23)
        min_sf = min(min([bgfield.w]));
        if min_sf<0,
            min_sf = -max_sf;
        end
        bound = [min_sf max_sf];
    end
end

% Arrow scaling (new behavior since v2.50):
sa = 0; % defaut
if any(strncmpi(varargin,'scalearrow',7))
    sa = varargin{1+find(strncmpi(varargin,'scalearrow',7),1,'last')};
end
if sa == 0
    sa = 4*npt(1)/max([ max(max(abs([f.vx]))) max(max(abs([f.vy]))) ]);
end

% Arrow color:
cvec='k'; % default value
if any(strncmpi(varargin,'colorvec',6))
    cvec = varargin{1+find(strncmpi(varargin,'colorvec',6),1,'last')};
end

% save video (new v3.10)
videoobject = [];
if any(strncmpi(varargin,'savevideo',3))
    videoobject = varargin{1+find(strncmpi(varargin,'savevideo',3),1,'last')};
    open(videoobject);
end

% Default title (new v2.10, changed v2.11 & 2.34)
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
%tit = '%s [#%i], t = \% s'; % other example for title: 'setname [#frame], t = time s'
if any(strncmpi(varargin,'title',3)),
    tit = varargin{1+find(strncmpi(varargin,'title',3),1,'last')};
end

%new v2.20:
if strfind(tit,'%t0')
    timf=getpivtime(f,'0');
    tit=strrep(tit,'%t0','%t');
elseif strfind(tit,'%t')
    timf=getpivtime(f);
end

%collect the parameters to be passed to showscal (changed v2.20, v2.24):
allowedparam={'contour','contourf','cmap'};
numparamtopass=0;
paramtopass={};
for parnum=1:length(allowedparam)
    if any(strcmpi(varargin,allowedparam(parnum)))
        numparamtopass = numparamtopass+1;
        ppar = find(strcmpi(varargin,allowedparam(parnum)),1,'last');
        paramtopass{numparamtopass} = varargin{ppar};
        if nargin>=ppar+1
            numparamtopass = numparamtopass+1;
            paramtopass{numparamtopass} = varargin{ppar+1};
        end
    end
end

pausemode = any(strncmpi(varargin,'pause',2));

if any(strncmpi(varargin,'backward',5))
    i=length(f);
    incr=-1;
else
    i=1;
    incr=1;
end

i_go = 1; %default value for the 'jump' dialog (new v2.02)

h=gcf;   % handle to the current window (create one if no window)
figure(h); % brings to front, new v2.13
set(h,'Color',[1 1 1]); % added v1.30
    
% empty the character buffer (for pause mode)
set(h,'CurrentCharacter',char(0));


exit=false;
firstframe=true;
while ~exit    
    if ~strcmpi(bgmode, 'off'),
        showscal(bgfield(i),'title','','clim',bound,paramtopass{:});
        hold on;
    end
    
    [mx,my] = meshgrid(f(i).x,f(i).y);
    mx = mx(1:npt(2):size(mx,1), 1:npt(1):size(mx,2));
    my = my(1:npt(2):size(my,1), 1:npt(1):size(my,2));
    
    vec_x = f(i).vx(1:npt(1):size(f(i).vx,1), 1:npt(2):size(f(i).vx,2));
    vec_y = f(i).vy(1:npt(1):size(f(i).vy,1), 1:npt(2):size(f(i).vy,2));
    
    % exit if the window has been closed (new v2.10)
    if ~ishandle(h)
        return
    end
    
    % scale behaviour modified in v2.50:
    if sa>0  % new v3.02
        quiver_nozero(mx,my,sa*vec_x',sa*vec_y','AutoScale','off');
    end
    
    % turns the color of the vector arrows to color specified by cvec
    set(findobj(h,'Type','line'),'Color',cvec);
    
    axis([min(f(i).x) max(f(i).x) min(f(i).y) max(f(i).y)]);
    if isempty(bgmode) || isequal(bgmode,'off')
        axis image
    end % changed v1.25
    xlabel([f(i).namex ' (' f(i).unitx ')']);
    ylabel([f(i).namey ' (' f(i).unity ')']);
    
    % streamlines (new v2.24)
    if any(strncmpi(varargin,'streamline',6))
        streamline(msx,msy,f(i).vx', f(i).vy',sx,sy);
    end

    % new v1.25
    if isfield(f(i),'ysign')
        if strfind(f(i).ysign,'upward'),
            axis xy;
        else
            axis ij; % matrix mode (natural mode for DaVis)
        end
    else
        error('PIVMat:showvec:oldFileFormat',...
            'Y axis orientation not defined. Please reload the vector field with loadvec.');
    end

    if ~strcmpi(bgmode, 'off'),
        hold off;
    end % changed v1.22

    % title of the figure
    titdisp=tit;
    titdisp = strrep(titdisp,'%s', f(i).setname);
    titdisp = strrep(titdisp,'%n', f(i).name);
    if findstr(titdisp,'%t')  %changed v2.20
        titdisp = strrep(titdisp,'%t', num2str(timf(i),'%6.3f')); 
    end
    titdisp = strrep(titdisp,'%i', num2str(i));
    
    title(titdisp,'interpreter','none');  % changed v2.32
    %title(texliteral(titdisp));
    
    if pausemode && (length(f)>1) % new v2.10
        set(h,'name','*Paused*');
    else
        set(h,'name','');
    end

    if modalwindow && (length(f)>1) && ~strcmpi(get(h,'WindowStyle'),'docked')
        set(h,'WindowStyle','modal'); % new v2.03, % modified v2.13
    end
    drawnow; % new v1.20
    
    % small temporisation, to allow Windows to recognize the new window
    % (otherwise the key control of the movie does not work). v2.10
    if firstframe
        pause(0.1);
        firstframe=false;
    end
  
    % save movie (old method, obsolete in Matlab 2016)
    if nargout   
        mov(i) = getframe(h);
    end
    
    % save frame, new method (new v3.10)
    if ~isempty(videoobject)
        writeVideo(videoobject, getframe(h));
    end

    if length(f)==1
        exit=true;  % for a still image
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
                case {3,27,113,120} % keys 'Ctrl+C', 'esc', 'x', 'q'
                    exit = true; % force to quit the while loop
                case {106,103}  % key 'j','g' (jump, go)
                    i_go = str2double(inputdlg('Jump to frame #','Jump to frame #',1,{num2str(i_go)}));
                    if ~isempty(i_go) && isnumeric(i_go)
                        i = i_go;
                    end    
                case {47}  % key '/'   % new V2.3
                    if min_sf>0
                        [max_sf, max_sf] = stretchclim(max_sf, min_sf, 1/2);
                    else
                        max_sf = max_sf/2;
                        min_sf = min_sf/2;                     
                    end
                    bound = [min_sf max_sf];
                case {42} % key '*'
                    if min_sf>0
                        [max_sf, max_sf] = stretchclim(max_sf, min_sf, 1/2);
                    else
                        max_sf = max_sf*2;
                        min_sf = min_sf*2;
                    end
                    bound = [min_sf max_sf];
           %keys '+' and '-' to change the scale arrow factor (new v2.36)
                case {43} % key '+'
                    sa = sa*1.5;
                case {45} % key '-'
                    sa = sa/1.5;
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
        
    end  %  (end if length(f)==1)

end

if ~isempty(videoobject)
    close(videoobject);
end

if strcmpi(get(h,'WindowStyle'),'modal')
    set(h,'WindowStyle','normal'); % new v2.03, modified v2.13
end



%%%%%%%%%%%%%%%%%%

function [newmax_sf, newmin_sf] = stretchclim(max_sf, min_sf, climratio) % new v1.30
newmax_sf = ((1+climratio)*max_sf + (1-climratio)*min_sf)/2;
newmin_sf = ((1-climratio)*max_sf + (1+climratio)*min_sf)/2;
