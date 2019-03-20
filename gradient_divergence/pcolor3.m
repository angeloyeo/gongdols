function h = pcolor3(varargin) 
% pcolor3 plots a 3D data volume as 100 color-scaled semitransparent
% surface planes in each dimension.  
% 
%% Syntax
% 
%  pcolor3(V)
%  pcolor3(X,Y,Z,V) 
%  pcolor3(...,'alpha',AlphaValue)
%  pcolor3(...,'edgealpha',EdgeAlphaValue)
%  pcolor3(...,'alphalim',AlphaLimits)
%  pcolor3(...,InterpolationMethod)
%  pcolor3(...,'N',NumberOfSlices)
%  pcolor3(...,'Nx',NumberOfXSlices)
%  pcolor3(...,'Ny',NumberOfYSlices)
%  pcolor3(...,'Nz',NumberOfZSlices)
%  h = pcolor3(...)
% 
%% Description
% 
% pcolor3(V) plots a field of 3D volume V. 
%
% pcolor3(X,Y,Z,V) plots 3D volume V at locations given by X,Y,Z. X, Y, and
% Z can be 3D matrices matching the dimensions of V, or 1D arrays. 
%
% pcolor3(...,'alpha',AlphaValue) specifies a volume transparency value between 0
% (completely transparent) and 1 (completely opaque). Default AlphaValue is
% 0.01. This value may seem surprisingly low, but remember that you'll be
% looking through 100 slices--they add up. 
% 
% pcolor3(...,'edgealpha',EdgeAlphaValue) specifies transparency of sides of
% the volume faces of the volume. An EdgeAlphaValue greater than the volume
% AlphaValue helps define corners and edges, especially in the presence of
% lighting objects. Default EdgeAlphaValue is 0.05. 
% 
% pcolor3(...,'alphalim',AlphaLimits) scales transparency values with
% values of V. This can help highlight a variable of interest by making
% low V values invisible. AlphaLimits is a two-element array
% corresponding of values in V. If AlphaLimits is 'auto',
% AlphaLimits is taken as [min(V(:)) max(V(:))]. 
% 
%     Tip: If interesting values diverge about an uninteresting mean (e.g., 
%     temperature of 25 is not interesting whereas T = 10 is interesting and T = 40 is also
%     interesting), use 'alphalim',[25 40] and select a colormap that
%     diverges from 25. Although T = 10 is well below the minimum
%     AlphaLimits, 10 and 40 are equidistant from 25 and are therefore given
%     equal opacity. 
%
% pcolor3(...,InterpolationMethod) specifies an interpolation method as
%   'linear'  trilinear slice interpolation (default), 
%   'cubic'   tricubic slice interpolation,
%   'nearest' nearest-neighbor slice interpolation, or
%   'direct'  plots data directly instead of interpolated slices.
%
% pcolor3(...,'N',NumberOfSlices) specifies a number of slices in each
% direction. Default value is 100. Increasing number of slices can make a
% smoother, higher quality graphic, but may slow performance. 
%
% pcolor3(...,'Nx',NumberOfXSlices) specifies a number of slices in the x
% direction. Default value is 100. 
%
% pcolor3(...,'Ny',NumberOfYSlices) specifies a number of slices in the y
% direction. Default value is 100. 
%
% pcolor3(...,'Nz',NumberOfZSlices) specifies a number of slices in the z
% direction. Default value is 100. 
% 
% h = pcolor3(...) returns a vector of handles to surface graphics objects. 
% 
%% Examples (Type showdemo pcolor3_documentation for more examples. )
% 
% % Using this sample data:  
%   [x,y,z] = meshgrid(-1:.2:3,-2:.25:2,-2:.16:2);
%   v = x.*exp(-x.^2-y.^2-z.^2);
% 
% % Plot a simple field: 
% 
%   pcolor3(v) 
% 
% % Or specify x,y,z values and set alpha limits:   
% 
%   pcolor3(x,y,z,v,'alphalim',[0 0.2],'cubic','edgealpha',.1)
%   camlight
%   view(-34,56)
% 
%% Author Info
% This function was written by Chad A. Greene of the University of 
% Texas at Austin's Institute for Geophysics (UTIG) March 2015. 
% http://www.chadagreene.com
% 
% See also slice, surf, alpha. 
 
%% Initial input checks: 
 
assert(nargin>0,'pcolor3 requires at least one input.') 
assert(isnumeric(varargin{1})==1,'First argument of pcolor3 must be numeric.') 
 
if ~verLessThan('matlab','8.4.0')
    warning('The pcolor3 function does not work quite right on Matlab R2014b.') 
end
 
