function sf=phaseaverf(f,t)
%PHASEAVERF  Phase average of vector/scalar fields.
%   SF = PHASEAVERF(F,T), if T is a number, returns the phase average of
%   vector/scalar fields F over a period T. 
%
%   If T is an integer, SF has length T, and is such that:
%     SF(i) = AVERF(F(i:T:end));   for all i between 1 and T
%
%   If T is not an integer, then PHASEAVERF first performs a re-sampling of
%   the data (linear interpolation). The result has length FLOOR(T).
%
%   If T is an arbitrary vector, then performs a loop average of period
%   T(end), starting from all values of T.
%
%   Example :
%     v = loadvec('*.vc7');
%     sv = phaseaverf(v, 12);
%     showf(sv);
%
%   See also AVERF, SMOOTHF, RESAMPLEF


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.0,  Date: 2010/04/30
%   This function is part of the PIVMat Toolbox


% History:
% 2010/04/30: v1.00, first version.



% error(nargchk(1,2,nargin));

if (ischar(f) || iscellstr(f) || isnumeric(f))
    f=loadvec(f);
end

if (numel(t) == 1)
    if ((t-floor(t))<1e-10) % if t is an integer, no re-sampling needed:
        t=floor(t);
        for i=1:t
            sf(i) = averf(f(i:t:end));
        end
    else
        for i=1:floor(t)
            sf(i) = averf(resamplef(f,1:numel(f),i:t:numel(f)));
        end
    end
else  
    for i=1:numel(t)
        sf(i) = averf(resamplef(f,1:numel(f),t(i):t(end):numel(f)));
    end
end
