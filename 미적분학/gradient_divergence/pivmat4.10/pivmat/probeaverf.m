function varargout = probeaverf(f,rect)
%PROBEAVERFF   Time series of a probe averaged over a rectangular area
%   P = PROBEAVERFF(F, RECT), where F is an array of scalar fields, and RECT
%   a rectangle in the form [X1, Y1, X2, Y2], returns the time series of
%   the field averaged over the rectangle. RECT is specified in physical
%   units (eg., in mm).  P is an array of size LENGTH(F).
%
%   P = PROBEAVERFF(F) allows the user to select a rectangle using the mouse.
%
%   [UX, UY] = PROBEAVERFF(...)  or  [UX, UY, UZ] = PROBEAVERFF(...) does
%   the same for a 2-component or a 3-component array of vector fields.
%
%   The value of the field at the location of the probe is interpolated
%   using Matlab's function INTERP2.
%
%   See also SHOWF, PROBEF, SPATIOTEMPF, MATRIXCOORDF, EXTRACTF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.00,  Date: 2017/01/31
%   This function is part of the PIVMat Toolbox


% History:
% 2017/01/31: v1.00, first version.


comp = numcompfield(f(1));

if nargin==1
    disp('Select a rectangle');
    rect = getrect;
    hold on
    rectangle('position',rect);
    hold off
    rect(3) = rect(1)+rect(3);
    rect(4) = rect(2)+rect(4);
    disp(['Selected rectangle: [' num2str(rect) ']']);
end

for i = 1:numel(f)
    fprobe = extractf(f(i),rect,'phys');
    switch comp
        case 1
            s(i) = mean(fprobe.w(:));
        case 2
            ux(i) = mean(fprobe.ux(:));
            uy(i) = mean(fprobe.uy(:));
        case 3
            ux(i) = mean(fprobe.ux(:));
            uy(i) = mean(fprobe.uy(:));
            uz(i) = mean(fprobe.uz(:));
    end
end

if nargout==1
    varargout{1} = s;
elseif nargout==2
    varargout{1} = ux;
    varargout{2} = uy;
elseif nargout==3
    varargout{1} = ux;
    varargout{2} = uy;     
    varargout{3} = uz;
end

