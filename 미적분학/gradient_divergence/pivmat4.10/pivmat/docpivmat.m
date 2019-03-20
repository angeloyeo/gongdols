function docpivmat(filename)
%DOCPIVMAT  Documentation for the PIVMat toolbox
%   DOCPIVMAT displays the start page for the PIVMat toolbox in the help
%   browser. In Matlab 7.3 and before (R2006), typing "doc pivmat" had the
%   same result. However, since Matlab 7.4 (R2007a), the doc function
%   changed, and this feature is not available anymore, so you have to
%   use DOCPIVMAT instead.
%
%   DOCPIVMAT function_name  displays the documentation of function_name
%   in the help browser. In Matlab 7.3, this is strictly equivalent to
%   DOC function_name.
%
%   Example:  DOCPIVMAT loadvec

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.00,  Date: 2007/04/21
%   This function is part of the PIVMat Toolbox

% History:
% 2007/04/21: v1.00, first version.

if nargin==0
    filename='pivmat.html';
end


pathstr = fileparts(which('docpivmat'));
if strfind(filename,'.html')
    htmlfile = fullfile(pathstr, 'html', filename);
else
    htmlfile = fullfile(pathstr, 'html',  [filename '.html']);
end
web(htmlfile, '-helpbrowser');
