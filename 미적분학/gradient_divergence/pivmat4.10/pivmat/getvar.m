function res = getvar(str,reqname,varargin)
%GETVAR  Get the value of the parameters in a string 'p1=v1_p2=v2_...'
%   S = GETVAR(STR), where the string STR is in the form 'p1=v1_p2=v2_...',
%   returns a structure S containing the variables built from STR, with
%   S.p1=v1, S.p2=v2, etc.  If the substrings separated by '_' do
%   not contain any '=', the first block of alphanumeric characters stands
%   for the variable name, and the remaining of the substring is the value
%   for that variable. If the substrings consist only of alphanumerics or
%   digits, then a generic variable name in the form 'varxx' is generated.
%
%   This function is useful to read the parameters stored into filenames.
%
%   Example:
%      getvar('050211_180_dt18.5_h0=80_mode=drop')
%           var1: 50211
%           var2: 180
%             dt: 18.5000
%             h0: 80
%           mode: 'drop'
%
%   If STR is a cell array of string, GETVAR loops over each element and
%   returns a cell array of structures.
%
%   VAR = GETVAR(STR, VARNAME) returns the value of the variable VARNAME.
%   VAR = GETVAR(STR, N) returns the Nth variable.
%
%   Example:
%      getvar('a12_b3_c5...','b')
%         3
%
%   The variables are converted to numeric whenever a numeric conversion
%   is possible. To keep all variables as strings, specify 'strings' as the
%   3rd parameter: GETVAR(STR, VARNAME, 'strings'). (use VARNAME=[] if you
%   do not specify any VARNAME).
%
%   Examples:
%      getvar('050211_180_dt18.5_h0=80_mode=drop','dt')
%         18.5000
%
%      getvar('050211_180_dt18.5_h0=80_mode=drop','dt','strings')
%         '18.5'
%
%   See also GETATTRIBUTE, GETFILENUM.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.02,  Date: 2008/02/29
%   This function is part of the PIVMat Toolbox


% History:
% 2007/05/09: v1.00, first version.
% 2008/02/15: v1.01, bug fixed in help
% 2008/02/29: v1.02, uses the string 'separator'

%error(nargchk(1,inf,nargin));

if iscell(str)
    lenstr = length(str);
else
    lenstr = 1;
    str = {str};
end

% list of available separators ('_&' by default):
separator = '_&';

for numstr = 1:lenstr
    
    % replace all separators by '_'
    for isep=1:length(separator)       
        str{numstr} = strrep(str{numstr},separator(isep),'_');
    end

    blocklist = txt2cell(str{numstr},'_');

    for varnum=1:length(blocklist)
        block = blocklist{varnum};
        if ~isempty(block)
            poseq = strfind(block,'=');
            if ~isempty(poseq)
                varname = block(1:(poseq(1)-1));
                varvalue = block((poseq(1)+1):end);
            else
                if length(block)==1
                    varname=['var' num2str(varnum)];
                    varvalue=block;
                else
                    % position of the first non-letter character
                    pos = find(~isletter(block),1,'first');

                    if isempty(pos) || pos==1
                        varname=['var' num2str(varnum)];
                        varvalue=block;
                    else
                        varname = block(1:(pos-1));
                        varvalue = block(pos:end);
                    end
                end
            end
            try
                if isnan(str2double(varvalue)) || any(strncmpi(varargin,'strings',3))
                    s(numstr).(varname) = varvalue;
                else
                    s(numstr).(varname) = str2double(varvalue);
                end
            catch
                error(['Invalid variable name: ''' varname '''.']);
            end
        end
    end
end

if nargin==0
    clear res
elseif nargin>=2 && ~isempty(reqname)   % two output arg: returns only the required varname
    res = [];
    for numstr = 1:lenstr
        fn = fieldnames(s(numstr));
        if isnumeric(reqname)
            if reqname<=length(fn)
                res{numstr} = s(numstr).(fn{reqname});
            else
                error('Invalid variable number.');
            end
        else
            for varnum = 1:length(fn)
                if strcmpi(reqname, fn(varnum))
                    res{numstr} = s(numstr).(fn{varnum});
                end
            end
        end
    end
    if ~isempty(res) && lenstr==1
        res = res{1};
    end
else
    res=s;
end

