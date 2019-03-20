function varargout=rrmdir(varargin)
%RRMDIR  Delete a series of directories.
%   RRMDIR dir_name  deletes the named directories. Wildcards may be used
%   in the directory name and in the intermediate pathnames, contrarily
%   to RMDIR. Brackets ([]) may also be used (see RDIR).
%
%   Use the functional form of RRMDIR, such as RRMDIR('dir'), when the
%   directory names are stored in a string or a cell array of strings.
%
%   The syntax is the same as for MATLAB's RMDIR. In particular, the
%   additional input and output arguments of RMDIR can be used, i.e.
%   [SUCCESS,MESSAGE,MESSAGEID] = RRMDIR(DIRECTORY,MODE). See RMDIR for
%   details.
%
%   To delete files, see RDELETE.
%
%   Examples:
%      RRMDIR('mydir*') deletes all the directories 'mydir*'
%
%      RRMDIR('mydir*/sub[1:10,2]') deletes the subdirectories 'sub01',
%      'sub02',... in each directory mydir*.
%
%   See also RMDIR, RDIR, RDELETE, DELETE.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.10,  Date: 2008/07/28


% History:
% 2005/10/11: v1.00, first version.
% 2005/10/14: v1.01, bug fixed varargout.
% 2008/07/28: v1.10, display

% error(nargchk(1,2,nargin));

f=rdir(varargin{1},'dironly');

for i=1:length(f)
    disp([' Deleting directory ' f{i}]);
    if nargout
        varargout=rmdir(f{i},varargin{2:end});
    else
        rmdir(f{i},varargin{2:end});
    end
end
