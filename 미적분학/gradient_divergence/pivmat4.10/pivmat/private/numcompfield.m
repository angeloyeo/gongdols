function comp = numcompfield(f)
% NUMCOMPFIELD   Number of components in a field
%   C = NUMCOMPFIELD(F) returns the number of components (1,2 or 3) of
%   field F.

%   F. Moisy
%   Revision: 1.00,  Date: 2016/11/17


% History:
% 2016/11/17: v1.00, first version.


if isfield(f(1),'vx')
    comp = 2;
    if isfield(f(1),'vz')
        comp = 3;
    end
else
    comp = 1;
end