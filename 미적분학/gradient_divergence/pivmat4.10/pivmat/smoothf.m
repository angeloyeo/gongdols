function sf=smoothf(f,n,opt)
%SMOOTHF  (Temporal) smooth of a vector/scalar field.
%   SF = SMOOTHF(F,N) returns the (temporal) smooth of the vector or scalar
%   fields F (also called "Running average"), computed over N consecutive
%   fields, using the function AVERF. The field number i is given by
%       SF(i) = AVERF(F(i:(i+N-1)));
%   If the length of the input array F is L, the length of the smoothed
%   array SF is L - 2*CEIL(N/2). (It is better to use an odd value for N).
%
%   By default, SMOOTHF considers that the zero elements of F are erroneous,
%   and does not include them in the computations. If however you want to
%   force the zero elements to be included in the computations, specify
%   SMOOTHF(F,N,'0').
%
%   If no output argument, the result is displayed by SHOWF.
%
%   Example:
%     v = loadvec('*.vc7');
%     sf = smoothf(v, 5);
%     showf(sf);
%
%   See also AVERF, TEMPFILTERF, SPAVERF, FILTERF, BWFILTERF,
%   TIMEDERIVATIVEF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.11,  Date: 2009/02/18
%   This function is part of the PIVMat Toolbox


% History:
% 2007/10/03: v1.00, first version.
% 2007/10/05: v1.10, based now on AVERF. Does not include zero elements.
% 2009/02/18: v1.11, bug help text fixed


%error(nargchk(1,3,nargin));

if (ischar(f) || iscellstr(f) || isnumeric(f))
    f=loadvec(f);
end 

if nargin<=1
    n=3;
end
if nargin<=2
    opt='';
end

cn=floor(n/2);
nmax = length(f);
sf=f((1+cn):(nmax-cn));  % output (shifted) field

for i=1:length(sf)
    sf(i) = averf(f(i:(i+n-1)),opt);
end

if nargout==0
    showf(sf);
    clear sf
end
