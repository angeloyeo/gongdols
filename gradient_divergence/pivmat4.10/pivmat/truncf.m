function tf=truncf(f,varargin)
%TRUNCF  Truncate a vector/scalar field.
%   TF = TRUNCF(F) truncates the vector/scalar field(s) F to the largest
%   centered square.
%
%   TF = TRUNCF(F, CUT), in addition to the truncation to the largest
%   centered square, also eliminates bands of width CUT along the borders of
%   the field (CUT is 0 by default). This is useful when boundary effects
%   are expected (e.g., using BWFILTERF). By default, CUT is specified in
%   mesh units, unless the option 'phys' is specified (e.g.,
%   TRUNCF(F, CUT, 'phys')).
%
%   TF = TRUNCF(F, 'nonzero') truncates the vector/scalar field(s) F to the
%   smallest rectangular area excluding zero (erroneous or masked)
%   elements. This may be useful after using ROTATEF.
%
%   If no output argument, the result is displayed by SHOWF.
%
%   See also EXTRACTF, ROTATEF, RESIZEF, FLIPF, SHIFTF, REMAPF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.40,  Date: 2013/02/22
%   This function is part of the PIVMat Toolbox


% History:
% 2004/04/30: v1.00, first version.
% 2004/06/24: v1.01, added an exist test.
% 2005/02/23: v1.02, cosmetics
% 2005/07/26: v1.03, added history.
% 2005/09/06: v1.04, added arg check.
% 2005/09/15: v1.05, no recursive call.
% 2005/10/11: v1.10, now called truncf (from truncvec 1.05, 2005/09/15)
% 2006/05/19: v1.20, new option 'nonzero'.
% 2006/07/21: v1.21, cut may be given in physical or mesh units
% 2009/08/28: v1.30, bug fixed when nx<ny (thanks Alex)
% 2009/12/02: v1.31, help text clarified
% 2013/02/22: v1.40, works with 3D fields

%error(nargchk(1,3,nargin));

if (ischar(f) || iscellstr(f))
    f=loadvec(f);
end

if nargin==1
    cut=0;
end

if nargin>=2  % new v1.20
    if isnumeric(varargin{1})
        cut=varargin{1};
    else
        cut=0;
    end
end

if any(strncmpi(varargin,'phys',1))
    cut = round(cut / (f(1).x(2)-f(1).x(1))); % convert in mesh units
end

tf=f;

vecmode = isfield(f(1),'vx');   % 1 for vector field, 0 for scalar field

nx=length(f(1).x);
ny=length(f(1).y);
dn=floor((nx-ny)/2);

if dn >= 0 % landscape image
    firstRow = 1+dn+cut;
    lastRow =  dn+ny-cut;
    firstCol = (1+cut);
    lastCol = (ny-cut);
else % portrait image
    firstRow = 1+cut;
    lastRow =  nx-cut;
    firstCol = max(1+dn+cut,1); % at least 1
    lastCol = min(dn+ny-cut,ny); % or ny at most
end


for i=1:length(f)
    if any(strncmpi(varargin,'nonzero',4)) % extract the smallest rectangle with non zero elements
        if vecmode
            if isfield(f(i),'vz')
                hornz = find((sum(f(i).vx,2)+sum(f(i).vy,2)+sum(f(i).vz,2))~=0);
                vernz = find((sum(f(i).vx,1)+sum(f(i).vy,1)+sum(f(i).vz,1))~=0);
                tf(i).vx = f(i).vx(hornz(1):hornz(end), vernz(1):vernz(end));
                tf(i).vy = f(i).vy(hornz(1):hornz(end), vernz(1):vernz(end));
                tf(i).vz = f(i).vz(hornz(1):hornz(end), vernz(1):vernz(end));
            else
                hornz = find((sum(f(i).vx,2)+sum(f(i).vy,2))~=0);
                vernz = find((sum(f(i).vx,1)+sum(f(i).vy,1))~=0);
                tf(i).vx = f(i).vx(hornz(1):hornz(end), vernz(1):vernz(end));
                tf(i).vy = f(i).vy(hornz(1):hornz(end), vernz(1):vernz(end));                
            end
        else
            hornz = find(sum(f(i).w,2)~=0);
            vernz = find(sum(f(i).w,1)~=0);
            tf(i).w = f(i).w(hornz(1):hornz(end), vernz(1):vernz(end));
        end
        tf(i).x = f(i).x(hornz(1):hornz(end));
        tf(i).y = f(i).y(vernz(1):vernz(end));

    else % cut lateral bands of given width    
        if vecmode
            tf(i).vx = f(i).vx(firstRow:lastRow,firstCol:lastCol);
            tf(i).vy = f(i).vy(firstRow:lastRow,firstCol:lastCol);
            if isfield(f(i),'vz')
                tf(i).vz = f(i).vz(firstRow:lastRow,firstCol:lastCol);
            end
        else
            tf(i).w = f(i).w(firstRow:lastRow,firstCol:lastCol);
        end
        tf(i).x = f(i).x(firstRow:lastRow);
        tf(i).y = f(i).y(firstCol:lastCol);
    end
    tf(i).history = {f(i).history{:} ['truncf(ans, ' varargin{:} ')']}';
    
end

if nargout==0
    showf(tf);
    clear tf
end
