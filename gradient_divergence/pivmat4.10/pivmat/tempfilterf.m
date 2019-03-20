function vf = tempfilterf(v, indexpos, varargin)
%TEMPFILTERF   Fourier temporal filter of a vector/scalar field time series
%   VF = TEMPFILTERF(V, IND) applies a Fourier temporal band-pass filter to
%   the vector or scalar fields time-series V at the frequency specified by
%   the integer index IND. The output field VF is a time series containing
%   the spatial structure of the (eigen)mode corresponding to this frequency.
%   The frequency index IND can be determined from the peaks in the
%   temporal Fourier spectrum, by using the function TEMPSPECF with option
%   'peaks'.
%
%   VF = TEMPFILTERF(V, IND) also works when IND is an array of integers.
%   For instance, IND = [IND1, IND2, IND3 ...] applies a band-pass filters
%   for the frequency indices IND1, IND2, IND3 ...
%   If IND is an interval in the form IFIRST:IEND, it applies a band-pass
%   filtering for the range of frequency indices between IFIRST and IEND
%   (i.e. it removes all the frequencies outside the interval IND). If
%   IFIRST=1, this corresponds to a low-pass filter; if IEND==LENGTH(VF)/2,
%   this corresponds to a high-pass filter.
%
%   Algorithm:  TEMPFILTERF Fourier-transforms the input fields V in the
%   frequency doamin, applies a mask function (=1 for the frequencies
%   specified by the indices IND, and =0 otherwise), and Fourier transform
%   back in the time domain.
%
%   Note that if IND is a single integer, the filter is a Dirac in
%   frequency, so the resulting output time-series is strictly periodic.
%   In this case, only the first period is of interest: it can be recovered
%   using the option VF = TEMPFILTERF(V, IND, 'phaseaverf').  On the other
%   hand, if IND contains more than one frequency index, the result is not
%   periodic in general.
%
%   VF = TEMPFILTERF(V, IND, 'remove') removes all the frequency indices
%   specified by IND (again, IND may be a scalar or an array of integers).
%   This option just takes the complementary of the intial mask function.
%   This is useful to remove the oscillations due to an unwanted vibration
%   in the acquisition system.
%
%   By default, the filtering applies to both positive and negative
%   frequencies, so that the resulting filtered time series is real-valued.
%   It is possible to filter only the positive frequencies by using the
%   following syntax:  VF = TEMPFILTERF(V, IND, 'complex').
%   In this case, the output field VF is complex-valued, i.e. the arrays
%   VF.vx, VF.vy etc contain both the amplitude and phase of the filtered
%   fields. Note that such complex fields can be used for usual computations
%   (AVERF, FILTERF etc), but cannot be directly displayed using SHOWF.
%   See OPERF to extract the real or imaginary part of VF in order to
%   display it using SHOWF.
%
%   If no output argument specified, the filtered field is displayed.
%
%   Example 1: Displays the spatial structure of an eigenmode
%     mv = loadvec('*.vc7');
%     tempspecf(mv, 200, 'peaks');
%       % from this plot, select the index of the peak of interest, e.g. 35
%     m = tempfilterf(mv, 35);
%     showf(m, 'rot');
%
%   See also TEMPSPECF, PHASEAVERF, SMOOTHF, OPERF, SHOWF.

%   F. Moisy
%   Revision: 2.01,  Date: 2016/11/17
%   This function is part of the PIVMat Toolbox


% History:
% 2010/04/29: v1.00, first version (initially EXTRACTMODE)
% 2010/06/01: v1.01, help text improved
% 2010/06/25: v1.10, new option 'phaseaverf'. Field 'history' filled
% 2011/06/16: v1.20, new option 'complex'
% 2015/08/13: v1.30, works with 2D3C fields and scalar fields (A. Campagne)
% 2016/05/11: v2.00, renamed TEMPFILTERF and included in PIVMat.
%                    option 'DELTA' replaced by the use of frequency array.
% 2016/11/17: v2.01, optimizated computation

