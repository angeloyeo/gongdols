function vv=loadvec(filename,varargin)
%LOADVEC  Loads vector/image fields
%   F = LOADVEC(FILENAME) loads the vector/image fields matching FILENAME
%   into a PIVMat structure array F.
%
%   Supported file formats are:
%     .MAT            Vector fields from
%                       - DynamicStudio (Dantec)
%                       - DPIVSoft (Meunier & Leweke, 2003)
%                       - MatPIV (J. Kristian Sveen)
%                       - other sources (e.g. DaVis) converted from VEC2MAT
%     .DAT            Vector fields from
%                       - DynamicStudio (Dantec)
%                       - VidPIV (Oxford Laser)
%     .TXT            Vector fields in text format from DaVis (LaVision)
%     .VEC, VC7       Vector fields (2D or 3D) from DaVis (LaVision)
%     .IMX, IMG, IM7  Image from DaVis (LaVision)
%     .SET            Set of vector fields from DaVis.
%     .CM0, UWO       Vector field from Optical Flow.
%     .AVI            AVI movie (use the option 'frame' to specify the
%                     frames to import)
%
%   Note: When used with DaVis files, LOADVEC needs the READIMX package
%   from LaVision to be installed. See the installation procedure of
%   PIVMat. See VEC2MAT to convert DaVis files into Mat-files in
%   order to load them on systems without ReadIMX.
%
%   The PIVMat structure array F can be displayed using SHOWF. See the page
%   'Importing data into PIVMat' in the PIVMat documentation browser to
%   learn more about LOADVEC.
%
%   A file may also be loaded by clicking on the Current Directory browser
%   (but multiple file selection is not allowed).
%
%   LOADVEC without input argument first opens a dialog box for file
%   selection.
%
%   To load more than one file into a structure array, you may use
%   wildcards ('*') in the filename, e.g., LOADVEC('B*.vc7'). Chained
%   wildcards may also be used in directory names, e.g.
%   LOADVEC('PIV*/B*.VC7');
%
%   For file enumeration, use the bracket ([]) syntax in the filename.
%   For example, F = LOADVEC('B[2:2:6].vc7') loads the files 'B00002.vc7',
%   'B00004.vc7', 'B00006.vc7'. See RDIR for more details about the bracket
%   syntax.
%
%   F = LOADVEC(NUM) loads the file number NUM from the current directory
%   (works in alphanumeric order, only for VEC/VC7 and IMX/IM7 files).
%   NUM may be a simple number or any valid MATLAB vector (e.g., 1:10,
%   [1 10], 2:2:8, 10:-1:1, etc.)
%
%   If FILENAME is a cell array, (e.g. {'B1.vc7','B2.vc7'}), then LOADVEC
%   loads all the files in the structure array F. Each string in the cell
%   array may contain wildcards ('*') and brackets ([]).
%
%   LOADVEC(...,'verbose') prints out the file names being loaded.
%
%   LOADVEC file_name or LOADVEC('file_name') without output argument is a
%   shortcut for SHOWF(LOADVEC('file_name')).
%
%   For vector fields, the PIVMat structure F contains the following fields:
%      x,y         vectors containing the X and Y coordinates
%      vx,vy (vz)  matrices of the x, y (and z) components of the velocity
%      ysign       string, upward or downward Y axis
%      namevx, unitvx, namex, unitx...   strings
%      name        name of the VEC/VC7 file from which originates V
%      setname     name of the parent directory (called 'SET' in DaVis)
%      Attributes  Additional informations from DaVis (see GETATTRIBUTE)
%      choice      An array of 6 integers, giving the 1st, 2nd, 3rd, 4th
%                  choice vectors, the number of filled/processed vectors
%                  and the number of missing vectors.
%      history     Remind from which command V has been obtained
%
%   For scalar fields, the PIVMat structure is identical, except that vx
%   and vy are replaced by w (idem for namevx,...)
%
%   Examples:
%      loadvec B00001.vc7
%      v=loadvec('mypivdata.mat');
%      v=loadvec(1:10);
%      showf(loadvec('*.vc7'));
%      showf(vec2scal(loadvec('B00001.vc7'),'rot'));
%      v=loadvec('B[2:2:6]*.v*');
%      v=loadvec('*','verbose');
%
%   See also SHOWF, RDIR, LOADARRAYVEC, VEC2MAT, CONVERT3DTO2DF,
%   FILTERF, VEC2SCAL, BATCHF, ZEROTONANFIELD, NANTOZEROFIELD.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 4.00,  Date: 2015/12/09
%   This function is part of the PIVMat Toolbox


