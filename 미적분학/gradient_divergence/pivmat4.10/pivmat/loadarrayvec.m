function v = loadarrayvec(pathname,fname,varargin)
%LOADARRAYVEC Load a 2D array of vector fields
%   V = LOADARRAYVEC(DIR,FILE) loads the vector fields matching FILE from
%   the directories matching DIR into a structure array V(I,J) of vector
%   fields, where the index I scans the directories and the index J scans
%   the files. Each element V(I,J) is a single vector field (see LOADVEC
%   for the vector field description). Wildcards (*) and brackets ([]) may
%   be used in DIR and FILE (see RDIR). All the file formats supported
%   by LOADVEC are also supported by LOADARRAYVEC.
%
%   V = LOADARRAYVEC(DIR,FILE,'verbose') also displays the directories and
%   files being loaded.
%
%   Examples:
%     v = loadarrayvec('dir*/PIV*','*.vc7','verbose');
%     showf(v(1,:));  % displays the files from the first directory.
%     showf(v(:,1));  % displays the first file from each directory.
%
%     v = loadarrayvec('dir*','B[5:15].*');
%
%   See also LOADVEC, BATCHF.


%   Acknowledgements: C. Morize, L. Messio.
%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.20,  Date: 2009/11/12
%   This function is part of the PIVMat Toolbox


% History:
% 2005/06/10: v1.00, first version (loadloop, by C. Morize, L. Messio).
% 2005/10/21: v1.10, setname and fname specified by argument.
% 2005/10/30: v1.11, now works with FILE='set.mat'
% 2009/11/12: v1.20, bug fixed when pathname contains multiple wildcards;
%                    new option 'verbose'
% 2009/11/17: v1.21, bug fixed when last dir does not contain *

% error(nargchk(2,3,nargin));
dirname=rdir([pathname '*'],'dironly'); % modified v1.21
curdir = pwd;
if isempty(dirname)
    error('No directory match.');
end

for i=1:length(dirname)
    cd(dirname{i});
    if any(strncmpi(varargin,'verbose',4))   % new v1.20
        disp(['Directory #' num2str(i) '/' num2str(length(dirname)) ': ''' dirname{i} '''']);
        v(i,:) = loadvec(fname,'verbose');
    else
        v(i,:) = loadvec(fname);
    end
    cd(curdir)
end

