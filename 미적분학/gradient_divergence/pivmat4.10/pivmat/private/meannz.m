function y = meannz(x,dim)
%MEANNZ   Mean value of nonzero elements.
%   For vectors, MEANNZ(X) is the mean value of the nonzero elements in X.
%   For matrices, MEANNZ(X) is a row vector containing the mean value of
%   each column.  For N-D arrays, MEANNZ(X) is the mean value of the
%   nonzero elements along the first non-singleton dimension of X.
%
%   MEANNZ(X,DIM) takes the mean along the dimension DIM of X.
%
%   MEANNZ works like Matlab's MEAN, except that the sums are normalized
%   with the number of non zero elements instead of the number of elements.
%
%   Example: If X = [0 1 2
%                    3 4 5]
%
%   then meannz(X,1) is [3 2.5 3.5] and meannz(X,2) is [1.5
%                                                       4  ]
%
%   F. Moisy
%   Revision: 1.00,  Date: 2005/10/21.
%
%   See also SPAVERF, MEAN.

% History:
% 2005/02/21: v1.00, first version (from MEAN 5.17.4.1)


if nargin==1, 
  % Determine which dimension SUM will use
  dim = min(find(size(x)~=1));
  if isempty(dim), dim = 1; end
end

% logical(a) normally produces a warning.
% the warning has to be temporarilly turned off:
s = warning('query', 'all');
y = sum(x,dim)./sum(logical(x~=0),dim);
y(isnan(y))=0;
warning(s); % restores back the warning mode.

