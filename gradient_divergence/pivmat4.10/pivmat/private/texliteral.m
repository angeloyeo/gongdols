function res=texliteral(str)
%TEXLITERAL  Converts the _ and ^ into \_ and \^
%   RES = TEXLITERAL(STR) translates the string STR into a string in
%   which the _ and ^ are replaced by \_ and \^. This is useful to display
%   strings that contain _ or ^ in a a figure (label, title...) where tex
%   symbols are also present.
%
%   F. Moisy
%   Revision: 1.21,  Date: 2006/04/25.
%
%   See also TEXLABEL.

% History:
% 2005/02/24: v1.00, first version.
% 2005/09/01: v1.01, cosmetics.
% 2005/10/17: v1.02, works for ^ too.
% 2005/10/18: v1.10, renamed 'texliteral'.
% 2006/03/03: v1.20, use strrep
% 2006/04/25: v1.21, bug fixed

res = strrep(str,'^','\^');
res = strrep(res,'_','\_');
