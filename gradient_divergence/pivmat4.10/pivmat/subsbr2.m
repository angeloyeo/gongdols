function sf=subsbr2(f,dt,r0)
%SUBSBR2  Subtract the mean rotation of a vector field.
%   SF = SUBSBR2(F,DT,R0) is the same as SUBSBR, but also rotates the
%   resulting field of an angle THETA given by the temporal integration of
%   the angular velocity determined for each field. DT is the sampling time
%   (in sec.), and R0 = [X0, Y0] the center of rotation (middle of the
%   field if unspecified).
%
%   See also AVERF, SPAVERF, VEC2SCAL, ROTATEF, SUBSBR.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.00,  Date: 2007/12/12
%   This function is part of the PIVMat Toolbox


% History:
% 2007/12/12: v1.00, first version.


% error(nargchk(1,3,nargin));

if (ischar(f) || iscellstr(f) || isnumeric(f))
    f=loadvec(f);
end 

if nargin<2   % default center
    dt = 1;
end
    
if nargin<3
    r0 = [(f(1).x(1) + f(1).x(end))/2, (f(1).y(1) + f(1).y(end))/2];
end

sf=f;

theta = 0;

for i=1:numel(f)
    
    % computes the mean vorticity
    rot = vec2scal(sf(i),'rot');
    meanrot = mean(rot.w(:));
    
    % computes the solid-body rotation centered on r0:
    [xx,yy] = ndgrid(f(i).x, f(i).y);
    sbrx = - ((yy-r0(2))/1000)*meanrot/2;
    sbry = + ((xx-r0(1))/1000)*meanrot/2;
    % (the factor 1000 originates from the conversion mm -> m)
    % (the factor 2 is because the vorticity is twice the angular velocity)

    % subtracts the sbr:
    sf(i).vx = sf(i).vx - sbrx;
    sf(i).vy = sf(i).vy - sbry;
    
    % new angle given by the integrated angular velocity:
    theta = theta + (meanrot/2)*dt;
    
    % rotate the field:
    sf(i) = rotatef(sf(i), theta, r0(1), r0(2));
    
    % history field:
    sf(i).history = {sf(i).history{:} ['subsbr2(ans, ' num2str(r0) ')']}';
end

if nargout==0
    showf(sf);
    clear sf
end
