function rf=resizef(f,varargin)
%RESIZEF  Resize a vector/scalar field.
%   RF = RESIZEF(F,...) returns resized vector/scalar fields. This function
%   works as IMRESIZE (Image Processing Toolbox is required), but for
%   PIVMat fields. See IMRESIZE for documentation.
%
%   If no output argument, the result is displayed by SHOWF.
%
%   Example:
%     v = loadvec('*.vc7');
%     showf(resizef(v,0.5));
%
%   See also TRUNCF, ROTATEF, SHIFTF, EXTRACTF, IMRESIZE.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.10,  Date: 2013/02/22
%   This function is part of the PIVMat Toolbox


% History:
% 2007/07/16: v1.00, first version.
% 2013/02/22: v1.10, works with 3D fields

% error(nargchk(2,inf,nargin));

if (ischar(f) || iscellstr(f) || isnumeric(f))
    f=loadvec(f);
end
    
vecmode=isfield(f(1),'vx');   % 1 for vector field, 0 for scalar field

rf=f;

for i=1:length(f)
    if vecmode
        rf(i).vx = imresize(f(i).vx, varargin{:});
        rf(i).vy = imresize(f(i).vy, varargin{:});
        if isfield(f(i),'vz')
            rf(i).vz = imresize(f(i).vz, varargin{:});
        end
        rf(i).x = linspace(f(i).x(1), f(i).x(end), size(rf(i).vx,1));
        rf(i).y = linspace(f(i).y(1), f(i).y(end), size(rf(i).vx,2));    
    else
        rf(i).w = imresize(f(i).w, varargin{:});
        rf(i).x = linspace(f(i).x(1), f(i).x(end), size(rf(i).w,1));
        rf(i).y = linspace(f(i).y(1), f(i).y(end), size(rf(i).w,2));
    end

    rf(i).history = {f(i).history{:} ['resizef(ans, [' varargin{:} '])']}';
end

if nargout==0
    showf(rf);
    clear rf
end
