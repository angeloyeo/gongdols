function [w,etot] = tempspecf(v, freq, varargin)
%TEMPSPECF   Temporal power spectrum of vector / scalar fields
%   TEMPSPECF(V, FS) plots the temporal power spectrum, spatially averaged,
%   of the time series of vector or scalar fields V.  FS is the sampling
%   frequency, in Hz (1 Hz by default). The maximum frenquency is half the
%   sampling frequency (Nyquist theorem).
%
%   Points containing zero or NaN values in their time series are not
%   taken into account (use the option 'zero' to include them)
%
%   TEMPSPECF(V, FS, 'Property1', 'Property2', ...) specifies the properties:
%    - 'hann':   uses a Hann apodization.
%    - 'peak': also shows the frequency and index of the highest peaks.
%    - 'doublex' or 'doubley': for 2-component velocity fields, counts
%      twice the energy spectrum for the x (or y) velocity component
%      (useful in case of statistical axisymmetry).
%    - 'zero': include the points containing zero or NaN values.
%
%   [W, E] = TEMPSPECF(...) returns the result without display, where
%   W = 2*pi*F is the radian frequency (rad/s) and E the energy density.
%
%   Method: each point (i,j) of the fields give a time series. The temporal
%   spectra of each of those time series are computed, and averaged over
%   all points (i,j). By default, if the time series of a point (i,j)
%   contains at least one zero or NaN value, the corresponding spectrum is
%   not computed (unless the option 'zero' is specified).
%
%   Example:
%     tempspecf (v, 2, 'hann', 'peak');
%
%   Parseval theorem (energy conservation) verification, for 2-components
%   fields:
%     [w,e] = tempspecf(v,1);
%     energy_spectral = sum(e)*w(2);
%     [sx, sy] = statf(v);
%     energy_physical = sx.rms^2 + sy.rms^2;
%   Note: for fields containing zero and/or NaN values, the Parseval theorem
%   is not satisfied.
%
%   See also TEMPFILTERF, TEMPCORRF, SPATIOTEMPCORRF, SPECF

%   F. Moisy
%   Revision: 1.33,  Date: 2016/11/17
%   This function is part of the PIVMat Toolbox


% History:
% 2010/04/29: v1.00, first version
% 2010/04/29: v1.10, option 'peaks' added
% 2010/05/05: v1.20, added to the PIVMat toolbox
% 2011/04/20: v1.21, displays only the 20 highest peaks
% 2012/05/02: v1.22, zeros and NaNs are not included in the computation
% 2013/03/13: v1.30, works with 3D fields
% 2016/05/12: v1.31, bug in help text fixed: W instead of F
% 2016/10/14: v1.32, bug fixed for zero/nan elements
% 2016/11/17: v1.33, optimized computation


%error(nargchk(1,inf,nargin));

if (ischar(v) || iscellstr(v) || isnumeric(v))
    v=loadvec(v);
end

if numel(v)<4
    error('Sample size too small.');
end

% default:
if nargin<2, freq = 1; end

if any(strcmpi(varargin,'hann'))
    mode = 'hann';
else
    mode = '';
end

comp = numcompfield(v(1));   %new v1.33

nnz = 0; % nbre of non-zero times series (used for normalization)
for i=1:numel(v(1).x)
    for j=1:numel(v(1).y)
        
        if comp==1
            for t=1:numel(v)
                u(t) = v(t).w(i,j);
            end
            
            w = zeros(1,floor(numel(v)/2));
            es=w;
            if (~any(u==0) && ~any(isnan(u))) || any(strncmpi(varargin,'zero',1))
                [w,es] = ezfft(1/freq,u,mode);
                nnz = nnz+1;
                f = w / (2*pi);
                es = es * (2*pi);
            end       
            e(i,j,:) = es;
        else
            for t=1:numel(v)
                ux(t) = v(t).vx(i,j);
                uy(t) = v(t).vy(i,j);
                if comp==3
                    uz(t) = v(t).vz(i,j);
                end
            end
            
            w = zeros(1,floor(numel(v)/2));
            ex=w;
            ey=w;
            if comp==3
                ez=w;
            end
            if (~any(ux==0) && ~any(uy==0) && ~any(isnan(ux)) && ~any(isnan(uy))) || any(strncmpi(varargin,'zero',1))
                [w,ex] = ezfft(1/freq,ux,mode);
                [w,ey] = ezfft(1/freq,uy,mode);
                f = w / (2*pi);
                ex = ex * (2*pi);
                ey = ey * (2*pi);
                if comp==3
                    [w,ez] = ezfft(1/freq,uz,mode);
                    ez = ez * (2*pi);                 
                end
                nnz = nnz+1;            
            end
       
            if any(strcmpi(varargin,'doublex'))
                e(i,j,:) = 2*ex + ey;
            elseif any(strcmpi(varargin,'doubley'))
                e(i,j,:) = ex + 2*ey;
            else
                if comp==3
                    e(i,j,:) = ex + ey + ez;
                else
                    e(i,j,:) = ex + ey;
                end
            end
            
        end
    end
end

etot = squeeze(sum(sum(e,1),2));  % spatial average
etot = etot / nnz;  % normalize by the number of non-zero time series

if nargout == 0
    plot(f, etot, 'b.-');
    xlabel('f');
    ylabel('E(f)');
end

if any(strncmpi(varargin,'peaks',4))
    indpeak = find(localpeaks(etot));
    
    if true   % keeps only the highest peaks (modified v1.21)
        [etothigh, ix] = sort(etot(indpeak),'descend');
        indpeak = indpeak(ix);
        indpeak = indpeak(1:min([length(indpeak),16]));
    end
    
    hold on
    plot(f(indpeak), etot(indpeak), 'ro');
    for i=1:numel(indpeak)
        text(f(indpeak(i)), etot(indpeak(i)), ...
            ['  ' num2str(f(indpeak(i)),3) ' (' num2str(indpeak(i)) ')']);
    end
    hold off
end


if nargout==0
    clear
end


function peaks = localpeaks(x)

peaks = false(size(x));
peaks(2:end-1) = sign(x(2:end-1)-x(1:end-2)) + sign(x(2:end-1)-x(3:end)) > 0;

