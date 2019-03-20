function res=getsetname(curdir)
%GETSETNAME  Get the name of the current directory
%   S = GETSETNAME returns the name of the current directory. While PWD
%   returns the full path 'dir1/dir2/../dirn', GETSETNAME returns only the
%   last element 'dirn'.
%   S = GETSETNAME(DIR) returns the name of the last directory of the path
%   DIR.
%
%   See also PWD.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.11,  Date: 2010/05/07
%   This function is part of the PIVMat Toolbox


% History:
% 2004/04/21: v1.00, first version.
% 2005/09/02: v1.01, help text changed.
% 2005/10/11: v1.02, displays the result if no output argument.
% 2010/05/04: v1.10, use filesep; new optional input argument.
% 2010/05/07: v1.11, replaces '/' and '\' by filesep. works when no
%                    filesep is present


if nargin==0  % new v1.10
    curdir=pwd;    % current directory
end

curdir = strrep(curdir,'/',filesep);
curdir = strrep(curdir,'\',filesep);

pos=findstr(curdir,filesep);
if isempty(pos)
    setname='';
else
    setname=curdir((pos(end)+1):end);
end

if ~nargout
    disp(setname);
else
    res=setname;
end
