function cf = nantozerofield(f)
%NANTOZEROFIELD  Converts NaN elements to 0 in fields
%   CF = NANTOZEROFIELD(F) converts all the Nan elements of the vector/scalar
%   field array F into 0s.
%
%   See also  ZEROTONANFIELD, INTERPF.

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.10,  Date: 2013/02/22
%   This function is part of the PIVMat Toolbox



% History:
% 2008/10/08: v1.00, first version.
% 2013/02/22: v1.10, works with 3D fields


cf = f;

for i=1:numel(f)
    if isfield(f(i),'vx')
        cf(i).vx(isnan(f(i).vx)) = 0;
        cf(i).vy(isnan(f(i).vy)) = 0;
        if isfield(f(i),'vz')
            cf(i).vz(isnan(f(i).vz)) = 0;
        end
    else
        cf(i).w(isnan(f(i).w)) = 0;
    end
end