%% Set defaults: 
 
Alpha = 0.01; 
EdgeAlpha = 0.05; 
nx = 100; 
ny = 100; 
nz = 100; 
InterpolationMethod = 'linear'; 
setAlphaLim = false; 
 
%% Parse inputs: 
    
% Is input format pcolor3(X,Y,Z,V,...) or simply pcolor3(V,...)? 
if nargin>1 && isnumeric(varargin{2})
    assert(nargin>3,'Input error. If the second input to pcolor3 is numeric, inputs are assumed to be in the form pcolor3(X,Y,Z,V,...). You have either entered too few or too many inputs.')
    X = varargin{1}; 
    Y = varargin{2}; 
    Z = varargin{3}; 
    V = varargin{4}; 
    assert(isnumeric(Z)==1,'The pcolor3 function has interpreted inputs in the form pcolor3(X,Y,Z,V,...), but your third input here is not numeric. I am confused.') 
    assert(isnumeric(V)==1,'The pcolor3 function has interpreted inputs in the form pcolor3(X,Y,Z,V,...), but your fourth input here is not numeric. I am confused.') 
else
    V = varargin{1}; 
    [X,Y,Z] = meshgrid(1:size(V,2),1:size(V,1),1:size(V,3)); 
end
 
% Set user-defined volume (body) transparency: 
tmp = strcmpi(varargin,'alpha'); 
if any(tmp)
    Alpha = varargin{find(tmp)+1}; 
    assert(Alpha>=0,'Alpha value must be between zero and one.')
    assert(Alpha<=1,'Alpha value must be between zero and one.')
end
 
% Set user-defined edge (sides, top, and bottom) transparency: 
tmp = strcmpi(varargin,'edgealpha'); 
if any(tmp)
    EdgeAlpha = varargin{find(tmp)+1}; 
    assert(EdgeAlpha>=0,'EdgeAlpha value must be between zero and one.')
    assert(EdgeAlpha<=1,'EdgeAlpha value must be between zero and one.')
end
 
% Set user-defined volume (body) transparency: 
tmp = strcmpi(varargin,'alphalim'); 
if any(tmp)
    AlphaLim = varargin{find(tmp)+1}; 
    setAlphaLim = true; 
end
 
% Number of slices:
tmp = strcmpi(varargin,'n'); 
if any(tmp)
    nx = varargin{find(tmp)+1}; 
    ny = nx; 
    nz = nx; 
    assert(isscalar(nx)==1,'Invalid input after N declaration. Must be a scalar.') 
    assert(nx>=0,'Number of slices N must be greater than zero.')
end
 
tmp = strcmpi(varargin,'nx'); 
if any(tmp)
    nx = varargin{find(tmp)+1}; 
    assert(isscalar(nx)==1,'Invalid input after Nx declaration. Must be a scalar.') 
    assert(nx>=0,'Number of slices Nx must be greater than zero.')
end
 
tmp = strcmpi(varargin,'ny'); 
if any(tmp)
    ny = varargin{find(tmp)+1}; 
    assert(isscalar(ny)==1,'Invalid input after Ny declaration. Must be a scalar.') 
    assert(ny>=0,'Number of slices Ny must be greater than zero.')
end
 
tmp = strcmpi(varargin,'nz'); 
if any(tmp)
    nz = varargin{find(tmp)+1}; 
    assert(isscalar(nz)==1,'Invalid input after Nz declaration. Must be a scalar.') 
    assert(nz>=0,'Number of slices Nz must be greater than zero.')
end
 
% Interpolation method: 
if any(strncmpi(varargin,'cubic',3))
    InterpolationMethod = 'cubic'; 
end
if any(strncmpi(varargin,'nearest',4))
    InterpolationMethod = 'nearest'; 
end
if any(strncmpi(varargin,'direct',3))
    InterpolationMethod = 'direct'; 
end
 
%% Some more checks now that all inputs are parsed: 
 
assert(ndims(V)==3,'Input volume matrix V must be 3 dimensional.') 
% Allow inputs as vectors: 
if isvector(X) 
    assert(isvector(Y)==1,'If X is a vector, Y must be a vector. Check your input X,Y,Z values.')
    assert(isvector(Z)==1,'If X is a vector, Z must be a vector. Check your input X,Y,Z values.')
    [X,Y,Z] = meshgrid(X,Y,Z); 
end
 
% Make sure no 2D X grid slipped in there: 
assert(ndims(X)==3,'Currently, X must be 1D or 3D with dimensions corresponding to V. This might change in the future, but until then, use meshgrid.') 
 
