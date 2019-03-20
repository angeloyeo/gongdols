function mov = showf(f, varargin)
%SHOWF  Display vector or scalar fields as still images or movies
%   SHOWF(V,BGMODE) displays the vector field(s) V as a still image or as a
%   movie, using the background specified by BGMODE: 'rot','norm' etc.
%   (See VEC2SCAL for the list of available background modes). If no BGMODE
%   specified, the out-of-plane component vz is used by default for
%   3-components fields, and the 2D-norm for 2-components fields.
%   Specify BGMODE='off' or '' for no background (white).
%
%   SHOWF(S), if S is a scalar field (or a set of scalar fields), displays
%   the fields as a still image or as a movie. S is a structure (for a
%   single field) or a structure array (for several fields) that can be
%   obtained from VEC2SCAL.
%
%   During the movie, the following commands are available in live:
%       Space                   Enter/exit the 'pause' mode
%       '/' and '*'             Stretch/compress the colormap
%       '+' and '-'             Increase/decrease the vector arrow length 
%       Right arrow, or 'n'     Next frame.
%       Left arrow,  or 'b'     Previous frame.
%       'g' or 'j'              Jump to a specified frame
%       Esc or 'x' or 'q' or Ctrl+C     Exit
%
%   SHOWF(V, 'PropertyName', PropertyValue, ...) specifies the property
%   name / property value pairs (only the first letters of the PropertyName
%   are required):
%
%     'Background' BGMODE : specifies the background BGMODE ('rot','norm',
%                           see VEC2SCAL.) If BGMODE is the second input
%                           argument, it is not necessary to specify
%                           'Background'.
%     'Spacing'   [NX NY] : displays 1 vector every NX (resp. NY) in the
%                           X (resp. Y) direction.
%     'Spacing'   N       : idem, with NX=NY=N.
%                           (by default, displays 32 vectors in each
%                           direction).
%     'ScaleArrow' SA     : Specifies the scale for the vector arrows.
%                           SA is such that a vector of norm L (in
%                           vector units, e.g. m/s) has length SA*L
%                           (in units of space coordinates, e.g. mm).
%                           If SA<0, the arrows are not displayed.
%                           If not specified, or if SA = 0, a default value
%                           is automatically chosen.
%                           Use the keys '+' and '-' to modify this
%                           parameter during a movie.
%     'CLim':  [CMIN CMAX]: specifies the min and max of the colormap.
%              CMAX       : specifies the max of the colormap (0 or
%                           -CMAX is taken by default for the min)
%              'all', 0   : normalize the colormap using the min and
%                           max for all the scalar fields (by default).
%              'each', -1 : normalize the colormap using the min and
%                           max of each scalar field.             
%     'Colorvec'  COL     : Color of the vector arrows. COL may be a
%                           string ('r', 'k' etc) or an array [R G B].
%     'CMap': argcolormap : Specifies the colormap, where 'argcolormap'
%                           may be a string ('gray', 'jet' etc) or a
%                           m-by-3 matrix of real numbers between 0.0 and
%                           1.0. See the reference page for COLORMAP.
%     'Contour'   n       : Displays n contour lines
%     'Contourf'  n       : Displays n filled contour lines
%     'Streamline' [NX,NY]: display streamlines. The starting points of the
%                           streamlines are chosen on a uniform grid with
%                           spacing [NX,NY]. (NX=NY=16 by default)
%     'Loop':     -       : loop the movie (press 'esc' to exit)
%     'Backward': -       : plays backward
%     'Delay'     n       : waits n seconds between each frame
%     'Pause'     -       : directly enter in the 'pause' mode (press
%                           'space' to exit the pause mode)
%     'Title'     TIT     : string of the title. The following replacements
%                           are performed (default = '%s [#%i]'):
%                                '%n' : filename
%                                '%s' : directory name
%                                '%i' : field number
%                                '%t' : time in sec. (see GETPIVTIME)
%                                '%t0' : time, with origin t(1)=0.
%     'savevideo', VID    : specify a video object VID to save the movie.
%                           The video object must be first initialized
%                           using videoWriter (see below).
%
%   Some PropertyName/PropertyValue pairs work only for scalar fields:
%
%     'Contour3',  n        : Displays n 3D contour lines (n=8 by def.)
%     'Surf':     -         : 3-D shaded surface (see SURF)
%     'Surfc':    -         : 3-D shaded surface with a contour plot
%                             beneath the surface (see SURFC)
%     'Surfl':    -         : 3-D shaded surface with colormap-based
%                             lighting (see SURFL)
%     'Mesh':               : 3-D wireframe parametric surface (see MESH)
%     'Meshc':              : 3-D wireframe parametric surface with a
%                             contour plot beneath the surface (see MESCHC)
%     'hprofile', [y]       : adds horizontal profile(s) at height
%                             specified by y embedded in the figure
%     'vprofile', [x]       : adds vertical profile(s) at absisca
%                             specified by x embedded in the figure
%     'ResetCameraSettings' : refresh the camera angle, view etc.
%     'Command'  STR        : any Matlab string to be evaluated at each
%                             frame.
%
%   To save a movie in a file, there are two solutions:
%    1) Preferred solution: Using a videoWriter object
%         vid = videoWriter('mymovie.avi');
%         showf(v, ..., 'savevideo', vid);
%    2) Old solution: Using MOVIE2AVI (obsolete since Matlab 2016):
%         mov = showf(v, ...);
%         movie2avi(mov, 'mymovie.avi');
%
%   SHOWF(FILENAME,...) is a shortcut for SHOWF(LOADVEC(FILENAME),...)
%
%   SHOWF without input argument opens a dialog box for file selection.
%
%   Examples:
%        v=loadvec('*.vc7');
%        showf(v,'norm','scalearrow',2);
%
%        showf *.vc7
%
%        showf('set.mat','loop','title','t = %t s');
%
%        showf(filterf(v,1),'rot','clim','all','spacing',8);
%
%        movie2avi(showf(v,'rot','contour'),'curl.avi');
%
%        showf(v(1:10), 'norm', 'cmap', 'gray', 'colorvec', 'y');
%
%        showf(vec2scal(v,'norm'));
%
%        showf(vec2scal('*.vc7','norm'),'cmap','gray');
%
%        s=vec2scal(filterf(v),'ken');
%        vid=videoWriter('energy.avi');
%        showf(s,'CLim',[0 14],'savevideo',vid);
%
%        rot=vec2scal(filterf(v,1),'rot');
%        showf(rot,'cont',12,'pause','CLim','each');
%
%   See also LOADVEC, VEC2SCAL, OPERF, MOVIE, IMAGE, QUIVER, COLORMAP,
%   CONVERT3DTO2DF, MOVIE2AVI.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.50,  Date: 2017/02/02
%   This function is part of the PIVMat Toolbox


% History:
% 2007/04/13: v1.00, first version.
% 2008/09/01: v1.10, bug fixed when imput argument is an '.imx' file
% 2010/05/03: v1.11, help text improved
% 2012/07/06: v1.20, now all the help text of SHOWVEC and SHOWSCAL is
%                    included here.
% 2012/11/09: v1.30, help changed for new option 'scalearrow'
% 2013/03/13: v1.40, help changed for 3D fields
% 2016/04/26: v1.41, help changed for scalearrow<0
% 2017/02/02: v1.50, help changed for videos (new method videoWriter) and
%                    for the embedded horizontal/vertical profiles

if nargin==0
    if nargout==0
        showvec;
    else
        mov=showvec;
    end
    return
end

if (ischar(f) || iscellstr(f) || isnumeric(f))
    f=loadvec(f);   
end

if isfield(f(1),'vx')
    if nargout==0
        showvec(f,varargin{:});
    else
        mov=showvec(f,varargin{:});
    end
else
    if nargout==0
        showscal(f,varargin{:});
    else
        mov=showscal(f,varargin{:});
    end
end
