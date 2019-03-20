function vec2mat(filename,dest,varargin)
%VEC2MAT  Convert any PIVMat-compatible files into standard MAT files
%   VEC2MAT(FILENAME) converts any PIVMat compatible vector field or image
%   matching FILENAME into Mat-files. See LOADVEC for the list of supported
%   file formats. When used with DaVis files, the resulting Mat files may
%   be re-used under systems without the ReadIMX package.
%
%   The output filenames are given by the input filenames, except that the
%   original suffix is replaced by '.mat'. All file formats accepted by
%   LOADVEC are accepted (VEC/VC7/IMX/IM7/IMG/TXT/DAT/SET/AVI).  Wildcards
%   (*) and brackets ([]) may be used (see LOADVEC).
%
%   The resulting MAT-Files can be reloaded using LOADVEC, using
%      V = LOADVEC('B00001.mat'))
%   or directly using the MATLAB's LOAD function:
%      LOAD('B00001.mat')
%   (this syntax creates the variable V in the current workspace).
%   See LOADVEC for the definition of the structure V.
%
%   VEC2MAT(FILENAME, DEST) converts the files to destination folder DEST.
%   By default, the current directory is used as destination.
%
%   VEC2MAT(FILENAME, DEST, 'verbose') also displays the work in progres.
%
%   VEC2MAT, without input argument, converts all the DaVis files of the
%   current directory into MAT files.
%
%   Reloading MAT-Files converted by VEC2MAT instead of loading the
%   original DaVis files saves time (up to a factor 10). It may also be
%   useful to further process the files on platforms which do not support
%   the ReadIMX package.
%
%   Example:
%     vec2mat('dir*/*.vec') converts all the vec files in the directories
%     matching 'dir*' into MAT-files. These files may be further loaded
%     using v=loadvec('dir*/*.mat').
%
%     vec2mat('B[1:100].vc7', 'Z:/MyResults/', 'verbose')
%
%   See also LOADVEC, LOAD, RDIR.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.12,  Date: 2012/06/22
%   This function is part of the PIVMat Toolbox


% History:
% 2005/10/29: v1.00, first version.
% 2006/07/25: v1.01, also accepts IMX/IM7/IMG/TXT files
% 2007/11/15: v1.10, accepts numeric input, and destination directory
% 2011/03/11: v1.11, help text updated
% 2012/06/22: v1.12, DAT files accepted (from VidPIV)
% 2017/01/31: v1.13, AVI files accepted

% error(nargchk(0,3,nargin));

if nargin==0
    filename={'*.vec','*.vc7','*.imx','*.im7','*.img','*.avi'};
end

% process numeric input (vec2mat v1.10, from loadvec v1.60):
if isnumeric(filename)
    listfile=[dir('*.VEC') dir('*.VC7') dir('*.TXT') dir('*.DAT') dir('*.IMX') dir('*.IMG') dir('*.IM7') dir('*.CM0') dir('*.UWO') dir('*.AVI')];
    listfile={listfile.name};
    filename=listfile(filename);
else
    % calls RDIR to automatically expand and explore (sub)directories:
    filename=rdir(filename);
end


if ~isempty(filename)
    for i=1:length(filename);
        if exist(filename{i},'file')
            [pathstr,name,ext] = fileparts(filename{i});
            ext=lower(ext);
            if (isequal(ext,'.vec') || isequal(ext,'.vc7')...
                    || isequal(ext,'.imx') || isequal(ext,'.im7')...
                    || isequal(ext,'.img') || isequal(ext,'.txt')...
                    || isequal(ext,'.set') || isequal(ext,'.dat')...
                    || isequal(ext,'.avi'))
                v=loadvec(filename{i});
                if any(strncmpi(varargin,'verbose',4))
                    disp(['Converting ' name ext ' -> ' name '.mat']);
                end
                if nargin<2   % new v1.10
                    save(fullfile(pathstr,[name '.mat']),'v');   % default destination is current directory
                else
                    save(fullfile(dest,[name '.mat']),'v');
                end
            else
                error(['''' filename{i} ''' is not a valid DaVis file.']);
            end
        else
            error(['File ''' filename{i} ''' not found.']);
        end
    end
else
    error('No file match.');
end
