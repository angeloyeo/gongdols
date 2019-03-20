function sf=resamplef(f,tini,tfin)
%RESAMPLEF  (Temporal) re-sampling of vector/scalar fields.
%   SF = RESAMPLEF(F,TINI,TFIN), where TINI is a vector of initial
%   times and TFIN a vector of final times, re-samples the structure array
%   of scalar or vector fields F from TINI to TFIN. This re-sampling is
%   based on a linear interpolation on the final times TFIN.
%
%   This function is useful if some data were acquired at a given
%   frequency, and one wants to resample them to another frequency which is
%   not a simple multiple of the initial frequency.
%
%   The input parameters must satisfy:
%     - LENGTH(F) == LENGTH(TINI)
%     - TINI must be increasing
%     - all values of TFIN must be between TINI(1) and TINI(end)
%
%   Example :
%     v = loadvec('*.vc7');
%     tini = 1:0.4:100;  % if acquisition were performed with dt = 0.4 s
%     tfin = 1:0.5:100;  % we want to convert it to dt = 0.5 s
%     sv = resamplef(v,tini,tfin);
%     showf(sv);
%
%   See also AVERF, SMOOTHF, PHASEAVERF


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.10,  Date: 2013/02/22
%   This function is part of the PIVMat Toolbox


% History:
% 2010/04/30: v1.00, first version.
% 2013/02/22: v1.10, works with 3D fields


%error(nargchk(1,3,nargin));

if (ischar(f) || iscellstr(f) || isnumeric(f))
    f=loadvec(f);
end 

if numel(f)~=numel(tini)
    error('Size of F and TINI must coincide.');
end

if any(diff(tini)<0)
    error('TINI must be strictly increasing.');
end

if min(tfin)<tini(1) || max(tfin)>tini(end)
    error('Some values of TFIN fall outside the bounds of TINI.');
end

for i=1:numel(tfin)
    % finds the closest index surrounding the searched time:
    kinf = find(tini<=tfin(i),1,'last');
    ksup = find(tini>=tfin(i),1,'first');
    if kinf==ksup  % falls exactly on an intial point:
        sf(i) = f(kinf);
    else  % falls outside: performs a linear interpolation:
        % computes the relative distance:
        dist = (tfin(i) - tini(kinf))/(tini(ksup)-tini(kinf));
        sf(i) = f(kinf);
        if isfield(sf(i),'vx')
            sf(i).vx = f(kinf).vx * (1-dist) + f(ksup).vx * dist;
            sf(i).vy = f(kinf).vy * (1-dist) + f(ksup).vy * dist;
            if isfield(sf(i),'vz')
                sf(i).vz = f(kinf).vz * (1-dist) + f(ksup).vz * dist;
            end
        else
            sf(i).w = f(kinf).w * (1-dist) + f(ksup).w * dist;
        end
    end
    sf(i).history = {f(kinf).history{:} 'resamplef(ans)'}';
end