% History:
% 2004/04/23: v1.00, first version.
% 2005/09/01: v1.01, argument check added.
% 2005/02/02: v1.10, added the 'name' field.
% 2005/02/09: v1.11, added an empty 'setname' field (for compatibility)
% 2005/02/15: v1.12, compatibility bug fixed for ML7 (isequal)
% 2005/02/23: v1.13, cosmetics
% 2005/03/24: v1.14, reads the correct units and the attributes
% 2005/04/28: v1.15, added the 'history' field
% 2005/06/07: v1.20, compatibility DaVis 6/7  (vec/vc7 files)
% 2005/09/01: v1.21, better argument check.
% 2005/09/06: v1.30, loads multiple files using cell arrays, and allows for
%                    wildcards.
% 2005/09/15: v1.31, tests if the Y axis is upward or downward. The global
%                    variable 'manip' is suppressed.
% 2005/09/28: v1.32, loadvec without input and/or output argument added
% 2005/09/29: v1.40, filenames are automatically expanded if needed.
% 2005/10/04: v1.50, now makes use of RDIR (LOADVEC is not recursive
%                    anymore, saves time).
% 2005/10/06: v1.51, also accepts TXT files (see readpivtxt).
% 2005/10/11: v1.52, uses loadpivtxt (readpivtxt retired)
% 2005/10/13: v1.53, also accepts .MAT and .SET files
% 2005/10/21: v1.54, bug Y-axis up/down-ward fixed.  help text changed.
% 2005/11/18: v1.60, compatible with the new DLL ReadIMX 1.4
% 2005/12/20: v1.61, bugs fixed due to changes in ReadIMX 1.4 (Label/Unit,
%                    and Vy sign for Y upward). Bug fixed when the file
%                    selected in the dialog box is not in the current dir.
%                    Multiple file selection allowed.
% 2006/03/03: v1.62, history is now a cell array of strings.
% 2006/03/10: v2.00, now accept imx/im7 files.
% 2006/04/13: v2.01, bug fixed for history when loading a mat file
% 2006/04/28: v2.02, checks if the ReadIMX package is installed. Bug fixed
%                    for .SET files with old history format
% 2006/05/22: v2.03, check if the pivmat toolbox version is available
% 2006/07/20: v2.04, error message changed for wrong Mat-files. Also accept
%                    old IMG files (DaVis 6).
% 2006/07/23: v2.05, no matter the name of the variable in a '.mat' file.
% 2006/09/09: v2.10, also accepts mat-files saved from MatPIV.
%                    new field 'source'
% 2007/01/03: v2.11, error message for 64-bits version of Matlab.
% 2007/02/07: v2.12, read the 'choice' field for IType=3 files (J.Seiwert)
% 2007/04/05: v2.13, bug fixed if the 'cancel' button is pressed in the
%                    dialog
% 2007/04/13: v2.14, check matlab version >=7 ; auto check update
% 2007/04/25: v2.15, bug fixed for scalar fields (transpose)
% 2007/07/16: v2.16, files UWO supported (Optical Flow)
% 2007/07/17: v2.17, bug fixed for 'docpivmat' (ML>=7.3)
% 2007/11/14: v2.18, extract unit information from fields 'LabelX', not
%                    from fields 'UnitX'
% 2008/04/04: v2.19, bug fixed of v2.18. Now works well with ReadIMX of
%                    Date:8/06/07 16:38, Revision: 6.  Checkreadimxversion
% 2008/07/16: v2.20, new option 'verbose'
% 2008/09/11: v2.21, bug fixed "Warning: Concatenation involves an empty
%                    array..."
% 2008/10/21: v2.22, bug in help text fixed
% 2008/11/11: v2.23, imx/im7 files converted to double
% 2009/01/17: v2.24, now requires readimx version 7
% 2009/09/26: v2.30, bug fixed for multiple file selection. Accepts
%                    multiframe images
% 2010/03/26: v2.31, a 'mat' file containing more than 1 variable can now
%                    be recognized as a Pivmat structure.
% 2010/05/03: v2.32, error message for Win64 removed (readimx rev.8)
% 2010/05/04: v2.33, bug fixed for setname with multiple '\'
% 2010/05/06: v2.34, bug fixed v2.31
% 2011/01/14: v2.35, accepts a new (undocumented) format (for F. Martinez)
% 2011/03/10: v2.36, test checkreadimxversion removed (thanks A. Mishra)
% 2012/06/22: v2.37, accepts DAT files (VidPIV), thanks S. Bashir
% 2012/09/25: v2.38, bug fixed for matpiv fields
% 2013/02/22: v3.00, now accepts 3D vector fields
% 2013/04/30: v3.10, compatible with DPIVSoft files
% 2013/05/07: v3.11, bug fixed Y axis for DPIVSoft files
% 2013/06/24: v3.12, uses the DPIVSoft file calibration
% 2013/06/25: v3.13, compatible with 3-components DPIVSoft files
% 2014/06/12: v3.14, automatic check update removed (caused problems
%                    in some cases)
% 2015/12/08: v4.00, accepts MAT files from Dantec.
%                    Compatible with readimx 2.
% 2017/01/31: v4.01, accepts AVI movies


