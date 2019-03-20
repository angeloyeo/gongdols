function sf=subsbr(f,r0)
%SUBSBR  Subtract the mean rotation of a vector field.
%   SF = SUBSBR(F,R0) subtracts the mean rotation of the vector field
%   (or field array) F, centered on  R0 = [X0 Y0] in physical units (mm).
%   For each field F, the mean rotation is determined as (half) the curl of
%   F averaged over space. If R0 is not specified, the central point of the
%   field is taken.
%
%   SUBSBR is useful for processing vector fields originating from a camera
%   or device with a residual background rotation (solid-body rotation).
%
%   SPAVERF(VEC2SCAL(SUBSBR(V,R0),'rot')) gives a zero scalar field for all
%   V and R0.
%
%   If no output argument, the result is displayed by SHOWF.
%
%   See also AVERF, SPAVERF, VEC2SCAL, ROTATEF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.00,  Date: 2007/12/05
%   This function is part of the PIVMat Toolbox


% History:
% 2007/12/05: v1.00, first version.


% error(nargchk(1,2,nargin));

if (ischar(f) || iscellstr(f) || isnumeric(f))
    f=loadvec(f);
end 

if nargin==1   % default center
    r0 = [(f(1).x(1) + f(1).x(end))/2, (f(1).y(1) + f(1).y(end))/2];
end
    
sf=f;

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

    % substracts the sbr:
    sf(i).vx = sf(i).vx - sbrx;
    sf(i).vy = sf(i).vy - sbry;
    
    % history field:
    sf(i).history = {sf(i).history{:} ['subsbr(ans, ' num2str(r0) ')']}';
end

if nargout==0
    showf(sf);
    clear sf
end
