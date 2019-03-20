function y=hann(n)
%HANN  Window Hann function
%   Y = HANN(N) returns a N-point Hann function (usually N is a power of
%   2), ie a discretization of Y(X) = (1 - COS (2*PI*X))/2.
%
%   The HANN function is used to window (apodize) finite samples of signal
%   in order to avoid high frequency oscillations in Fourier transform.
%
%   Example:  plot(hann(128));
%
%   F. Moisy
%   Revision: 1.03,  Date: 2006/03/03
%
%   See also FFT.

% History:
% 2004/09/17: v1.00, first version.
% 2005/23/02: v1.01, cosmetics
% 2005/09/03: v1.02, id.
% 2006/03/03: v1.03, bug fixed 0:n-1

error(nargchk(1,1,nargin));
y=0.5*(1-cos(2*pi*(0:n-1)/(n-1)))';
