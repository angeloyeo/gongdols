function fmask = maskrectf(f,inpcoord,opt)
%MASKF  Mask a rectangular area in a vector/scalar field.
%   EF = MASKRECTF(F,[X1 Y1 X2 Y2]) masks (i.e., puts zeros) in a
%   rectangular area of coordinates [X1 Y1 X2 Y2] in the vector/scalar
%   field(s) F. By default, the coordinates are given in mesh units.
%   Specify MASKRECTF(F,[X1 Y1 X2 Y2],'phys') to give them in physical
%   units (e.g. in mm).
%
%   See ZEROTONANFIELD to mask using NaNs instead of zeros.
%
%   If no output argument, the result is displayed by SHOWF.
%
%   See also TRUNCF, EXTRACTF, SHIFTF, FLIPF, ZEROTONANFIELD,
%   NANTOZEROFIELD.

%   N. Machicoane, F. Moisy, moisy_at_fast.u-psud.fr
%   This function is part of the PIVMat Toolbox


% History:
% 2015/08/11: v1.00, first version. 


% error(nargchk(2,3,nargin));

if (ischar(f) || iscellstr(f) || isnumeric(f))
    f=loadvec(f);
end 

if nargin<3,
    opt='mesh';  % center given in physical units by default
end

if strncmpi(opt,'phys',1),    
    % converts physical units into mesh units
    coord(1) = 1 + floor((inpcoord(1) - f(1).x(1))/abs(f(1).x(2)-f(1).x(1)));
    coord(3) = 1 + ceil((inpcoord(3) - f(1).x(1))/abs(f(1).x(2)-f(1).x(1)));
    
    coord(2) = 1 + floor((inpcoord(2) - f(1).y(1))/abs(f(1).y(2)-f(1).y(1)));
    coord(4) = 1 + ceil((inpcoord(4) - f(1).y(1))/abs(f(1).y(2)-f(1).y(1)));
else
    coord = inpcoord;
end

nx=length(f(1).x);
ny=length(f(1).y);

coord(1) = max([coord(1) 1]);
coord(3) = min([coord(3) nx]);
coord(2) = max([coord(2) 1]);
coord(4) = min([coord(4) ny]);
    
vecmode=isfield(f(1),'vx');   % 1 for vector field, 0 for scalar field

fmask=f;

for i=1:length(f)
    if vecmode
        fmask(i).vx(coord(1):coord(3),coord(2):coord(4))=0;
        fmask(i).vy(coord(1):coord(3),coord(2):coord(4))=0;
        if isfield(f(i),'vz')
            fmask(i).vz(coord(1):coord(3),coord(2):coord(4))=0;
        end
    else
        fmask(i).w(coord(1):coord(3),coord(2):coord(4))=0;
    end
    fmask(i).history = {f(i).history{:} ['maskrectf(ans, [' num2str(inpcoord) '], ''' opt ''')']}';
end

if nargout==0
    showf(fmask);
    clear ef
end