% error(nargchk(2,5,nargin));

len = numel(v);               % sample size

indexneg = len+2-indexpos;    % negative frequency indeces

% computes the spectral mask
if any(strncmpi(varargin,'complex',2)) % new v1.20
    mask = ismember(1:len, indexpos);  % keep only positive freq
else
    mask = ismember(1:len, [indexneg indexpos]);  % keep both + and - freq
end

% takes the complementary mask if option 'remove' specified (v2.00)
if any(strncmpi(varargin,'remove',2))
    mask = ~mask;
end

% initialise la structure pivmat du mode propre:
vf = v;

comp = numcompfield(v(1));
if comp==1
    w = zeros(1,len);
else
    ux = zeros(1,len);
    uy = zeros(1,len);
    if comp==3
        uz = zeros(1,len);
    end
end

for i=1:numel(v(1).x)
    for j=1:numel(v(1).y)
        
        % builds the time series for each pixel:  
        for t=1:len  % temporel
            if comp==1
                w(t) = v(t).w(i,j);
            else
                ux(t) = v(t).vx(i,j);
                uy(t) = v(t).vy(i,j);
                if comp==3
                    uz(t) = v(t).vz(i,j);
                end
            end
        end
        
        % applies the mask in the Fourier space, and transforms back:
        if comp==1
            umw = ifft(fft(w).*mask);
        else
            umx = ifft(fft(ux).*mask);
            umy = ifft(fft(uy).*mask);
            if comp==3
                umz = ifft(fft(uz).*mask);
            end 
        end
        
        % builds the pivmat structure of the filtered time series
        for t=1:len
            if any(strncmpi(varargin,'complex',2)) % new v1.20
                if comp==1
                    vf(t).w(i,j) = umw(t);
                else
                    vf(t).vx(i,j) = umx(t);
                    vf(t).vy(i,j) = umy(t);
                    if comp==3
                        vf(t).vz(i,j) = umz(t);
                    end
                end
            else
                % (taking the real part is not necessary in theory.
                % but it is necessary to avoid non-real rounding errors)
                if comp==1
                    vf(t).w(i,j)=real(umw(t));
                else
                    vf(t).vx(i,j) = real(umx(t));
                    vf(t).vy(i,j) = real(umy(t));
                    if comp==3
                        vf(t).vz(i,j) = real(umz(t));
                    end
                end
            end
        end
    end
end

%new v1.10: phase average:
if any(strncmpi(varargin,'phaseaverf',2))
    if length(indexpos)~=1
        error('Option ''phaseaverf'' works only with scalar frequency index IND');
    end
    vf = phaseaverf(vf, numel(v)/(indexpos-1));

    %new v1.20: complex spatial structure
    if any(strncmpi(varargin,'complex',2))
        lenp = numel(vf);   % length of the periodic signal
        omega = 2*pi/(numel(v)/(indexpos-1));
        clear i
        for t=1:lenp
            if comp==1
                W(:,:,t) = vf(t).w .* exp(-1i*omega*t);
            else
                VX(:,:,t) = vf(t).vx .* exp(-1i*omega*t);
                VY(:,:,t) = vf(t).vy .* exp(-1i*omega*t);
                if comp==3
                    VZ(:,:,t) = vf(t).vz .* exp(-1i*omega*t);
                end
            end
        end
        vf=vf(1);
        if comp==1
            vf.w = mean(W,3);
        else
            vf.vx = mean(VX,3);
            vf.vy = mean(VY,3);
            if comp==3
                vf.vz = mean(VZ,3);
            end
        end
    end
end


for i=1:numel(vf)
    vf(i).history = {v(i).history{:} ['extractmode(ans, ' num2str(indexpos) ')']}';
end

if nargout==0
    showf(vf)
    clear vf
end
