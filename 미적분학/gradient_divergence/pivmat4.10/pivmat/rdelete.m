function rdelete(f,varargin)
%RDELETE  Delete a series of files.
%   RDELETE file_name  deletes the named files. Wildcards may be used in
%   the filename, as with DELETE, but also in the pathnames, which allows
%   for deleting a series a files belonging to different directories.
%   Brackets ([]) may also be used (see RDIR).
%
%   Use the functional form of RDELETE, such as RDELETE('file'), when the
%   file names are stored in a string or a cell array of strings.
%
%   RDELETE(...,'verbose') displays the files being deleted.
%
%   To delete directories, see RRMDIR.
%
%   Examples:
%      RDELETE('DSC*.JPG') is equivalent to DELETE('DSC*.JPG')
%
%      RDELETE('*/*.JPG') deletes all the JPG-files in all the directories.
%
%      RDELETE('mydir*/DSC[10:30].*') deletes the files DSC00010.* to
%      DSC00030.* in each directory 'mydir*'.
%
%   See also DELETE, RDIR, RMDIR, RRMDIR.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.10,  Date: 2008/07/16


% History:
% 2005/10/11: v1.00, first version.
% 2005/10/18: v1.01, bug fixed.
% 2008/07/16: v1.10, new option 'verbose'

% error(nargchk(1,2,nargin));

f=rdir(f,'fileonly');

for i=1:length(f)
    if any(strncmpi(varargin,'verbose',4))
        disp([' Deleting ' f{i}]);
    end
    delete(f{i});
end
