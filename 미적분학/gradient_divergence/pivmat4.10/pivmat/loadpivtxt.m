function v = loadpivtxt(fname)
%LOADPIVTXT  Load a vector field exported in text format (TXT, DAT)
%   V = LOADPIVTXT(FILENAME) loads a vector field FILENAME saved in text
%   format (TXT or DAT) into the structure V. Accepted file formats are:
%     .TXT, exported from DaVis (LaVision)
%     .DAT, from DynamicStudio (Dantec) and VidPIV (Oxford Laser) 
%
%   The fields of the structure V are the same as for LOADVEC, except the
%   field V.Attributes, which contains the first line of the text file
%   FILENAME.
%
%   Using LOADVEC to load vector fields in TXT mode allows for wildcards
%   and brackets (filename expansion).
%
%   Note: Using MAT/VEC/VC7 files instead of TXT/DAT files is strongly
%   encouraged. If you use Davis files (VEC/VC7), you may convert your
%   original DaVis files into Mat-files using VEC2MAT.
%
%   Example:
%      v=loadpivtxt('B00001.txt');
%
%   See also LOADVEC, VEC2MAT.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.40,  Date: 2015/12/09
%   This function is part of the PIVMat Toolbox


% History:
% 2002/30/01: v1.00, first version.
% 2003/02/17: v1.01.
% 2005/02/23: v1.02, cosmetic changes.
% 2005/09/01: v1.03, argument check added.
% 2005/10/06: v1.04, file validity checked.
% 2005/10/11: v1.10, loadpivtxt is combination of readpivtxt v1.04 and
%                    dav2mat v1.05 (2005/10/06).
% 2005/10/17: v1.11, bug fixed for vectors x and y.
% 2005/10/21: v1.20, bug Y-axis up/down-ward fixed. Reads the units in the
%                    commentstring (1st line)
% 2006/03/03: v1.21, history is now a cell array of strings.
% 2006/09/12: v1.22, new field 'source'
% 2010/09/27: v1.30, also work when the comment line is missing
% 2012/06/22: v1.31, help text changed: accept VidPIV files
% 2012/07/11: v1.32, bug fixed regarding the scan of the comment line
% 2015/12/09: v1.40, accepts DAT files from DynamicStudio (Dantec)

% error(nargchk(1,1,nargin));

fid=fopen(fname);
if fid<0
    error(['Can''t open file ' fname]);
end

% skip the comment lines (header):
numcommentline = 0;
islinedata = false;
source = 'Unknown';
while ~islinedata
    tline = fgetl(fid);
    if findstr(tline,'DaVis')
        source = 'DaVis';
    elseif findstr(tline,'DynamicStudio');
        source = 'DynamicStudio';
    end
    firstchar = tline(1);
    islinedata = ~isnan(str2double(firstchar)) || isequal(firstchar,'-');
    if ~islinedata
        numcommentline = numcommentline+1;
        commentline{numcommentline} = tline;
    end
end

% read the data, and add the first data line
[data,count]= fscanf(fid,'%f',[4,inf]);
data = [sscanf(tline,'%f',4) , data];
fclose(fid);

% arrange the data

nx=length(find(data(2,:)==data(2,1)));
ny=size(data,2)/nx;

v.x=zeros(nx,ny);
v.y=zeros(nx,ny);
v.vx=zeros(nx,ny);
v.vy=zeros(nx,ny);

for j=1:ny
    for i=1:nx
        v.x(i,j)=data(1,(j-1)*nx+i);
        v.y(i,j)=data(2,(j-1)*nx+i);
        v.vx(i,j)=data(3,(j-1)*nx+i);
        v.vy(i,j)=data(4,(j-1)*nx+i);
    end
end

if v.x(1,1)==v.x(1,2)
    v.x=v.x(:,1)';
    v.y=v.y(1,:);
else
    v.x=v.x(1,:)';
    v.y=v.y(:,1);
end

if false   % reconnait les unites (option supprimee)
    p=findstr(commentstring,'"');
    v.unitx=strtok(commentstring((p(3)+1):end),'"');
    v.unity=strtok(commentstring((p(7)+1):end),'"');
    v.unitvx=strtok(commentstring((p(11)+1):end),'"');
    v.unitvy=strtok(commentstring((p(11)+1):end),'"');
else
    v.unitx='mm';
    v.unity='mm';
    v.unitvx='m/s';
    v.unitvy='m/s';
end
v.namevx='u_x';
v.namevy='u_y';
v.namex='x';
v.namey='y';

% Axis Y upward or downward?
if (v.y(2)>v.y(1)) & findstr(source,'DaVis')
    % natural orientation for DaVis (mode axis IJ (matrix)):
    v.ysign='Y axis downward';
else
    % anti-natural orientation for DaVis (mode axis XY):
    v.ysign='Y axis upward';
    % inverts up/down:
    v.vx = v.vx(:, end:-1:1);
    v.vy = v.vy(:, end:-1:1); % No need to invert the vy component in txt mode
    v.y  = v.y(end:-1:1); % the vector y must have increasing components
end

v.setname=getsetname;
v.name=fname;
v.Attributes=commentline;
v.history={'loadpivtxt'};
v.source = source;
pivmat_ver=ver('pivmat');
if ~isempty(pivmat_ver)
    v.pivmat_version=pivmat_ver.Version;
else
    v.pivmat_version='unknown';
end