%   doc removed (v4.00):
%   For DaVis multi-frame images, F = LOADVEC(FILENAME, 'frame', N) returns
%   only the frame N.


curdir = pwd;

vv = [];


% pmroot=fileparts(mfilename('fullpath'));
% cudfile=[pmroot filesep 'lastcheckupdate.mat'];
% lcud=load(cudfile);
% if now-lcud.t > 3    % if the previous check was >3 days.
%     res=checkupdate_pivmat;
%     if res>0   % if the connection was available
%         t=now;
%         save(cudfile,'t');
%     end
% end


if any(strncmpi(varargin,'frame',4))   % new v2.30
    frame = varargin{1+find(strncmpi(varargin,'frame',4),1,'last')};
else
    frame = 0;  % all frames
end

% opens a dialog box if no input argument is present (v1.32):
if nargin==0
    [filename,pathname]=uigetfile(...
        {'*.VEC;*.VC7', 'DaVis Vector fields (*.VEC, *.VC7)';...
        '*.IMX;*.IMG;*.IM7', 'DaVis Image fields (*.IMX, *.IMG, *.IM7)';...
        '*.TXT', 'DaVis Text files (*.TXT)';...
        '*.SET', 'DaVis Sets (*.SET)';...
        '*.MAT', 'MATLAB Files (*.MAT)';...
        '*.CM0;*.UWO', 'Optical Flow fields (*.CM0, *.UWO)';...
        '*.*', 'All Files (*.*)'},...
        'Select a vector field',...
        'MultiSelect','on');
    if ~iscell(filename) & filename==0      % if the 'cancel' button is pressed -- changed v2.13 & 2.30
        clear vv
        return
    else
        if iscell(filename)
            for i=1:length(filename)
                filename{i}=[pathname filename{i}];
            end
        else
            filename=[pathname filename];
        end
    end
end

% process numeric input (v1.60, bug fixed v2.21)
if isnumeric(filename),
    listfile=[rdir('*.VEC') rdir('*.VC7') rdir('*.IMX') rdir('*.IMG') rdir('*.IM7') rdir('*.CM0') rdir('*.UWO')];
    filename=listfile(filename);
else
    % calls RDIR to automatically expand and explore (sub)directories:
    filename=rdir(filename);
end


if isempty(filename)
    error('PIVMat:loadvec:noFileMatch','No file match.');
end


