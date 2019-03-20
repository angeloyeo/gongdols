function renamefile(f,pat1,pat2,opt)
%RENAMEFILE  Rename a series of files.
%   RENAMEFILE(NAME, P1, P2) renames the files matching NAME, replacing
%   the substring P1 by P2. NAME may be a cell array of strings, and may
%   contain wildcards (*) and brackets (see RDIR).
%
%   RENAMEFILE(NAME, P1, P2, OPT), where OPT is 'dironly', 'fileonly' or
%   'filedir', renames only the directory names, the file names, or both
%   (by default), respectively.
%
%   Examples:
%      RENAMEFILE('DSC*.JPG','DSC','myphoto')
%      renames the files 'DSC00001.JPG','DSC00002.JPG',... as
%      'myphoto00001.JPG','myphoto00002.JPG',...
%
%      RENAMEFILE('*/DSC*.JPG','DSC','myphoto')
%      does the same in all the directories containing JPG files.
%
%      RENAMEFILE('B[1:100,3]*.VEC','B','PIV') renames the files
%      'B001*.VEC' to 'B100*.VEC' as 'PIV001*.VEC' to 'PIV100*.VEC'
%
%      RENAMEFILE('set*','set','newset','dironly') renames the directories
%      'set*' as 'newset*'.
%
%   See also RENUMBERFILE, MOVEFILE, RDIR, GETFILENUM.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.30,  Date: 2010/04/15


% History:
% 2005/10/04: v1.00, first version.
% 2005/10/06: v1.01, details.
% 2006/09/08: v1.10, faster
% 2007/04/13: v1.11, new option 'dironly' etc.
% 2007/05/18: v1.12, bug fixed v1.11
% 2009/08/26, v1.20, faster version, proposed by tabarroki@gmail.com
% 2010/04/15, v1.30, bug fixed when filenames contain '='.
%                    added 'no file match' display

% error(nargchk(3,4,nargin));

if ispc % changed v1.20
    localmovename = 'ren';
else
    localmovename = 'mv';
end

if strcmp(pat1,pat2)
    return
end

if nargin==3  % changed v1.11
    oldfilename=rdir(f);  % 'filedir' is taken by default by rdir
else
    oldfilename=rdir(f,opt);
end
if isempty(oldfilename)
    disp('No file match.');
else
    newfilename=strrep(oldfilename,pat1,pat2);
    for i=1:length(oldfilename)
        if ~isequal(oldfilename{i},newfilename{i})
            if true; %strfind(oldfilename{i},'=') | strfind(newfilename{i},'=')
                % slow but always work
                movefile(oldfilename{i},newfilename{i});   
            else
                % faster but does not work for remote storage
                system([localmovename ' ' oldfilename{i} ' ' newfilename{i}]);
            end
        end
    end
end
