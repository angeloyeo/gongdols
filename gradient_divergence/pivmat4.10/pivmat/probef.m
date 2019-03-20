function varargout = probef(f,x0,y0)
%PROBEF   Record the time evolution of a probe in a field
%   P = PROBEF(F, X0, Y0), where F is an array of scalar fields, returns the
%   time series of a probe located at point (X0, Y0), specified in physical
%   units (eg., in mm).  P is an array of size LENGTH(F).
%
%   If X0 and Y0 are arrays of length N, the time series are sampled at
%   each probe point. In this case, P is a matrix of size LENGTH(F) x
%   LENGTH(X0).
%
%   P = PROBEF(F) allows the user to select probe point(s) using the mouse.
%
%   [UX, UY] = PROBEF(...)  or  [UX, UY, UZ] = PROBE(...) does the same for
%   a 2-component or a 3-component array of vector fields.
%
%   The value of the field at the location of the probe is interpolated
%   using Matlab's function INTERP2.
%
%   Example:
%      v = loadvec('*.vc7');
%      [ux, uy] = probef(v, 20, 30);
%      t = 1:length(v);
%      plot(t, ux, 'b', t, uy, 'r');
%      xlabel('time t');
%
%   See also SHOWF, SPATIOTEMPF, MATRIXCOORDF, PROBEAVERF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.01,  Date: 2017/01/31
%   This function is part of the PIVMat Toolbox


% History:
% 2016/04/26: v1.00, first version.
% 2017/01/31: v1.10, accepts more than one probe.
%                    select probes using the mouse.


comp = numcompfield(f(1));

if nargin==1
    disp('Select point(s) to probe and press enter');
    [x0,y0] = ginput;
    for i=1:length(x0)
        disp(['Point #' num2str(i) ': [' num2str(x0(i)) ', ' num2str(y0(i)) ']']);
    end
    hold on
    plot(x0,y0,'+');
    hold off
end

Np = length(x0);

for i = 1:numel(f)
    switch comp
        case 1
            s(i,1:Np)  = interp2(f(i).x, f(i).y, f(i).w',  x0, y0);
        case 2
            ux(i,1:Np) = interp2(f(i).x, f(i).y, f(i).vx', x0, y0);
            uy(i,1:Np) = interp2(f(i).x, f(i).y, f(i).vy', x0, y0);
        case 3
            ux(i,1:Np) = interp2(f(i).x, f(i).y, f(i).vx', x0, y0);
            uy(i,1:Np) = interp2(f(i).x, f(i).y, f(i).vy', x0, y0);
            uz(i,1:Np) = interp2(f(i).x, f(i).y, f(i).vz', x0, y0);
    end
end

if nargout==1
    varargout{1} = s;
elseif nargout==2
    varargout{1} = ux;
    varargout{2} = uy;
elseif nargout==3
    varargout{1} = ux;
    varargout{2} = uy;     
    varargout{3} = uz;
end