v=[];
for i=1:length(filename)
    if exist(filename{i},'file')
        if any(strncmpi(varargin,'verbose',4))   % new v2.20
            disp(['  Loading file #' num2str(i) '/' num2str(length(filename)) ': ''' filename{i} '''']);
        end
        [pathstr,name,ext] = fileparts(filename{i});
        ext=lower(ext);
        
        
        if isequal(ext,'.mat') % new v1.53
            mf=load(filename{i});
            if isfield(mf, 'General')   % new v4.00, Dantec Files
                newv.x = mf.Input{1}.dataset.X(1,:);
                newv.y = mf.Input{1}.dataset.Y(:,1)';
                newv.vx = mf.Input{1}.dataset.U';
                newv.vy = mf.Input{1}.dataset.V';
                
                newv.namex='x';   newv.namey='y';
                newv.unitx='mm';  newv.unity='mm';
                newv.namevx='u_x';  newv.namevy='u_y';
                newv.unitvx='m/s'; newv.unitvy='m/s';
                pivmat_ver=ver('pivmat');
                if ~isempty(pivmat_ver)
                    newv.pivmat_version=pivmat_ver.Version;
                else
                    newv.pivmat_version='unknown'; % new v2.03
                end
                
                newv.ysign='Y axis upward';
                newv.Attributes=mf.General;
                newv.name=filename{i};
                newv.setname=getsetname;
                newv.history={['loadvec(''' newv.name ''')']};
                newv.source='DynamicStudio';
                
            elseif all(isfield(mf, 'vx')) % new v2.35, for Francisco!
                newv.x=mf.x;
                newv.y=mf.y;
                newv.vx=mf.vx';     newv.vy=mf.vy'; % careful with transposes!
                newv.namex='x';   newv.namey='y';
                newv.unitx='mm';  newv.unity='mm';
                newv.namevx='u_x';  newv.namevy='u_y';
                newv.unitvx='mm/s'; newv.unitvy='mm/s';
                pivmat_ver=ver('pivmat');
                if ~isempty(pivmat_ver)
                    newv.pivmat_version=pivmat_ver.Version;
                else
                    newv.pivmat_version='unknown'; % new v2.03
                end
                newv.ysign='Y axis downward';
                newv.Attributes='undefined';
                newv.name=[name ext];
                newv.setname=getsetname;
                newv.history={['loadvec(''' newv.name ''')']}; % changed v1.51 %re-changed v1.62
                newv.source='mpiv';
                
            elseif isfield(mf,'u')  % DPIVSoft, new v3.10
                if isfield(mf,'u_z')  % 3D field, new v.3.13
                    newv.x=mf.x(1,:)*10;  % cm -> mm
                    newv.y=mf.y(:,1)'*10;
                    newv.vx=mf.u*0.01;   % cm/s -> m/s
                    newv.vy=mf.v*0.01;
                    newv.vz=mf.u_z*0.01;
                    newv.namevz='u_z';
                    newv.unitvz='m/s';
                else
                    newv.x=mf.x(1,:)*(10*mf.calibration);
                    newv.y=mf.y(:,1)'*(10*mf.calibration);
                    newv.vx=mf.u*(0.01*mf.calibration/mf.delta_t);
                    newv.vy=mf.v*(0.01*mf.calibration/mf.delta_t);
                end
                newv.namex='x';   newv.namey='y';
                newv.unitx='mm';  newv.unity='mm';
                newv.namevx='u_x';  newv.namevy='u_y';
                newv.unitvx='m/s'; newv.unitvy='m/s';
                pivmat_ver=ver('pivmat');
                if ~isempty(pivmat_ver)
                    newv.pivmat_version=pivmat_ver.Version;
                else
                    newv.pivmat_version='unknown'; % new v2.03
                end
                newv.ysign='Y axis upward';
                newv.Attributes='undefined';
                newv.name=mf.Image_filenam;
                newv.setname=getsetname;
                newv.history={['loadvec(''' newv.name ''')']};
                newv.source='DPIVSoft';
                
            else
                fn=fieldnames(mf);
                
                % new v2.31 (modified v2.34): check every variable within the mat file,
                % and keeps the first one which is a valid pivmat structure
                k = 1;
                findpivmatfield = false;
                while ((~findpivmatfield) && (k<=numel(fn)))
                    eval(['newv=mf.' fn{k} ';']);
                    findpivmatfield = isfield(newv,'pivmat_version');
                    k=k+1;
                end
                %clear mf
                
                if findpivmatfield  % modified v2.38
                    % compatibility of the history field with previous
                    % versions:
                    if ~iscell(newv(1).history), % bug fixed v2.01
                        for nv=1:length(newv),
                            newv(nv).history = {newv(nv).history};
                        end
                    end
                end
                
                % if none of the variable in the 'mat' file was a pivmat structure,
                % then try to load the file as a MatPIV file (new v2.10)
                if ~findpivmatfield
                    try
                        newv.x=mf.x(1,:);
                        newv.y=mf.y(:,1)';
                        newv.vx=mf.u';     newv.vy=mf.v';
                        newv.namex='x';   newv.namey='y';
                        newv.unitx='au';  newv.unity='au';
                        newv.namevx='u';  newv.namevy='v';
                        newv.unitvx='au'; newv.unitvy='au';
                        pivmat_ver=ver('pivmat');
                        if ~isempty(pivmat_ver)
                            newv.pivmat_version=pivmat_ver.Version;
                        else
                            newv.pivmat_version='unknown'; % new v2.03
                        end
                        newv.ysign='Y axis downward';
                        newv.Attributes='undefined';
                        newv.name=[name ext];
                        newv.setname=getsetname;
                        newv.history={['loadvec(''' newv.name ''')']}; % changed v1.51 %re-changed v1.62
                        newv.source='MatPIV';
                    catch
                        error('PIVMat:loadvec:invalidMatFile',...
                            ['Invalid Mat file ''' filename{i} ''': Does not contain any valid PIVMat structure']);
                    end
                end
            end
            
        elseif isequal(ext,'.set')
            newv=loadset(filename{i});
            % compatibility of the history field with previous versions:
            if ~iscell(newv(1).history), % bug fixed v2.01
                for nv=1:length(newv)
                    newv(nv).history = {newv(nv).history};
                end
            end
            
        elseif (isequal(ext,'.vec') || isequal(ext,'.vc7'))
            if exist('readimx','file')
                a=readimx(filename{i});  % test version removed (v2.36)
            else
                disp('ReadIMX not found.');
                disp('See the step 1 of the <a href="matlab:docpivmat pivmat_install">Installation Instructions</a>.');
                clear v
                return
            end
            if frame==0, frame=1; end
            if isfield(a,'Frames') % ReadIMX 2 (dec 2015)
                frameInfo = MakeFrameInfo(a.Frames{frame});
                if ( frameInfo.is3D )
                    D = create3DVec(a.Frames{frame});
                else
                    D = create2DVec(a.Frames{frame});
                end
                
                newv.vx = D.U;      
                newv.vy = D.V;
                newv.x = D.X(:,1)';
                newv.y = D.Y(1,:);
                newv.unitx = a.Frames{1}.Scales.X.Unit;
                newv.unity = a.Frames{1}.Scales.Y.Unit;
                newv.namex = 'x';
                newv.namey = 'y';
                newv.unitvx = a.Frames{1}.Scales.I.Unit;
                newv.unitvy = a.Frames{1}.Scales.I.Unit;
                newv.namevx = 'u_x';
                newv.namevy = 'u_y';
                if isfield(D,'W')
                    newv.vz = D.W;
                    newv.unitvz = a.Frames{1}.Scales.I.Unit;
                    newv.namevz = 'u_z';
                end
                
                if newv.y(2)>newv.y(1)
                    % natural orientation for DaVis (mode axis IJ (matrix)):
                    newv.ysign='Y axis downward';
                else
                    % anti-natural orientation for DaVis (mode axis XY):
                    newv.ysign='Y axis upward';
                    % inverts up/down:
                    newv.y = newv.y(end:-1:1); % the vector y must have increasing components
                    newv.vx = newv.vx(:, end:-1:1);
                    newv.vy = newv.vy(:, end:-1:1); % positive vy means displacement towards increasing y
                    if isfield(newv,'vz')
                        newv.vz = newv.vz(:, end:-1:1); % new v3.00
                    end
                end
                
                for numat = 1:size(a.Attributes)
                    if isequal(a.Attributes{numat}.Name,'_DaVisVersion')
                        newv.source = ['DaVis ' a.Attributes{numat}.Value];
                    end
                end
                
            else % ReadIMX 1.x
                numframe = size(a.Data,2)/size(a.Data,1); % new v2.30
                
                %if frame>numframe
                %    error(['Frame number to large. Only ' num2str(numframe) ' frames available.']);
                %end
                
                switch a.IType
                    case {1,2,3} % 2D vector field
                        [newv.x, newv.y, newv.vx, newv.vy, choic] = getimx(a,frame);
                    case {4,5} % 3D vector field  (% new v3.00)
                        [newv.x, newv.y, dummy, newv.vx, newv.vy, newv.vz, choic] = getimx(a,frame);
                end
                newv.choice = [length(find(choic==1)) length(find(choic==2)) ...
                    length(find(choic==3)) length(find(choic==4)) ...
                    length(find(choic==5)) length(find(choic==0))];
                
                newv.x = newv.x(:,1)'; % new v2.00 (this operation was done by getimx before)
                newv.y = newv.y(1,:);
                
                % Bugs fixed v2.19  : now picks correctly unit and label info:
                
                newv.unitx=strrep(strrep(a.UnitX,'[',''),']','');
                newv.unity=strrep(strrep(a.UnitY,'[',''),']','');
                
                if isempty(a.LabelX) || strcmpi(a.LabelX,'position')
                    newv.namex='x';
                    newv.namey='y';
                else
                    newv.namex=a.LabelX;
                    newv.namey=a.LabelY;
                end
                
                newv.unitvx=a.UnitI;
                newv.unitvy=a.UnitI;
                if isfield(newv,'vz'), newv.unitvz=a.UnitI; end
                
                if strcmpi(a.LabelI,'velocity')
                    newv.namevx='u_x';
                    newv.namevy='u_y';
                    if isfield(newv,'vz'), newv.namevz='u_z'; end
                elseif strcmpi(a.LabelI,'displacement')
                    newv.namevx='\deltax';
                    newv.namevy='\deltay';
                    if isfield(newv,'vz'), newv.namevz='\deltaz'; end
                else
                    newv.namevx=a.LabelI;
                    newv.namevy=a.LabelI;
                    if isfield(newv,'vz'), newv.namevz=a.LabelI; end
                end
                % new v1.54:
                if newv.y(2)>newv.y(1)
                    % (mode axis IJ (matrix)):
                    newv.ysign='Y axis downward';
                else
                    % (mode axis XY):
                    newv.ysign='Y axis upward';
                    % inverts up/down:
                    newv.y = newv.y(end:-1:1); % the vector y must have increasing components
                    newv.vx = newv.vx(:, end:-1:1);
                    newv.vy = newv.vy(:, end:-1:1); % positive vy means displacement towards increasing y
                    if isfield(newv,'vz')
                        newv.vz = newv.vz(:, end:-1:1); % new v3.00
                    end
                end
                try %new v2.00
                    newv.source = ['DaVis ' num2str(a.DaVis)];
                catch
                    newv.source = 'DaVis (unknown version)';
                end
            end
            
            pivmat_ver=ver('pivmat');
            if ~isempty(pivmat_ver)
                newv.pivmat_version=pivmat_ver.Version;
            else
                newv.pivmat_version='unknown'; % new v2.03
            end
            
            newv.Attributes=a.Attributes;  % new v1.14
            newv.name=[name ext]; % changed v1.50
            
            if ~isempty(pathstr)
                posfs = findstr(pathstr,filesep); %new v2.33
                if isempty(posfs)
                    newv.setname=pathstr; % changed v1.50
                else
                    newv.setname=pathstr((posfs(end)+1):end);
                end
            else
                newv.setname=getsetname;
            end
            
            newv.history={['loadvec(''' newv.name ''')']}; % changed v1.51 %re-changed v1.62
            
            
        elseif (isequal(ext,'.imx') || isequal(ext,'.img') || isequal(ext,'.im7'))
            if exist('readimx','file')
                a=readimx(filename{i});  % test version removed (v2.36)
            else
                disp('ReadIMX not found.');
                % test PCWIN removed (v2.36)
                disp('See the step 1 of the <a href="matlab:docpivmat pivmat_install">Installation Instructions</a>.');
                clear v
                return
            end
            
            if isfield(a,'Frames') % ReadIMX 2 (dec 2015)
                
                Planes = a.Frames{1}.Components{1}.Planes;
                D = createPlane( Planes{1}, a.Frames{1}.Scales );
                
                newv.x = D.X;
                newv.y = D.Y;
                newv.w = D.I;
                newv.unitx = a.Frames{1}.Scales.X.Unit;
                newv.unity = a.Frames{1}.Scales.Y.Unit;
                newv.namex = 'x';
                newv.namey = 'y';
                newv.unitw = a.Frames{1}.Scales.I.Unit;
                newv.namew = 'I';
                
                if newv.y(2)>newv.y(1)
                    % natural orientation for DaVis (mode axis IJ (matrix)):
                    newv.ysign='Y axis downward';
                else
                    % anti-natural orientation for DaVis (mode axis XY):
                    newv.ysign='Y axis upward';
                    % inverts up/down:
                    newv.y = newv.y(end:-1:1); % the vector y must have increasing components
                    newv.w = newv.w(:, end:-1:1);
                end
                
                for numat = 1:size(a.Attributes)
                    if isequal(a.Attributes{numat}.Name,'_DaVisVersion')
                        newv.source = ['DaVis ' a.Attributes{numat}.Value];
                    end
                end
                
            else % ReadIMX 1.x
                numframe = size(a.Data,2)/size(a.Data,1);
                
                %if frame>numframe
                %    error(['Frame number to large. Only ' num2str(numframe) ' frames available.']);
                %end
                
                [newv.x, newv.y, newv.w]=getimx(a,frame);
                
                % Bugs fixed v2.19  : now picks correctly unit and label info:
                
                newv.unitx=strrep(strrep(a.UnitX,'[',''),']','');
                newv.unity=strrep(strrep(a.UnitY,'[',''),']','');
                
                if isempty(a.LabelX) || strcmpi(a.LabelX,'position')
                    newv.namex='x';
                    newv.namey='y';
                else
                    newv.namex=a.LabelX;
                    newv.namey=a.LabelY;
                end
                
                newv.unitw=a.UnitI;
                newv.namew=a.LabelI;
                if isempty(newv.namew)
                    newv.namew = 'I';  % added v2.23
                end
                
                newv.w = newv.w';   % changed v2.15
                newv.w = double(newv.w);  % added v2.23
                
                % new v1.61:
                pivmat_ver=ver('pivmat');
                if ~isempty(pivmat_ver)
                    newv.pivmat_version=pivmat_ver.Version;
                else
                    newv.pivmat_version='unknown'; % new v2.03
                end
                
                if newv.y(2)>newv.y(1)
                    % natural orientation for DaVis (mode axis IJ (matrix)):
                    newv.ysign='Y axis downward';
                else
                    % anti-natural orientation for DaVis (mode axis XY):
                    newv.ysign='Y axis upward';
                    % inverts up/down:
                    newv.y = newv.y(end:-1:1); % the vector y must have increasing components
                    newv.w = newv.w(:, end:-1:1);
                end
            end
            newv.Attributes=a.Attributes;  % new v1.14
            newv.name=[name ext]; % changed v1.50
            if ~isempty(pathstr)
                posfs = findstr(pathstr,filesep); %new v2.33
                if isempty(posfs)
                    newv.setname=pathstr; % changed v1.50
                else
                    newv.setname=pathstr((posfs(end)+1):end);
                end
            else
                newv.setname=getsetname;
            end
            
            newv.history = {['loadvec(''' newv.name ''')']}; % changed v1.51 %re-changed v1.62
            try %new v2.00
                newv.source = ['Davis ' num2str(a.DaVis)];
            catch
                newv.source = 'Davis (unknown version)';
            end
                
        elseif isequal(ext,'.txt') || isequal(ext,'.dat')  % new v1.51, v2.37
            newv = loadpivtxt(filename{i}); % changed v1.52
        
        elseif isequal(ext,'.avi') || isequal(ext,'.mp4')  % new v4.01
            video = VideoReader(filename{i});
            maxframe = floor(video.Duration * video.FrameRate);
            if frame==0
                frame = 1:maxframe;
            end
            if any(frame>maxframe)
                error('Not enough frames in the movie');
            end
            i=0;  n=0;
            while hasFrame(video) && n<max(frame)
                n = n+1;
                im = readFrame(video);
                if any(frame==n)  % keeps only the required frames
                    i=i+1;
                    im = double(im);
                    if size(im,3)==3      % average RGB -> gray
                        im = mean(im,3);
                    end
                    newv(i).w = im';   % transpose image (y,x) -> (x,y)
                    newv(i).x = 1:size(im,2);
                    newv(i).y = 1:size(im,1);
                    newv(i).namex='x';   newv(i).namey='y';
                    newv(i).unitx='au';  newv(i).unity='au';
                    newv(i).namew='I';   newv(i).unitw='au';
                    pivmat_ver=ver('pivmat');
                    newv(i).pivmat_version=pivmat_ver.Version;
                    newv(i).ysign='Y axis downward';
                    newv(i).Attributes='undefined';
                    newv(i).name=[name ext];
                    newv(i).setname=name;
                    newv(i).history={['loadvec(''' newv.name ''')']};
                    newv(i).source=ext(2:end);
                end
            end
            
        elseif isequal(ext,'.cm0')   % new v2.16
            error('PIVMat:loadvec:invalidFile','CM0 files not yet supported.');
            
        elseif isequal(ext,'.uwo')   % new v2.16
            [vx,vy,totx,toty,phys]=litcm0(name);
            newv.vx = vx';
            newv.vy = vy';
            
            if phys(2,1)==0
                newv.x = 1:totx;
                newv.y = 1:toty;
            else
                newv.x = phys(1,1):phys(2,1):(phys(1,1)+phys(2,1)*size(vx,1));
                newv.y = phys(1,2):phys(2,2):(phys(1,2)+phys(2,2)*size(vx,2));
            end
            
            if newv.y(2)>newv.y(1)
                % natural orientation (mode axis IJ (matrix)):
                newv.ysign='Y axis downward';
            else
                % anti-natural orientation (mode axis XY):
                newv.ysign='Y axis upward';
            end
            
            newv.unitx='pix'; % new v2.04
            newv.unity='pix';
            newv.namevx='u_x';     newv.namevy='u_y';
            newv.namex='x';        newv.namey='y';
            newv.unitvx='pix';     newv.unitvy='pix';
            newv.Attributes={'phys = ', phys};
            if isfield(newv,'vz')
                newv.namevz='u_z';  newv.unitvz='pix';
            end
            
            newv.name=[name ext]; % changed v1.50
            if ~isempty(pathstr)
                posfs = findstr(pathstr,filesep); %new v2.33
                if isempty(posfs)
                    newv.setname=pathstr; % changed v1.50
                else
                    newv.setname=pathstr((posfs(end)+1):end);
                end
            else
                newv.setname=getsetname;
            end
            
            newv.history = {['loadvec(''' newv.name ''')']}; % changed v1.51 %re-changed v1.62
            newv.source = 'Optical Flow';
            
        else
            error('PIVMat:loadvec:invalidFile',...
                ['''' filename{i} ''' is not a valid file.'])
        end
        
        v = [v newv]; % concatenates the new V with the previous ones
    else
        error('PIVMat:loadvec:noFileMatch',...
            'No file match.');
    end
end

cd (curdir)

% output (v1.32):
if nargout==0
    showf(v);
    clear vv
else
    vv = v;
end
