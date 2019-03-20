function cor = corrf(varargin)
%CORRF Spatial correlation function and integral scale of a scalar field
%   COR = CORRF(F, DIM) returns the correlation function and the integral
%   scale of the scalar field F along the dimension DIM (with DIM=1, 2,
%   or 'x','y', for correlation along the 'X' or 'Y' direction). If F is an
%   array of scalar fields, COR returns the average of the correlation
%   functions of each field.
%
%   For DIM='x', the correlation function is defined as
%      f(r) = < F(x,y) F(x+r,y) >,
%   where <..> is the spatial average (over x and y) and ensemble average
%   (over all the fields F).
%
%   The integral scale of the correlation f(r) is defined as
%      IS = integral_(from r=0)_(to r=r_max) f(r) dr / f(0),
%   where r_max is the maximum separation r. However, if the correlation
%   f(r) does not decrease enough down to 0, the integral does not converge
%   and IS is ill defined. It is therefore necessary to introduction a
%   truncation scale in the integral. This truncation scale r_t is defined
%   here as the scale at which f(r) decreases below a certain threshold.
%   Five integral scales are computed by CORRF, corresponding to the
%   following thresholds:
%     IS0:  r_t is such that f(r_t) = 0
%     IS1:  r_t     ''       f(r_t) = 0.1*f(0)
%     IS2:  r_t     ''       f(r_t) = 0.2*f(0)
%     IS5:  r_t     ''       f(r_t) = 0.5*f(0)
%     ISinf:  r_t is given by the maximum separation r.
%
%   COR is a structure which contains the following fields:
%     r:       separation length
%     f:       correlation function
%     unitr:   unit of separation length
%     unitf:   unit of correlation function
%     namef:   name of correlation function
%     isinf:   integral scale, computed as the integral of f up to the
%              maximum separation r.
%     r5:      scale at which f(r5)=0.5 (linearly interpolated)
%     is5:     integral scale, computed as the integral of f from 0 to r5
%     r2, is2, r1, is1, r0, is0 :  idem as r5, is5, for crossovers
%              at 0.2, 0.1 and 0 respectively
%
%   COR = CORRF(F, DIM, 'norm') normalizes the correlation function, so
%   that f = 1 at r = 0.
%
%   For a vector field V, CORRF(VEC2SCAL(V,'ux'),'x') and
%   CORRF(VEC2SCAL(V,'uy'),'y') are the longitudinal correlation functions,
%   and CORRF(VEC2SCAL(V,'ux'),'y') and CORRF(VEC2SCAL(V,'uy'),'x') are the
%   transverse ones.
%
%   Note that the convergence of the correlation function is not garanteed,
%   especially at large separations r, for which very few data points are
%   available to compute the correlation.
%
%   If the crossover scales are not defined (i.e. if the correlation
%   function does not decrease enough for large r), NaNs (not a number)
%   are returned, and a warning is issued. Use CORRF(...,'nowarning') to
%   ignore these warnings.
%
%   COR = CORRF(..., 'verbose') also displays the computation in progress.
%
%   If no output argument, the correlation function is plotted.
%
%   Example:
%      v = loadvec('B00001.VEC');
%      cor = corrf(vec2scal(v,'vx'),'x');
%      plot(cor.r, cor.f, 'o-');
%
%   See also VEC2SCAL, TEMPCORRF, STATF, HISTF, VSF, SPECF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.13,  Date: 2013/08/25
%   This function is part of the PIVMat Toolbox


% History:
% 2006/05/19: v1.00, first version.
% 2006/05/22: v1.01, new definitions for the integral scales
% 2006/05/25: v1.02, bug fixed for 2nd argument numeric
% 2006/07/13: v1.03, force 0 to be present for the Y-Axis
% 2008/09/16: v1.04, new option 'nowarning'
% 2009/01/21: v1.10, return 'NaN's for undefined crossovers and integral
%                    scales, instead of r(end).
% 2009/02/19: v1.11, bug in help text fixed
% 2013/03/16: v1.12, option 'verbose' added
% 2013/08/25: v1.13, help text improved

%error(nargchk(2,inf,nargin));

verb = ~any(strncmpi(varargin,'nowarning',5));  % new v1.04

f = varargin{1};

if ~isfield(f(1),'w')
    error('CORRF works only with scalar fields. Use CORRF(VEC2SCAL(...)).');
end

dim=varargin{2};

if ischar(dim)
    switch lower(dim)
        case 'x', dim=1;
        case 'y', dim=2;
    end
end

% initialization:
if dim==1
    dr = abs(f(1).x(2)-f(1).x(1));
    cor.r = dr*(0:length(f(1).x)-1)'; % row
    cor.f = zeros(1,length(cor.r))'; % row
    cor.unitr = f(1).unitx;
else
    dr = abs(f(1).y(2)-f(1).y(1));
    cor.r = dr*(0:length(f(1).y)-1); % line
    cor.f = zeros(1,length(cor.r)); % line
    cor.unitr = f(1).unity;
