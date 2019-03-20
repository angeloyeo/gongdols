function num=getfilenum(f,pat,opt)
%GETFILENUM  Get the index of a series of files.
%   NUM = GETFILENUM (NAME, P) returns an array of numbers indexing
%   the filenames (or directory names) matching NAME from the current
%   directory. The indices are searched in the strings following the
%   substring P. Wildcards (*) and brackets ([], see RDIR) may be used
%   in NAME, including in intermediate pathnames.
%
%   NUM = GETFILENUM (NAME, P, OPT), where OPT is 'dironly', 'fileonly' or
%   'filedir', gets the numbers only from the directory names, file names,
%   or both (by default), respectively.
%
%   Examples:
%
%     If the files 'B01_t12.vec','B02_t18.vec', 'B03_t24.vec' are present
%     in the current directory,
%        getfilenum ('*.vec', '_t')   returns [12 18 24],
%        getfilenum ('*.vec', 'B')    returns [1 2 3].
%
%     n=getfilenum('*/*.JPG','DSC') returns the indices of all the files
%     matching 'DSCxxx.JPG' in all directories.
%
%   See also RDIR, RENUMBERFILE.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.12,  Date: 2007/04/03


% History:
% 2005/10/04: v1.00, first version.
% 2005/10/06: v1.01, works also with directory names.
% 2005/10/14: v1.02, help text changed.
% 2006/09/08: v1.10, bug fixed (use str2num, NOT str2num!!)
% 2007/02/14: v1.11, new option 'dironly' etc.
% 2007/04/03: v1.12, works also with real indices, not only integers

%error(nargchk(2,3,nargin));

if nargin==2  % changed v1.11
   filename=rdir(f);  % 'filedir' is taken by default by rdir
else
   filename=rdir(f,opt);
end;

num=[];
nnum=0; % number of file numbers found

for i=1:length(filename),
   fname=filename{i};
   p=findstr(fname,pat);
   if ~isempty(p),
       p=p(1)+length(pat); % position of the first digit
       if ~isempty(str2num(fname(p))) % if it is indeed a digit
           nnum=nnum+1;
           strn='';
           % builds the string of the number as long as digits are found:
           while ~isempty(str2num(fname(p))) || strcmp(fname(p),'.')
               strn=[strn fname(p)];
               p=p+1;
               if p>length(fname), break; end; % exit the while loop
           end
           num(nnum)=str2num(strn);
       end
   end
end