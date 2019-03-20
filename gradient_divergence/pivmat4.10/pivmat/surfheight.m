function hresult = surfheight(dr,h0,H,n,ctr,varargin)
%SURFHEIGHT  Surface height reconstruction for FS-SS
%   H = SURFHEIGHT(DR, H0, HC, N, [X0,Y0]) computes the surface height H
%   for FS-SS measurements (Free-Surface Synthetic Schlieren).
%   The input arguments are the displacement field(s) DR, the
%   pattern-surface distance H0, the pattern-camera distance HC
%   (can be set to infinity, H=inf), the refraction index N and the optical
%   center [X0,Y0]. H0, HC and [X0,Y0] are expressed in the same units as R
%   (e.g., mm). If N is not specified, N=1.33 by default (water index). If
%   the center [X0, Y0] is not specified, the center of the field is taken.
%   The center does not need to be inside the field.
%
%   FS-SS random dot patterns can be generated using MAKEBOSPATTERN.
%
%   Additional parameters can be specified, but only *after* the first
%   6 parameters described above:
%
%   H = SURFHEIGHT(..., 'submean') first substracts the mean displacement
%   along each direction. This is useful if the incidence angle of the
%   camera is not exactly 0.
%
%   H = SURFHEIGHT(..., 'remap') applies the remapping procedure, as
%   described in Moisy et al (2009). The resulting height field H is
%   smaller than the input displacement field DR, by an amount of about
%   L*H0/HC, where L is the field size, H0 the pattern-surface distance and
%   HC the pattern-camera distance.
%
%   By default, SURFHEIGHT produces a height field such that MEAN(H)=H0.
%   Specify H = SURFHEIGHT(..., 'nosetzero') if you do not want to apply
%   this constraint - in this case, the point (1,1) of the height field
%   is equal to H0, but MEAN(H) is arbitrary.
%
%   H = SURFHEIGHT(..., 'verbose') displays the computation progress.
%
%   SURFHEIGHT is based on INTGRAD2.M by J. D'Errico.
%
%   Example:
%
%     dr = loadvec('*.vc7');
%     h = surfheight(dr, 10, 2000);
%     showf(h);
%
%   Reference:
%     Moisy, Rabaud, Salsac, "A Synthetic Schlieren method for
%     the measurement of the topography of a liquid interface",
%     Experiments in Fluids (2009).
%
%     See  http://www.fast.u-psud.fr/~moisy/sgbos/tutorial.php
%
%   See also MAKEBOSPATTERN, SHOWF, VEC2SCAL, GRADIENTF.

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 2.21,  Date: 2015/02/18
%   This function is part of the PIVMat Toolbox

% History:
% 2006/07/01: v1.00, first version, Joran Rolland
% 2007/04/10: v1.10, help, arg check. Inclusion in PIVMat
% 2007/04/15: v1.11, new option 'mode'
% 2007/05/21: v1.12, new mode 3: arbitrary slope and small amplitude
% 2007/06/15: v1.20, new options 'submean' and 'setzero'
% 2007/07/16: v1.30, new modes 4-5-6 (camera above)
% 2007/07/19: v1.31, new option 'verb'; new submean
% 2008/05/09: v2.00, 'surfheightnew': new computation, including the
%                    pattern-camera distance and remapping.
% 2008/09/05: v2.01, replaces the old 'surfheight'. help text changed.
% 2009/04/14: v2.02, help text changed (BOS->SS)
% 2010/05/01: v2.10, the remap procedure has been removed (use the option
%                    'remap', undocumented, to apply this procedure).
% 2011/07/22: v2.20, 'remap' option now include truncation, more robust.
% 2015/02/18: v2.21, 2 bugs fixed with 'remap' option, when processing
%                    arrays of fields and/or fields of odd size.

% error(nargchk(2,inf,nargin));

if (ischar(dr) || iscellstr(dr) || isnumeric(dr))
    dr=loadvec(dr);
end

% default camera distance: infinity
if nargin<3
    H = inf;  
end

% default optical index: water n=1.33
if nargin<4
    n = 1.33;  
end

