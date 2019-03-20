function imvectomovie(filename, vid, varargin)
%IMVECTOMOVIE  Convert a series of IM7 or VC7 files into a movie
%   IMVECTOMOVIE(FILENAME, VID, 'options', ...) creates a MP4 / AVI movie
%   from a series a files matcing FILENAME.  VID is a VideoWriter object:
%     vid = VideoWriter('mymovie.avi');
%     imvectomovie('*.VC7', vid, ...);
%
%   All the options of SHOWF (e.g., 'clim', 'cmap', 'surf', 'title' etc.)
%   are available with IMVECTOMOVIE.
%
%   All file formats supported by LOADVEC are allowed. FILENAME is a string
%   which can contain wildcards (*) and brackets for file number enumeration
%   (see LOADVEC for all available syntax).
%
%   This command is essentially similar to MOV = SHOWF(FILENAME,...).
%   The essential difference is that here the whole files are NOT stored
%   into a PIVMat structure, but are loaded one by one. This allows the
%   user to generate very large movies without 'out of memory' problems.
%
%   Example
%      vid = VideoWriter('mymovie.avi');
%      imvectomovie('*.VC7', vid, 'rot', 'clim', [-3 3]);
%
%   See also LOADVEC, SHOWF

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.10,  Date: 2017/02/03
%   This function is part of the PIVMat Toolbox

% History:
% 2011/05/01: v1.00, first version.
% 2017/02/03: v1.10, now works with VideoWriter

file = rdir(filename,'fileonly'); % resolve wildcards
n = length(file);
open(vid);
for i=1:n
    if any(strncmpi(varargin,'verbose',4))
        disp(['Loading file #' num2str(i) '/' num2str(n) ': ' file{i}]);
    end    
    showf(loadvec(file{i}), varargin{:});
    writeVideo(vid, getframe);
end
close(vid);

