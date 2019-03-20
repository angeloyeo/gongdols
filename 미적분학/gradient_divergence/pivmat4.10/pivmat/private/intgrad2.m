function fhat = intgrad2(fx,fy,dx,dy,f11)
% intgrad: generates a 2-d surface, integrating gradient information.
% usage: fhat = intgrad2(fx,fy)
% usage: fhat = intgrad2(fx,fy,dx,dy)
% usage: fhat = intgrad2(fx,fy,dx,dy,f11)
%
% arguments: (input)
%  fx,fy - (ny by nx) arrays, as gradient would have produced. fx and
%          fy must both be the same size. Note that x is assumed to
%          be the column dimension of f, in the meshgrid convention.
%
%          nx and ny must both be at least 2.
%
%          fx and fy will be assumed to contain consistent gradient
%          information. If they are inconsistent, then the generated
%          gradient will be solved for in a least squares sense.
%
%          Central differences will be used where possible.
%
%     dx - (OPTIONAL) scalar or vector - denotes the spacing in x
%          if dx is a scalar, then spacing in x (the column index
%          of fx and fy) will be assumed to be constant = dx.
%          if dx is a vector, it denotes the actual coordinates
%          of the points in x (i.e., the column dimension of fx
%          and fy.) length(dx) == nx
%
%          DEFAULT: dx = 1
%
%     dy - (OPTIONAL) scalar or vector - denotes the spacing in y
%          if dy is a scalar, then the spacing in x (the row index
%          of fx and fy) will be assumed to be constant = dy.
%          if dy is a vector, it denotes the actual coordinates
%          of the points in y (i.e., the row dimension of fx
%          and fy.) length(dy) == ny
%
%          DEFAULT: dy = 1
%
%    f11 - (OPTIONAL) scalar - defines the (1,1) eleemnt of fhat
%          after integration. This is just the constant of integration.
%
%          DEFAULT: f11 = 0
%
% arguments: (output)
%   fhat - (nx by ny) array containing the integrated gradient
%
% Example usage 1: (Note x is uniform in spacing, y is not.)
%  xp = 0:.1:1;
%  yp = [0 .1 .2 .4 .8 1];
%  [x,y]=meshgrid(xp,yp);
%  f = exp(x+y) + sin((x-2*y)*3);
%  [fx,fy]=gradient(f,.1,yp);
%  tic,fhat = intgrad2(fx,fy,.1,yp,1);toc
%  
%  Time required was 0.06 seconds
%
% Example usage 2: Large grid, 101x101
%  xp = 0:.01:1;
%  yp = 0:.01:1;
%  [x,y]=meshgrid(xp,yp);
%  f = exp(x+y) + sin((x-2*y)*3);
%  [fx,fy]=gradient(f,.01);
%  tic,fhat = intgrad2(fx,fy,.01,.01,1);toc
%  
%  Time required was 4 seconds

% size 
if (length(size(fx))>2) || (length(size(fy))>2)
  error 'fx and fy must be 2d arrays'
end
[ny,nx] = size(fx);
if (nx~=size(fy,2)) || (ny~=size(fy,1)) 
  error 'fx and fy must be the same sizes.'
end
if (nx<2) || (ny<2)
  error 'fx and fy must be at least 2x2 arrays'
end

% supply defaults if needed
if (nargin<3) || isempty(dx)
  % default x spacing is 1
  dx = 1;
end
if (nargin<4) || isempty(dy)
  % default y spacing is 1
  dy = 1;
end
if (nargin<5) || isempty(f11)
  % default integration constant is 0
  f11 = 0;
end

% if scalar spacings, expand them to be vectors
dx=dx(:);
if length(dx) == 1
  dx = repmat(dx,nx-1,1);
elseif length(dx)==nx
  % dx was a vector, use diff to get the spacing
  dx = diff(dx);
else
  error 'dx is not a scalar or of length == nx'
end
dy=dy(:);
if length(dy) == 1
  dy = repmat(dy,ny-1,1);
elseif length(dy)==ny
  % dy was a vector, use diff to get the spacing
  dy = diff(dy);
