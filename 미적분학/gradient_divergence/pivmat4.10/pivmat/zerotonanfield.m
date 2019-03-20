function cf = zerotonanfield(f)
%ZEROTONANFIELD  Converts 0 elements to NaNs in fields
%   CF = ZEROTONANFIELD(F) converts all the 0 elements of the vector/scalar
%   field array F into NaNs.
%
%   See also  NANTOZEROFIELD, INTERPF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.10,  Date: 2013/02/22
%   This function is part of the PIVMat Toolbox



% History:
% 2008/10/08: v1.00, first version.
% 2013/02/22: v1.10, works with 3D fields

cf = f;

for i=1:numel(f)
    if isfield(f(i),'vx')
        cf(i).vx(f(i).vx==0) = NaN;
        cf(i).vy(f(i).vy==0) = NaN;
        if isfield(f(i),'vz')
            cf(i).vz(f(i).vz==0) = NaN;
        end
    else
        cf(i).w(f(i).w==0) = NaN;
    end
end
