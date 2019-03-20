function varargout=lsw(f)
%LSW  List directory with wildcards
%   LSW works as Matlab's built-in LS, but wildcards (*) are interpreted
%   differently:
%     LS mydir*     lists the directory names matchning 'mydir*'
%     LSW mydir*    lists the content of the first directory matching
%                   'mydir*'
%   Chained wildcards are also allowed:
%     LSW mydir*/exp*
%
%   See also CDW, LS, RDIR.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.00,  Date: 2008/09/05


% History:
% 2008/09/05: v1.00, first version.

%error(nargchk(1,1,nargin));

f=rdir(f,'dironly');
if ~isempty(f)
    if nargout
        varargout{1}=ls(f{1});
    else
        ls(f{1})
    end
end
