function fv=medianf(v,filtsize,niter,varargin)
%MEDIANF  Apply a median filter to a vector/scalar field.
%   FF = MEDIANF(F) applies a median filter to the scalar/vector field(s) F,
%   using the function MEDFILT2 available in the Image Processing Toolbox.
%
%   FF = MEDIANF(F, [M N], ITER) specifies the size of the median filter,
%   [M,N], and the number of iterations, ITER. By default, M=N=3 and
%   ITER=1.
%
%   FF = MEDIANF(F, [M N], ITER, 'Property', ...) specifies:
%         'valid'   : truncates the borders (remove border effects)
%         'verbose' : displays the work in progress
%
%   Example:
%      v = loadvec('*.vc7');
%      showf(medianf(v));
%
%   See also  INTERPF, FILTERF, BWFILTERF, ADDNOISEF, MEDFILT2.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.30,  Date: 2013/03/22
%   This function is part of the PIVMat Toolbox


% History:
% 2007/05/22: v1.00, first version.
% 2008/04/15: v1.01, field history improved
% 2008/07/17: v1.10, option 'verbose' added
% 2013/02/22: v1.20, works with 3D fields
% 2013/03/22: v1.30, bug fixed for the 4 corners

% error(nargchk(1,inf,nargin));

if ~exist('medfilt2','file')
    error('The Image Processing Toolbox must be installed to use MEDIANF.');
end

if (ischar(v) || iscellstr(v) || isnumeric(v))
    v = loadvec(v);
end

if nargin<2
    filtsize=[];
end

if isempty(filtsize)
    filtsize=3;
end

if numel(filtsize)==1
    filtsize=[filtsize filtsize];
end

if nargin<3
    niter=[];
end

if isempty(niter)
    niter=1;
end


fv=v;

vecmode = isfield(v(1),'vx');   % 1 for vector field, 0 for scalar field

for i=1:numel(v)   % dont use parfor here! (not compatible with medfilt2)
    if any(strncmpi(varargin,'verbose',4))
        disp([' Median-filtering field #' num2str(i) '/' num2str(numel(v))]);
    end
    
    for j=1:niter
        if vecmode
            fv(i).vx=medfilt2(fv(i).vx, filtsize);
            fv(i).vy=medfilt2(fv(i).vy, filtsize);
            
            fv(i).vx(1,1)     = (fv(i).vx(1,2)       + fv(i).vx(2,1)      )/2;
            fv(i).vx(1,end)   = (fv(i).vx(2,end)     + fv(i).vx(1,end-1)  )/2;
            fv(i).vx(end,1)   = (fv(i).vx(end-1,1)   + fv(i).vx(end,2)    )/2;
            fv(i).vx(end,end) = (fv(i).vx(end-1,end) + fv(i).vx(end,end-1))/2;

            fv(i).vy(1,1)     = (fv(i).vy(1,2)       + fv(i).vy(2,1)      )/2;
            fv(i).vy(1,end)   = (fv(i).vy(2,end)     + fv(i).vy(1,end-1)  )/2;
            fv(i).vy(end,1)   = (fv(i).vy(end-1,1)   + fv(i).vy(end,2)    )/2;
            fv(i).vy(end,end) = (fv(i).vy(end-1,end) + fv(i).vy(end,end-1))/2;

            if isfield(fv(i),'vz')
                fv(i).vz=medfilt2(fv(i).vz, filtsize);

                fv(i).vz(1,1)     = (fv(i).vz(1,2)       + fv(i).vz(2,1)      )/2;
                fv(i).vz(1,end)   = (fv(i).vz(2,end)     + fv(i).vz(1,end-1)  )/2;
                fv(i).vz(end,1)   = (fv(i).vz(end-1,1)   + fv(i).vz(end,2)    )/2;
                fv(i).vz(end,end) = (fv(i).vz(end-1,end) + fv(i).vz(end,end-1))/2;

            end
        else
            fv(i).w=medfilt2(fv(i).w, filtsize);

            fv(i).w(1,1)     = (fv(i).w(1,2)       + fv(i).w(2,1)      )/2;
            fv(i).w(1,end)   = (fv(i).w(2,end)     + fv(i).w(1,end-1)  )/2;
            fv(i).w(end,1)   = (fv(i).w(end-1,1)   + fv(i).w(end,2)    )/2;
            fv(i).w(end,end) = (fv(i).w(end-1,end) + fv(i).w(end,end-1))/2;
        end
    end
    
    if any(strncmpi(varargin,'valid',3))
        mf = floor(max(filtsize)/2);
        fv(i) = extractf(fv(i), [1+mf 1+mf length(fv(i).x)-mf length(fv(i).y)-mf]);
    end

    fv(i).history = {v(i).history{:} ['medianf(ans, [' num2str(filtsize) '], ' num2str(niter) ', ''' varargin{:} ''')']}';

end

if nargout==0
    showf(fv);
    clear fv
end
