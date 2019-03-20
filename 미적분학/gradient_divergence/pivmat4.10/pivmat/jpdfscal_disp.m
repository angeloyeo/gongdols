function jpdfscal_disp(jpdf)
%JPDFSCAL_DISP  Displays the joint PDF computed by JPDFSCAL
%    JPDFSCAL_DISP(JPDF) displays the joint PDF computed by JPDFSCAL.
%
%    Example:
%       jpdf = jpdfscal(vec2scal(v,'rot'),vec2scal(v,'div'));
%       jpdfscal_disp(jpdf);
%
%    See also JPDFSCAL.

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.10,  Date: 2007/03/27
%   This function is part of the PIVMat Toolbox


% History:
% 2004/04/28: v1.0, first version.
% 2007/03/27: v1.1, cosmetics

if nargin==0
    error('Call JPDFSCAL first.');
end

levels_fin=[1 3 1e1 3e1 1e2 3e2 1e3 3e3 1e4 3e4 1e5 3e5 1e6];
levels=[1 1e1 1e2 1e3 1e4 1e5 1e6];
%contour(jpdf.bin1, jpdf.bin2, jpdf.hi',levels);

contourf(jpdf.bin1, jpdf.bin2, log10(jpdf.hi'),[0 1 2 3 4 5 6]);

xlabel([jpdf.namew1 ' (' jpdf.unitw1 ')']);
ylabel([jpdf.namew2 ' (' jpdf.unitw2 ')']);
title(['Log joint PDF of ' jpdf.namew1 ' and ' jpdf.namew2]);
hold on
plot([jpdf.bin1(1) jpdf.bin1(end)], [0 0], 'k--');
plot([0 0],[jpdf.bin2(1) jpdf.bin2(end)], 'k--');
hold off
colorbar
