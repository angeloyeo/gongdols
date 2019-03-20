function ff=interpf(f,method)
%INTERPF  Interpolate missing data
%   FF = INTERPF(F), returns fields where missing data are interpolated.
%   "Missing data" are elements 0 or NaN. Based on "inpaint_nans" by
%   J. D'Errico.
%
%   FF = INTERPF(F, METHOD) specifies the method number (default is 0).
%   Edit the file 'inpaint_nans' in the directory 'private' to see the
%   definitions of the various methods.
%
%   Example:
%      v = loadvec('*.vc7');
%      showf(interpf(v));
%
%   See also  MEDIANF, FILTERF, NANTOZEROFIELD, ZEROTONANFIELD.

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.11,  Date: 2016/11/17
%   This function is part of the PIVMat Toolbox


% History:
% 2008/10/08: v1.00, first version.
% 2013/02/22: v1.10, works with 3D fields
% 2016/11/17: v1.11, speed improvement

if nargin==1
    method=0;
end

% inpaint_nans work consider that missing data are represented by NaNs,
% so first convert 0s into NaNs:
f=zerotonanfield(f);

ff=f;
comp = numcompfield(f(1));

for i=1:numel(f)
    if comp==1
        ff(i).w = inpaint_nans(f(i).w, method);
    else
        ff(i).vx = inpaint_nans(f(i).vx, method);
        ff(i).vy = inpaint_nans(f(i).vy, method);
        if comp==3
            ff(i).vz = inpaint_nans(f(i).vz, method);
        end
    end
    ff(i).history = {f(i).history{:} ['interpf(ans, ' num2str(method) ')']}';
end
