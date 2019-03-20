function mat=gaussmat(sigma,matsize,varargin)
%GAUSSMAT  Normalized square Gaussian matrix.
%   M = GAUSSMAT(SIGMA) returns a 2D normalized Gaussian of width SIGMA.
%   The size N of the matrix M is chosen by default as N=CEIL(SIGMA*2)*2+1.
%   The matrix M is normalized, such that SUM(SUM(M))=1.
%
%   M = GAUSSMAT(SIGMA, N) does the same, but constrains the size of the
%   matrix M to be N*N. Typical values for N are around 3 to 10 times
%   SIGMA. It is better to choose an odd value for N, so that the central
%   matrix element is the maximum of the Gaussian.
%
%   M = GAUSSMAT(...,'igauss') computes the gaussian as the derivative of
%   the error function, in order to minimize the discretisation effects. 
%
%   GAUSSMAT(0) returns 1.
% 
%   Examples: imagesc(gaussmat(3));
%
%             s=vec2scal(loadvec('B00001.vec'),'norm');  
%             s.w=conv2(s.w,gaussmat(1.3),'same');
%             showscal(s);
%
%   Acknowledgmenets: A. Muller, for the formula of the derivative of the
%   error function.
%
%   F. Moisy
%   Revision: 1.06,  Date: 2006/09/12
%
%   See also FILTERF, ADDNOISEF, CONV2.


% History:
% 2003/??/??: v1.00, first version.
% 2004/04/23: v1.01.
% 2004/06/24: v1.02, changed help text and added an exist test.
% 2005/02/23: v1.03, pre-allocate mat (to save time).
% 2005/09/03: v1.04, cosmetics.
% 2005/10/14: v1.05, id.
% 2006/09/12: v1.06, new option 'igauss' 


% error(nargchk(1,3,nargin));

if nargin==1, matsize=ceil(sigma*2)*2+1; end;

if ~(sigma==0)
    wmid=(matsize+1)/2;
    mat=zeros(matsize,matsize); % pre-allocate, 23/02/2005 FM
    for i=1:matsize
        for j=1:matsize
            if any(strncmpi(varargin,'igauss',2))
                r=sqrt((i-wmid)^2+(j-wmid)^2);
                mat(i,j)= erf((r+0.5)/sqrt(2)/sigma) - erf((r-0.5)/sqrt(2)/sigma);
            else    
                mat(i,j)=exp(-((i-wmid)^2+(j-wmid)^2)/(2*sigma^2));
            end
        end
    end
    mat=mat/sum(mat(:));
else
    mat=1;
end;
