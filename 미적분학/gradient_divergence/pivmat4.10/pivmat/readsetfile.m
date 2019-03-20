function a = readsetfile(filename,attrname)
%READSETFILE  Read the variables of a .SET or .EXP file
%   A = READSETFILE(FILENAME) returns a structure containing the attributes
%   of the .SET or .EXP file FILENAME. 
%
%   SET and EXP files are used by DaVis to store various experiment
%   parameters.
%
%   VAL = READSETFILE(FILENAME, ATTRNAME) returns only the value of the
%   specified attribute ATTRNAME.  ATTRNAME is not case sensitive, and '_'
%   are ignored.
%
%   Example:
%     bufstr = readsetfile('myexp.set','SetBuffers');
%
%   See also GETATTRIBUTE.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.01,  Date: 2006/06/21
%   This function is part of the PIVMat Toolbox


% History:
% 2006/03/10: v1.00, first version.
% 2006/06/21: v1.01, bug fixed in the help text


a = [];

try
    fid = fopen(filename, 'r');
    txt = fread(fid, '*char')';
    fclose(fid);
catch
    error(['Cannot read file ' filename]);
end

% read and interpret the Attribute string:
[c,s] = txt2cell(txt);


if nargin==1,
    % returns the attribute structure:
    for num=1:length(s),
        if ~isempty(s(num).name) && ~isempty(s(num).val)
            varname = strrep(s(num).name,' ','');
            % MATLAB variables cannot begin with a '_':
            if strcmp(varname(1),'_')
                varname = varname(2:end);
            end
            if (~strcmp(varname(1),'/'))&&(~strcmp(varname(1),'#'))
                value = s(num).val;
                if strcmp(value(end),';'),
                    value = value(1:end-1);
                end
                if isnan(str2double(value)),
                    a.(varname) = value;    % if value is a string
                else
                    a.(varname) = str2double(value); % if value is numeric
                end
            end
        end
    end
else
    % only returns the specified attribute
    for num=1:length(s),
        if strcmpi(strrep(attrname,'_',''), strrep(s(num).name,'_','')),
            value = s(num).val;
            if strcmp(value(end),';'),
                value = value(1:end-1);
            end
            if isnan(str2double(value)),
                a = value;    % if value is a string
            else
                a = str2double(value); % if value is numeric
            end
        end
    end
end