%% 
switch InterpolationMethod
    case 'direct'
        nx = size(V,2); 
        ny = size(V,1); 
        nz = size(V,3); 
        
        % Make direct alpha roughly the same total value as when 300 slices are interpolated:   
        Alpha = Alpha*(300/(nx+ny+nz)); 
        hold on
        
        % Set 3D view if not already 3D: 
        [az,el] = view; 
        if az==0 && el==90
            view(3)
        end
        
        % Plot x slices: 
        for k = 1:nx
            h(k) = surface(squeeze(X(:,k,:)),squeeze(Y(:,k,:)),squeeze(Z(:,k,:)),squeeze(V(:,k,:))); 
        end
        
        % Plot y slices: 
        for k2 = 1:ny
            k = k+1; 
            h(k) = surface(squeeze(X(k2,:,:)),squeeze(Y(k2,:,:)),squeeze(Z(k2,:,:)),squeeze(V(k2,:,:))); 
        end
        
        % Plot z slices: 
        for k3 = 1:nz
            k = k+1; 
            h(k) = surface(squeeze(X(:,:,k3)),squeeze(Y(:,:,k3)),squeeze(Z(:,:,k3)),squeeze(V(:,:,k3))); 
        end
        grid on
        
    otherwise
        
        % Generate slices: 
        xslice = linspace(min(X(:)),max(X(:)),nx); 
        yslice = linspace(min(Y(:)),max(Y(:)),ny); 
        zslice = linspace(min(Z(:)),max(Z(:)),nz); 
 
        % Plot slices: 
        h = slice(X,Y,Z,V,xslice,yslice,zslice,InterpolationMethod); 
 
end
 
% Set formatting: 
shading interp
 
if setAlphaLim
    
    if strcmpi(AlphaLim,'auto')
        AlphaLim = [min(V(:)) max(V(:))];
    end
    assert(numel(AlphaLim)==2,'AlphaLim can only be a two-element array or ''auto''.')
    assert(AlphaLim(2)>AlphaLim(1),'AlphaLim values must be in the order [minAlphaLim maxAlphaLim].')
    
    switch InterpolationMethod
        case 'direct'
            
            % Plot x slices: 
            for k = 1:nx
                set(h(k),'alphadata',Alpha*abs((squeeze(V(:,k,:))-AlphaLim(1)))/(AlphaLim(2)-AlphaLim(1)),...
                    'AlphaDataMapping','none','facealpha','flat','edgecolor','none')
            end
 
            % Plot y slices: 
            for k2 = 1:ny
                k = k+1; 
                set(h(k),'alphadata',Alpha*abs((squeeze(V(k2,:,:))-AlphaLim(1)))/(AlphaLim(2)-AlphaLim(1)),...
                    'AlphaDataMapping','none','facealpha','flat','edgecolor','none')
            end
 
            % Plot z slices: 
            for k3 = 1:nz
                k = k+1; 
                set(h(k),'alphadata',Alpha*abs((squeeze(V(:,:,k3))-AlphaLim(1)))/(AlphaLim(2)-AlphaLim(1)),...
                    'AlphaDataMapping','none','facealpha','flat','edgecolor','none')
            end
            
        otherwise
            
            % Plot x slices: 
            for k = 1:nx
                Vi = get(h(k),'Cdata'); 
                set(h(k),'alphadata',Alpha*abs((Vi-AlphaLim(1)))/(AlphaLim(2)-AlphaLim(1)),...
                    'AlphaDataMapping','none','facealpha','flat','edgecolor','none')
            end
 
            % Plot y slices: 
            for k2 = 1:ny
                k = k+1; 
                Vi = get(h(k),'Cdata'); 
                set(h(k),'alphadata',Alpha*abs((Vi-AlphaLim(1)))/(AlphaLim(2)-AlphaLim(1)),...
                    'AlphaDataMapping','none','facealpha','flat','edgecolor','none')
            end
 
            % Plot z slices: 
            for k3 = 1:nz
                k = k+1; 
                Vi = get(h(k),'Cdata'); 
                set(h(k),'alphadata',Alpha*abs((Vi-AlphaLim(1)))/(AlphaLim(2)-AlphaLim(1)),...
                    'AlphaDataMapping','none','facealpha','flat','edgecolor','none')
            end
    end
            
else
    
    set(h,'edgecolor','none','facealpha',Alpha)
    
 
end
 
% Set different transparency (typically slightly more opaque) for sides, top and bottom: 
set(h([1 nx nx+1 nx+ny nx+ny+1 nx+ny+nz]),'facealpha',EdgeAlpha)
 
 
%% Clean up: 
 
if nargout==0
    clear h
end
 
end
