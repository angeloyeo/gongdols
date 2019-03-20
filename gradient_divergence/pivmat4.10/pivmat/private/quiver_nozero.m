function hh = quiver_nozero(x,y,dx,dy,varargin)
%QUIVER_NOZERO   Quiver plot without display of zero vectors
%   QUIVER_NOZERO works exactly as Matlab built-in QUIVER function, except
%   that the vectors of zero norm are not displayed.
%
%   F. Moisy
%   Revision: 1.00,  Date: 2008/10/17.
%
%   See also QUIVER, SHOWVEC.

% History:
% 2008/10/17: v1.00, first version.

ind = find(dx.^2+dy.^2~=0);
h=quiver(x(ind),y(ind),dx(ind),dy(ind),varargin{:});
if nargout
    hh=h;
end
