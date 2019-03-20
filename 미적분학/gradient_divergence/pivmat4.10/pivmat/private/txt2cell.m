function [c,s] = txt2cell(str,delim)
%TXT2CELL  Splits an input string into a cell array of string
%   C = TXT2CELL(STR) splits the input string STR into a cell array C,
%   such that C{i} is the line #i of the string STR. Lines are delimited
%   by a carriage return (CHAR(10)).
%
%   C = TXT2CELL(STR, DELIM) uses DELIM as delimiter between the different
%   parts of STR to split into C. By default, DELIM=CHAR(10). 
%
%   [C, S] = TXT2CELL(STR,...) also returns a structure S, containing the
%   left-hand side NAME and the right-hand side VAL of each line,
%   such that C{i} = [S(i).NAME '=' S(i).VAL]. If an equal sign is not
%   present in the line, S(i).NAME = C{i} and S(i).VAL = '';
%
%   F. Moisy
%   Revision: 1.10,  Date: 2007/05/09.
%
%   See also GETATTRIBUTE.


% History:
% 2006/03/10: v1.00, first version.
% 2006/05/09: v1.10, new option 'delim'.


if nargin<2          % new v1.10
    delim=char(10);
end

p=[0 findstr(str,delim) length(str)+1];
for i=1:(length(p)-1)
    line = str((p(i)+1):(p(i+1)-1));
    line = strrep(line, delim,'');
    line = strrep(line, char(13),'');
    c{i} = line;
    peq=findstr(line,'=');
    if ~isempty(peq)
        peq=peq(1);
        s(i).name = strtrim(line(1:peq-1));
        s(i).val = strrep(strtrim(line(peq+1:end)),'"','');
    else
        s(i).name = strtrim(line);
        s(i).val='';
    end
end
