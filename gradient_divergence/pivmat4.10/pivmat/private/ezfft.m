function [w,e] = ezfft(varargin)
%EZFFT  Easy to use Power Spectrum
%   EZFFT(T,U) plots the power spectrum of the signal U(T) , where T is a
%   'time' and U is a real signal (T can be considered as a space
%   coordinate as well). If T is a scalar, then it is interpreted as the
%   'sampling time' of the signal U.  If T is a vector, then it is
%   interpreted as the 'time' itself. In this latter case, T must be
%   equally spaced (as obtained by LINSPACE for instance), and it must
%   have the same length as U. If T is not specified, then a 'sampling
%   time' of unity (1 second for instance) is taken. Windowing
%   (appodization) can be applied to reduce border effects (see below).
%
%   [W,E] = EZFFT(T,U) returns the power spectrum E(W), where E is the
%   energy density and W the pulsation 'omega'.  W is *NOT* the frequency:
%   the frequency is W/(2*pi). If T is considered as a space coordinate,
%   W is a wave number (usually noted K = 2*PI/LAMBDA, where LAMBDA is a
%   wavelength).
%
%   EZFFT(..., 'Property1', 'Property2', ...) specifies the properties:
%    'hann'    applies a Hann appodization window to the data (reduces
%              aliasing).
%    'disp'    displays the spectrum (by default if no output argument)
%    'freq'    the frequency f is displayed instead of the pulsation omega
%              (this applies for the display only: the output argument
%              remains the pulsation omega, not the frequency f).
%    'space'   the time series is considered as a space series. This simply
%              renames the label 'omega' by 'k' (wave number) in the plot,
%              but has no influence on the computation itself.
%    'handle'  returns a handle H instead of [W,E] - it works only if the
%              properties 'disp' is also specified. The handle H is useful
%              to change the line properties (color, thickness) of the
%              plot (see the example below).
%
%   The length of the vectors W and E is N/2, where N is the length of U
%   (this is because U is assumed to be a real signal.) If N is odd, the
%   last point of U and T are ignored. If U is not real, only its real part
%   is considered.
%
%       W(1) is always 0.  E(1) is the energy density of the average of U
%         (when plotted in log coordinates, the first point is W(2), E(2)).
%       W(2) is the increment of pulsation, Delta W, given by 2*PI/Tmax
%       W(end), the highest measurable pulsation, is PI/DT, where DT is the
%          sampling time (Nyquist theorem).
%
%   Parseval Theorem (Energy conservation):
%   For every signal U, the 'energy' computed in the time domain and in the
%   frequency domain are equal,
%       MEAN(U.^2) == SUM(E)*W(2)
%   where W(2) is the pulsation increment Delta W.
%   Note that, depending on the situation considered, the physical 'energy'
%   is usually defined as 0.5*MEAN(U.^2). Energy conservation only applies
%   if no appodization of the signal (windowing) is used. Otherwise, some
%   energy is lost in  the appodization, so the spectral energy is lower
%   than the actual one.
%
%   As for FFT, the execution time depends on the length of the signal.
%   It is fastest for powers of two.
%
%   Example 1:  simple display of a power spectrum
%      t = linspace(0,400,2000);
%      u = 0.2 + 0.7*sin(2*pi*t/47) + cos(2*pi*t/11);
%      ezfft(t,u);
%
%   Example 2:  how to change the color of the plot
%      h = ezfft(t,u,'disp','handle');
%      set(h,'Color','red');
%
%   Example 3:  how to use the output of ezfft
%      [w,e] = ezfft(t,u,'hann');
%      loglog(w,e,'b*');
%
%   See also FFT


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.01,  Date: 2008/11/20
%   This function is part of the EzyFit Toolbox


% History:
% 2008/11/19: v1.00, first version.
% 2008/11/20: v1.01, includes property 'space'. Help text improved


% error(nargchk(1,inf,nargin));

if nargin==1
    u=varargin{1};
    dt=1;
else
    dt=varargin{1};
    u=varargin{2};
end

if length(dt)>1
    if length(u)~=length(dt)
        error('Vectors T and U should be of equal length.');
    end
    dt = abs(dt(2)-dt(1));
end

% works only with vectors of even length
if mod(length(u),2)~=0;
    u=u(1:(end-1));
end

u=real(u);

% works with line vector (otherwise transpose it)
if size(u,2)==1
    u=u';
end

% signal appodization with a Hann window
if any(strcmpi(varargin,'hann'))
    u=u.*hann(length(u))';
end

n = length(u)/2;  % length of the output fft (half the signal length)
w = linspace(0,pi,n)/dt;   % output pulsation

e = abs(fft(u)).^2;   % power spectrum
e = 2*e(1:n) / (2*n)^2 / w(2);  % normalisation
e(1)=e(1)/2;    % mode w=0 was counted twice is the previous line

% display
if nargout==0 || any(strncmpi(varargin,'disp',1))
    if any(strncmpi(varargin,'freq',1)) && any(strncmpi(varargin,'space',1))
        error('Properties ''freq'' and ''space'' cannot be specified simultaneously');
    elseif any(strncmpi(varargin,'freq',1)) && ~any(strncmpi(varargin,'space',1))
        hh=loglog(w/(2*pi),2*pi*e);
        xlabel('f = \omega / 2\pi');
        ylabel('E(f)');
    elseif ~any(strncmpi(varargin,'freq',1)) && any(strncmpi(varargin,'space',1))
        hh=loglog(w,e);
        xlabel('k');
        ylabel('E(k)');
    else
        hh=loglog(w,e);
        xlabel('\omega');
        ylabel('E(\omega)');
    end
end

% output
if nargout>0 && any(strncmpi(varargin,'handle',4)) && any(strncmpi(varargin,'disp',1))
    w=hh;
    clear e
    return
end

if nargout==0
    clear w e
end


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