else
  error 'dy is not a scalar or of length == ny'
end

if (length(f11) > 1) || ~isnumeric(f11) || isnan(f11) || ~isfinite(f11)
  error 'f11 must be a finite scalar numeric variable.'
end  

% build gradient design matrix, sparsely. Use a central difference
% in the body of the array, and forward/backward differences along
% the edges.

% A will be the final design matrix. it will be sparse.
% The unrolling of F will be with row index running most rapidly.
rhs = zeros(2*nx*ny,1);
% but build the array elements in Af
Af = zeros(2*nx*ny,6);
L = 0;

% do the leading edge in x, forward difference
indx = 1;
indy = (1:ny)';
ind = indy + (indx-1)*ny;
rind = repmat(L+(1:ny)',1,2);
cind = [ind,ind+ny];
dfdx = repmat([-1 1]./dx(1),ny,1);
Af(L+(1:ny),:) = [rind,cind,dfdx];
rhs(L+(1:ny)) = fx(:,1);
L = L+ny;

% interior partials in x, central difference
if nx>2
  [indx,indy] = meshgrid(2:(nx-1),1:ny);
  indx = indx(:);
  indy = indy(:);
  ind = indy + (indx-1)*ny;
  m = ny*(nx-2);
  
  rind = repmat(L+(1:m)',1,2);
  cind = [ind-ny,ind+ny];
  
  dfdx = 1./(dx(indx-1)+dx(indx));
  dfdx = dfdx*[-1 1];
  
  Af(L+(1:m),:) = [rind,cind,dfdx];

  rhs(L+(1:m)) = fx(ind);
  
  L = L+m;
end

% do the trailing edge in x, backward difference
indx = nx;
indy = (1:ny)';
ind = indy + (indx-1)*ny;
rind = repmat(L+(1:ny)',1,2);
cind = [ind-ny,ind];
dfdx = repmat([-1 1]./dx(end),ny,1);
Af(L+(1:ny),:) = [rind,cind,dfdx];
rhs(L+(1:ny)) = fx(:,end);
L = L+ny;

% do the leading edge in y, forward difference
indx = (1:nx)';
indy = 1;
ind = indy + (indx-1)*ny;
rind = repmat(L+(1:nx)',1,2);
cind = [ind,ind+1];
dfdy = repmat([-1 1]./dy(1),nx,1);
Af(L+(1:nx),:) = [rind,cind,dfdy];
rhs(L+(1:nx)) = fy(1,:)';
L = L+nx;

% interior partials in y, use a central difference
if ny>2
  [indx,indy] = meshgrid(1:nx,2:(ny-1));
  indx = indx(:);
  indy = indy(:);
  ind = indy + (indx-1)*ny;
  m = nx*(ny-2);
  
  rind = repmat(L+(1:m)',1,2);
  cind = [ind-1,ind+1];
  
  dfdy = 1./(dy(indy-1)+dy(indy));
  dfdy = dfdy*[-1 1];
  
  Af(L+(1:m),:) = [rind,cind,dfdy];

  rhs(L+(1:m)) = fy(ind);
  
  L = L+m;
end

% do the trailing edge in y, backward diffeence
indx = (1:nx)';
indy = ny;
ind = indy + (indx-1)*ny;
rind = repmat(L+(1:nx)',1,2);
cind = [ind-1,ind];
dfdy = repmat([-1 1]./dy(end),nx,1);
Af(L+(1:nx),:) = [rind,cind,dfdy];
rhs(L+(1:nx)) = fy(end,:)';

% finally, we can build the rest of A itself, in its sparse form.
A = sparse(Af(:,1:2),Af(:,3:4),Af(:,5:6),2*nx*ny,nx*ny);

% Finish up with f11, the constant of integration.
% eliminate the first unknown, as f11 is given.
rhs = rhs - A(:,1)*f11;

% Solve the final system of equations. They will be of
% full rank, due to the explicit integration constant.
% Just use sparse \
fhat = A(:,2:end)\rhs;
fhat = reshape([f11;fhat],ny,nx);


