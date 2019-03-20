function res=checkupdate_pivmat(opt)
%CHECKUPDATE_PIVMAT  Check for update for PIVMat
%   CHECKUPDATE_PIVMAT connects on the PIVMat webpage and checks for a new
%   version.
%
%   CHECKUPDATE_PIVMAT('dialog') does the same, but outputs the result in
%   a dialog box.
%
%   RES = CHECKUPDATE_PIVMAT returns
%     0 : server unavailable
%     1 : no new version available
%     2 : a new version is available online
%     3 : the online version is older than the currently installed one.
%
%   See also ABOUT_PIVMAT. 


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.14,  Date: 2011/04/06
%   This function is part of the PIVMat Toolbox


% History:
% 2005/12/16: v1.00, first version.
% 2006/07/23: v1.01, cosmetics
% 2007/04/15: v1.10, results res
% 2007/05/07: v1.11, output argument improved
% 2007/11/20: v1.12, bug fixed when server unavailable
% 2008/01/05: v1.13, now checks the version number at the URL
%                    'www.fast.u-psud.fr/pivmat/pivmatversion.txt'
% 2011/04/06: v1.14, issue a warning if the pivmat folder is not named
%                    pivmat.

res=0; %new v1.10
verb=0;  % verbose mode

if nargin==0
    opt='command';
end

v1=ver('pivmat');
if isempty(v1)  % new v1.14
    disp('Warning: the pivmat folder must be named ''pivmat'' for automatic check for updates.');
    return
end
curv=str2double(v1.Version);

[s,res]=urlread('http://www.fast.u-psud.fr/pivmat/pivmatversion.txt');
if ~res
    if strcmp(opt,'command')
        if verb, disp('Server unavailable.'); end
        if nargout==0
            clear res
        end
        return
    else
        helpdlg('Server unavailable','Check for update');
        if nargout==0
            clear res
        end
        return
    end
end

newv=str2double(s);

if newv>curv
    res=2;
    if strcmpi(opt,'command')
        disp(' ');
        disp(['   New: PIVMat ' s ' is now available online. <a href="matlab:web http://www.fast.u-psud.fr/pivmat/html/pivmat_releasenotes.html -browser">What''s new?</a>']);
        disp('   Click <a href="matlab:web http://www.fast.u-psud.fr/pivmat -browser">here</a> to update.');
        disp(' ');
    else
        button = questdlg(['New: PIVMat ' s ' is now available online.'],'Check for update','Go online','What''s new?','Cancel','Go online');
        if strncmpi(button,'Go online',2),
            web http://www.fast.u-psud.fr/pivmat -browser
        elseif strncmpi(button,'What',2),
            web http://www.fast.u-psud.fr/pivmat/html/pivmat_releasenotes.html -browser
        else
            return
        end
    end
elseif newv<curv
    res=3;
    if strcmp(opt,'command')
        if verb, disp('The online version is older than yours!'); end
    else
        helpdlg('The online version is older than yours!','Check for update');
    end
else
    res=1;
    if strcmp(opt,'command')
        if verb, disp('No new version available online'); end
    else
        helpdlg('No new version available online','Check for update');
    end
end

if nargout==0   % v1.11
    clear res
end