end


% computes the correlation function:
for i=1:length(f)
    if any(strncmpi(varargin,'verbose',4))
        disp(['Computing CORRF for field ' num2str(i) '/' num2str(length(f))]);
    end
    
    % correlation along x and sum over y, or vice-versa:
    cor.f = cor.f + mean(corrm(f(i).w, dim, 'half'),3-dim);  %(3-dim is 2 or 1);
end
cor.f = cor.f / length(f);

% normalize, and defines the name of the correlation function:
if any(strncmpi(varargin,'normalize',1))
    cor.f = cor.f / cor.f(1);
    cor.unitf = '';
    if dim==1
        cor.namef = ['<' f(1).namew '(x,y)' f(1).namew '(x+r,y)> / <' f(1).namew '^2>'];
    else
        cor.namef = ['<' f(1).namew '(x,y)' f(1).namew '(x,y+r)> / <' f(1).namew '^2>'];
    end
else
    cor.unitf = ['(' f(1).unitw ')^{2}'];    
    if dim==1
        cor.namef = ['<' f(1).namew '(x,y)' f(1).namew '(x+r,y)>'];
    else
        cor.namef = ['<' f(1).namew '(x,y)' f(1).namew '(x,y+r)>'];
    end
end

% computation of the integral scales:

% isinf: integration of the correlation function from 0 to "infinity":
cor.isinf = sum(cor.f/cor.f(1))*dr;

% is0: first zero-crossing of the corr. function, such that f(is0)=0 (linear
% interpolation):
rz=find(cor.f<=0);
if isempty(rz)
    if verb, disp('Warning: No zero found on the correlation function.'); end
    cor.r0 = NaN; %cor.r(end);
    cor.is0 = NaN; %cor.r(end);
else
    rz=rz(1);
    cor.r0 = cor.r(rz) + (0 - cor.f(rz)) * ((cor.r(rz)-cor.r(rz-1))/(cor.f(rz)-cor.f(rz-1))) ;
    cor.is0 = sum(cor.f(1:rz)/cor.f(1))*dr;
end

% is5: first 0.5-crossing of the corr. function, such that f(is5)=0.5 (linear
% interpolation):
rz=find(cor.f/cor.f(1)<=0.5);
if isempty(rz)
    if verb, disp('Warning: The correlation function does not cross 0.5.'); end
    cor.r5 =  NaN; %cor.r(end);
    cor.is5 =  NaN; %cor.r(end);
else
    rz=rz(1);
    cor.r5=  cor.r(rz) + (0.5*cor.f(1) - cor.f(rz)) * ((cor.r(rz)-cor.r(rz-1))/(cor.f(rz)-cor.f(rz-1))) ;
    cor.is5 = sum(cor.f(1:rz)/cor.f(1))*dr;
end

% is2: first 0.2-crossing of the corr. function, such that f(is2)=0.2 (linear
% interpolation):
rz=find(cor.f/cor.f(1)<=0.2);
if isempty(rz)
    if verb, disp('Warning: The correlation function does not cross 0.2.'); end
    cor.r2 =  NaN; %cor.r(end);
    cor.is2 =  NaN; %cor.r(end);
else
    rz=rz(1);
    cor.r2= ( cor.r(rz) + (0.2*cor.f(1) - cor.f(rz)) * ((cor.r(rz)-cor.r(rz-1))/(cor.f(rz)-cor.f(rz-1))) );
    cor.is2 = sum(cor.f(1:rz)/cor.f(1))*dr;
end


% is1: first 0.1-crossing of the corr. function, such that f(is1)=0.1 (linear
% interpolation):
rz=find(cor.f/cor.f(1)<=0.1);
if isempty(rz)
    if verb, disp('Warning: The correlation function does not cross 0.1.'); end
    cor.r1 =  NaN; %cor.r(end);
    cor.is1 =  NaN; %cor.r(end);
else
    rz=rz(1);
    cor.r1 = ( cor.r(rz) + (0.1*cor.f(1) - cor.f(rz)) * ((cor.r(rz)-cor.r(rz-1))/(cor.f(rz)-cor.f(rz-1))) );
    cor.is1 = sum(cor.f(1:rz)/cor.f(1))*dr;
end


if length(f)>1
    cor.history = {f(1).history ; ...
        ['[concat fields 1..' num2str(length(f)) ']']; ...
        ['corrf(ans, ' num2str(dim) ')']};
else
    cor.history = {f.history{:} ['corrf(ans, ' num2str(dim) ')']}';
end

if nargout==0
    plot(cor.r, cor.f,'o-');
    xlabel(['r (' cor.unitr ')']);
    ylabel([cor.namef '  ' cor.unitf]);
    if length(f)==1
        title(texliteral([f.setname '/' f.name]));
    else
        title(texliteral([f(1).setname '/' f(1).name '...' f(end).name]));
    end
    ax=axis;
    if ax(3)>0
        axis([ax(1) ax(2) 0 ax(4)]); % new v1.03
    end
    grid
end    
