function a = getattribute(f,attrname)
%GETATTRIBUTE  Get attribute of a field
%   A = GETATTRIBUTE(F) returns a structure containing the attributes
%   of the vector or scalar field F. If F is an array, then A is a cell array.
%   F may be vector or scalar fields, or filenames of any file format
%   supported by LOADVEC. Wildcards (*) and brackets ([]) may be used (see
%   RDIR for details).
%
%   The field names of the structure A are given by the attribute names
%   (leading '_' are removed from the attribute names). The attribute
%   values are converted to numerical values whenever a numerical
%   conversion is possible.
%
%   VAL = GETATTRIBUTE(F, NAME) returns only the value of the specified
%   attribute NAME.  NAME is not case sensitive, and '_' are ignored.
%
%   To obtain the image acquisition time of F, see GETPIVTIME.
%
%   Examples:
%
%     Returns the times of all the vector fields of the current set:
%       time = getattribute('*.vec', 'time');
%
%   See also GETPIVTIME, GETVAR.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.01,  Date: 2006/03/10
%   This function is part of the PIVMat Toolbox


% History:
% 2006/03/03: v1.00, first version.
% 2006/03/10: v1.01, works only with fields, not with attribute string.


a = [];

if (ischar(f) || iscellstr(f) || isnumeric(f))
    f=loadvec(f);
end

for i=1:length(f),
    % read and interpret the Attribute string (see below):
    [c,s] = txt2cell(f(i).Attributes);

    ia = [];
    if nargin==1,
        % returns the attribute structure:
        for num=1:length(s),
            if ~isempty(s(num).val)
                varname = strrep(s(num).name,' ','');
                % MATLAB variables cannot begin with a '_':
                if strcmp(varname(1),'_')
                    varname = varname(2:end);
                end
                value = s(num).val;
                if isnan(str2double(value)),
                    ia.(varname) = value;    % if value is a string
                else
                    ia.(varname) = str2double(value); % if value is numeric
                end
            end
        end
    else
        % only returns the specified attribute
        for num=1:length(s),
            if strcmpi(strrep(attrname,'_',''), strrep(s(num).name,'_','')),
                value = s(num).val;
                if isnan(str2double(value))
                    ia = value;    % if value is a string
                else
                    ia = str2double(value); % if value is numeric
                end
            end
        end
    end
    
    a{i} = ia;
end

if length(a)==1
    a=a{1};
end
