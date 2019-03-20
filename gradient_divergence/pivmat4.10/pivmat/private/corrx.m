function [c] = corrx(varargin)
%CORRX Vector correlation
%   C = CORRX(X) returns the autocorrelation of vector X.  C is a vector of
%   length 2N-1, where N is the length of X, such that C(N) is the
%   variance of X.  COORX(X,'half') returns only C(N:end).
%
%   C = CORRX(X,Y) returns the correlations of vectors X and Y.
%
%   F. Moisy
%   Revision: 1.20,  Date: 2010/05/04.



% History:
% 2006/05/19: v1.00, first version.
% 2007/04/17: v1.10, also computes an error estimate, dc
% 2010/05/04: v1.20, works with missing data (thanks J.I. Cardesa!)

%error(nargchk(1,3,nargin));

x=varargin{1};
if nargin==1
    y=x;
else
    if isnumeric(varargin{2})
        y=varargin{2};
        if ~isequal(length(x),length(y))
            error('Vectors lengths must agree.');
        end
    else
        y=x;
    end;
end

n=length(x);

% works only with line-vectors:
if size(x,1)~=1
    rv=true;
    x=x';
    y=y';
else
    rv=0;
end

% pads the borders of the 2nd vector with zeros:
pady=[zeros(1,n-1) y zeros(1,n-1)];

c=zeros(1,2*n-1);
% dc=zeros(1,2*n-1);
for i=(-n+1):(n-1)
    
    % modified v1.20 (JI Cardesa):
    pad_array=x.*pady((n-i):(2*n-i-1));
    a=nnz(pad_array);
    if a==0
        N_weight=1;
    else
        N_weight=a;
    end
    c(n+i)=sum(pad_array)/N_weight;
    
    %     dc(n+i) = c(n+i) / sqrt(n-abs(i));  % new v1.10
end

if any(strncmpi(varargin,'half',1))
    c=c(n:end);
    %     dc=dc(n:end);
end

if rv   % if input arg was a raw vector
    c=c';
    %     dc=dc';
end
