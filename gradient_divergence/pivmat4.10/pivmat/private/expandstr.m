function f=expandstr(str)
%EXPANDSTR  Expand indexed strings.
%   F = EXPANDSTR('PP[RANGE]SS') returns a cell array of strings in the form
%   'PP0000nSS', where 'PP' and 'SS' are prefix and suffix substrings, n is
%   an index lying in the range RANGE, paded with 5 zeros.  RANGE is a
%   vector, that can be in the form [N1 N2 N3..], or START:END, or
%   START:STEP:END, or any other MATLAB valid syntax.
%
%   F = EXPANDSTR('PP[RANGE,NZ]SS') also specifies the number of zeros to
%   pad the index string (NZ=5 by default). For example, 'B[1:4,2].v*'
%   gives {'B01.v*','B02.v*','B03.v*','B04.v*'}.
%
%   F = EXPANDSTR('PP[RANGE,NZ.NP]SS') also specifies the number of digits
%   NP after the decimal point (NP=0 by default). For example,
%   'dt=[1:0.5:2,2.3]s' gives {'dt=1.000s','dt=1.500s','dt=2.000s'}.
%
%   If the input string has more than one bracket pair [], EXPANDSTR is
%   called recursively for each pair. For example, 'B[1:4,2]_[1 2,1]'
%   gives {'B01_1','B01_2','B02_1','B02_2','B03_1','B03_2','B04_1','B04_2'}
%
%   EXPANDSTR is useful when applied to file names, e.g. with RDIR. In
%   particular, wildcards (*) may be present in PP or SS (but they are
%   kept as wildcards, i.e. they are not interpreted). For example,
%   expandstr('B[1 2 3,5]*.*') returns {'B00001*.*','B00002*.*',..}. Note
%   that EXPANDSTR is automatically called from RDIR.
%
%   Examples :
%
%   expandstr('DSC[2:2:8,4].JPG') returns
%     {'DSC0002.JPG','DSC0004.JPG','DSC0006.JPG','DSC0008.JPG'}
%
%   expandstr('Myfiles_dt=[1:0.5:2,5.2]s.*') returns
%     {'Myfiles_dt=01.00s.*','Myfiles_dt=01.50s.*','Myfiles_dt=02.00s.*'}
%
%   rdir(expandstr('B[1:10,5]*.*'))  is equivalent to rdir('B[1:10,5]*.*')
%
%   See also RDIR.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.10,  Date: 2010/05/12


% History:
% 2004/09/29: v1.00, first version. Replaces buildfilename.
% 2004/10/04: v1.01, works recursively when several [] are found.
% 2010/05/04: v1.02, now in the private directory
% 2010/05/12: v1.10, now accepts non-integer formats

% error(nargchk(1,1,nargin));

f='';
p1=findstr(str,'[');
if isempty(p1),
    f=str;
else
    p1=p1(1);
    p2=findstr(str,']');
    if isempty(p2),
        error('Invalid string: Missing closing bracket '']''');
    else
        p2=p2(1);
        pp=str(1:(p1-1)); % prefix
        ss=str((p2+1):end); % suffix
        p3=findstr(str((p1+1):(p2-1)),',');
        if ~isempty(p3)
            num=eval(str((p1+1):(p1+p3-1)));
            nz=str2double(str((p1+p3+1):(p2-1)));
        else
            num=eval(str((p1+1):(p2-1)));
            nz=5; % number of zeros by default
        end
        nzw = fix(nz);  % precision
        nzp = round(10*(nz-fix(nz))); % nbre of digits after '.'
        if nzw>16,
            error('Invalid number of zero pading: too large.');
        end
        format = ['%0' num2str(nzw) '.' num2str(nzp) 'f'];
        for i=1:length(num),
            f{i}=[pp sprintf(format, num(i)) ss];
        end
    end
    % if brackets remain in the suffix, call again EXPANDSTR for each
    % string (and so on recursively)
    if findstr(ss,'['),
        ff={};
        for i=1:length(f),
            e=expandstr(f{i});
            ff={ff{:} e{:}};
        end
        f=ff;
    end
end

