function cdw(f)
%CDW  Change current working directory with wildcards
%   CDW works as Matlab's built-in CD, but wildcards (*) can be used in
%   the string pattern. If more than one directory name matches the string
%   pattern, then moves to the first one.
%
%   Use the functional form of CDW, such as CDW('mydir*'),
%   when the directory specification is stored in a string.
%
%   Examples:
%      CDW mydir*2*
%
%   See also CD, LSW, RDIR.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.01,  Date: 2010/03/12


% History:
% 2008/07/28: v1.00, first version.
% 2010/03/12: v1.01, cosmetics

%error(nargchk(1,1,nargin));

f=rdir(f,'dironly');
if ~isempty(f)
    cd(f{1})
end
