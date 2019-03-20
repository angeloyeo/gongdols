function rf=remapf(f,newx, newy)
%REMAPF  Remap a vector/scalar field to a new grid.
%   RF = REMAPF(F, X, Y) remap the vector/scalar field(s) F to a new
%   grid defined by the vectors X and Y (expressed in the same units as the
%   original axis, usually in millimeters).
%
%   For instance, suppose you have a field F defined on a 64x64 grid, with
%   X ranging from 20 to 120 mm and Y from 20 to 100 mm. If you want to
%   remap your data onto a larger grid of 128x128 points, with X from 0 to
%   150 and Y from 0 to 100, do the following:
%      RF = REMAPF(F, linspace(0,150,128), linspace(0,100, 128));
%   Careful: you have to provide appropriate values if you want to conserve
%   the aspect ratio of the original field.
%
%   If the new grid is larger than the old grid, the remapped field is
%   filled with zeros.
%
%   The remap is based on Matlab's built-in function GRIDDATA.
%
%   If no output argument, the result is displayed by SHOWF.
%
%   See also EXTRACTF, ROTATEF, RESIZEF, FLIPF, SHIFTF, SETORIGINF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.10,  Date: 2013/03/13
%   This function is part of the PIVMat Toolbox


% History:
% 2012/05/02: v1.00, first version.
% 2013/03/13: v1.10, works with 3d fields

%error(nargchk(1,3,nargin));

if (ischar(f) || iscellstr(f))
    f=loadvec(f);
end

vecmode = isfield(f(1),'vx');   % 1 for vector field, 0 for scalar field

rf = f;
[xo,yo] = ndgrid(rf(1).x, rf(1).y);  % old grid
[xi,yi] = ndgrid(newx,newy);         % new grid

for i=1:numel(f)
    rf(i).x = newx;
    rf(i).y = newy;
    if vecmode
        rf(i).vx = griddata(xo,yo,f(i).vx,xi,yi);
        rf(i).vy = griddata(xo,yo,f(i).vy,xi,yi);
        if isfield(f(i),'vz')
            rf(i).vz = griddata(xo,yo,f(i).vz,xi,yi);
        end            
    else
        rf(i).w = griddata(xo,yo,f(i).w,xi,yi);
    end
    rf(i).history = {f(i).history{:} ['remapf(ans, X, Y)']}';
end    
rf = nantozerofield(rf);

if nargout==0
   showf(rf);
   clear rf;
end