% default optical center: center of the frame
if nargin<5 || isempty(ctr)
    ctr(1) = mean(dr(1).x);
    ctr(2) = mean(dr(1).y);
end

scale = abs(dr(1).x(1) - dr(1).x(2));
[yy,xx] = meshgrid(dr(1).y, dr(1).x);   % be careful: order of arguments!

% initialise the structure of the output
hresult = vec2scal(dr,'norm');

alpha = 1-1/n;    % 0.24 for air-water interface
factor = 1/H - 1/(alpha*h0);    % <0

verbose = any(strncmpi(varargin,'verbose',4));

for i=1:numel(dr)
    % display progress
    if verbose, fprintf(['  Field #' num2str(i) '/' num2str(length(dr)) ': ']); end
    
    % substract the mean vector field
    if any(strncmpi(varargin,'submean',4))
        dr(i) = subaverf(dr(i),'xy');
        hresult(i).submean = 'Mean substracted';
    else
        hresult(i).submean = 'Mean not substracted';
    end
    
    % computes grad(h):
    dhdx = dr(i).vx * factor;
    dhdy = dr(i).vy * factor;
    
    % remap grad(h) only if option 'remap' is specified (new v2.10)
    if any(strncmpi(varargin,'remap',4))
        hresult(i).remap = 'Remapped';
        if verbose, fprintf('remapping... '); end
        % point J (xxmes, yymes) where (grad h) is actually measured:
        xxmes = (1-h0/H)*(xx+dr(i).vx-ctr(1))+ctr(1);
        yymes = (1-h0/H)*(yy+dr(i).vy-ctr(2))+ctr(2);
        % remap (grad h) measured at point J onto the initial grid:
        dhdx = griddata(xxmes, yymes, dhdx, xx, yy,'cubic');
        dhdy = griddata(xxmes, yymes, dhdy, xx, yy,'cubic');       
        
        if false
            % set NaNs to zeros (otherwise the integrated field is NaN)
            % but keeps ghost points at the borders
            dhdx(isnan(dhdx))=0;
            dhdy(isnan(dhdy))=0;
        else
            if verbose, fprintf('truncate... '); end
            % determine the largest rectangle without NaNs
            % (only on the first field)
            if i==1
                imin = find(~isnan(dhdx(:,round(end/2))),1,'first')+1;
                imax = find(~isnan(dhdx(:,round(end/2))),1,'last')-1;
                jmin = find(~isnan(dhdx(round(end/2),:)),1,'first')+1;
                jmax = find(~isnan(dhdx(round(end/2),:)),1,'last')-1;
            end
            
            % truncate the field
            dhdx = dhdx(imin:imax, jmin:jmax);
            dhdy = dhdy(imin:imax, jmin:jmax);
            hresult(i).x = hresult(i).x(imin:imax);
            hresult(i).y = hresult(i).y(jmin:jmax);
            hresult(i).xtrunc = imin:imax;
            hresult(i).ytrunc = jmin:jmax;
            
            % remove remaining NaNs
            dhdx(isnan(dhdx))=0;
            dhdy(isnan(dhdy))=0;    
        end
    else
        hresult(i).remap = 'Not remapped'; % by default (v2.10)
    end
    
    % integration (using J. D'Errico "intgrad2" function)
    if verbose, fprintf('integrating... '); end
    h = intgrad2(dhdy,dhdx,scale,scale,h0);
    
    % re-set the mean height to h0 (except if option 'nosetzero')
    if ~any(strncmpi(varargin,'nosetzero',4))   % new v1.20
        h = h - mean(h(:)) + h0;
    end

    % store the result
    hresult(i).w = h;
    hresult(i).h0 = h0;
    hresult(i).H = H;
    hresult(i).n = n;
    hresult(i).ctr = ctr;
    hresult(i).namew = 'h';
    hresult(i).unitw = dr(i).unitx;
    hresult(i).history = {dr(i).history{:} ['surfheight(ans, ' num2str(h0) ', ' num2str(H) ', ' num2str(n) ', ' varargin{:} ')']}';
    
    if verbose, fprintf('done.\n'); end
end

if nargout==0
    showf(hresult);
    clear hresult
end
