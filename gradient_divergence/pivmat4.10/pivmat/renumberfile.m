function renumberfile(f,pat,newnum,nz,opt)
%RENUMBERFILE  Re-number the indices of a series of files.
%   RENUMBERFILE(NAME, P) renumbers the files matching NAME having an index
%   following the substring P, using consecutive indices starting from 1.
%   Wildcards (*) and brackets (see RDIR) may be used in NAME. If P is
%   present several times in a filename, uses only the last occurrence.
%   RENUMBERFILE works only in the current directory (NAME cannot contain
%   pathnames).
%
%   RENUMBERFILE(NAME, P, NEWNUM) does the same, using NEWNUM to renumber
%   the files. If NEWNUM is a number, uses consecutive indices starting
%   from NEWNUM. If NEWNUM is an array, uses it to renumber the files. By
%   default, NEWNUM=1.
%
%   RENUMBERFILE(NAME, P, NEWNUM, NZ) specifies the number of 0 pading the
%   index (e.g., '302' paded with 5 zeros is '00302'). By default, NZ=5.
%
%   RENUMBERFILE(NAME, P, NEWNUM, NZ, OPT), where OPT is 'dironly',
%   'fileonly' or 'filedir', renumbers only the directory names, the file
%   names, or both (by default), respectively.
%
%   Examples:
%      If RENUMBERFILE('DSC*.JPG','DSC') is used in a directory that
%      contains 100 JPG-files with arbitrary file numbers, the files are
%      renumbered as 'DSC00001.JPG'...'DSC00100.JPG'.
%
%      RENUMBERFILE('DSC*.JPG','DSC',401) does the same, renumbering
%      the files as 'DSC00401.JPG'...'DSC00500.JPG'.
%
%      RENUMBERFILE('DSC*.JPG','DSC',1,3) does the same, renumbering
%      the files as 'DSC001.JPG'...'DSC100.JPG'.
%
%   See also GETFILENUM, RDIR, RENAMEFILE.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.30,  Date: 2009/08/26


% History:
% 2004/03/09: v1.00, first version.
% 2005/09/02: v1.01, help text changed and arg check.
% 2005/10/04: v1.10, syntax changed. now accept wildcards, file expansion.
% 2005/10/06: v1.11, uses a tmp directory in the matlabroot directory
% 2005/10/21: v1.12, uses a tmp dir specific for this function
% 2006/09/08: v1.20, works without tmp dir (faster: no copyfile)
%                    bug fixed: use str2num, NOT str2double!!
% 2007/04/13: v1.21, new option 'dironly' etc.
% 2009/08/26: v1.30, faster version, proposed by tabarroki@gmail.com


% error(nargchk(2,5,nargin));

if ispc % changed v1.30
    localmovename = 'ren';
else
    localmovename = 'mv';
end

if nargin<5  % changed v1.21
    oldfilename=rdir(f);  % 'filedir' is taken by default by rdir
else
    oldfilename=rdir(f,opt);
end
    
num=getfilenum(f,pat);
if ~exist('newnum','var'), newnum=1; end
if length(newnum)==1, newnum=newnum:(newnum+length(num)-1); end
if ~exist('nz','var'), nz=5; end

for i=1:length(num)
    oldf=oldfilename{i};
    p=findstr(oldf,pat);
    p=p(end)+length(pat); % position of the first digit
    prefix=oldf(1:(p-1));
    pp=p; 
    while pp<=length(oldf) && ~isempty(str2num(oldf(pp)))
        pp=pp+1;
    end
    suffix=oldf(pp:end);
    newf=expandstr([prefix '[' num2str(newnum(i)) ',' num2str(nz) ']' suffix]);
    system([localmovename ' ' oldf ' ' newf{1} '_tmp_']);
    %movefile(oldf,[newf{1} '_tmp_']);  % was too slow!
    disp([oldf ' -> ' newf{1}]);
end
renamefile('*_tmp_','_tmp_','');
