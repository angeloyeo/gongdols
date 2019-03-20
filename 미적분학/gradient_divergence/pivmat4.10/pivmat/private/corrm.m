function c = corrm(varargin)
%CORRM MATRIX correlation
%   C = CORRM(X, DIM) returns the autocorrelation of matrix X along
%   the dimension DIM. C is a matrix of size (M, 2N-1) for DIM=1, or (2M-1,
%   N) for DIM=2,  where (M,N) is the size of X.
%
%   F. Moisy
%   Revision: 1.00,  Date: 2006/05/19.


% History:
% 2006/05/19: v1.00, first version.

% error(nargchk(1,3,nargin));

x=varargin{1};
if nargin==1,
    dim=1;
else
    if isnumeric(varargin{2})
        dim=varargin{2};
    else
        dim=1;
    end
end

m=size(x,1);
n=size(x,2);

if dim==2
    c = zeros(m, 2*n-1);
    for i=1:m,
        c(i,(1:2*n-1)) = corrx(x(i,:));
    end
    if any(strncmpi(varargin,'half',1))
        c=c(:,n:end);
    end
elseif dim==1
    c = zeros(2*m-1, n);
    for i=1:n,
        c((1:2*m-1),i) = corrx(x(:,i));
    end
    if any(strncmpi(varargin,'half',1))
        c=c(m:end,:);
    end
else
    error('DIM must be 1 or 2.');
end

