function fv=filterf(v,filtsize,method,varargin)
%FILTERF  Apply a spatial filter to a vector/scalar field.
%   FF = FILTERF(F,FSIZE) applies a spatial filtering of the vector/scalar
%   field(s) F by computing its 2D convolution with a Gaussian kernel of
%   width FSIZE (expressed in mesh units).  If not specified, FSIZE=1 is
%   taken by default. This operation filters out structures of size
%   typically smaller than FSIZE (low-pass filter). The Gaussian kernel is
%   defined as:
%
%      G(X,Y) = exp ( -(X^2+Y^2)/(2*FSIZE^2) )
%
%   The kernel is defined in a square domain of size 1+2*CEIL(3.5*FSIZE)
%   (i.e., for FSIZE=1, it is defined over a 9x9 matrix). The convolution
%   is performed using Matlab's CONV2 function. 
%
%   FF = FILTERF(F,FSIZE,KERNEL) specifies the kernel G(X,Y):
%         'gauss':   gaussian kernel (by default)
%         'flat':    flat (or top-hat) kernel, G = ONES(FSIZE,FSIZE)
%                    (FSIZE must be an even integer)
%         'igauss':  derivative of the integrated gaussian (minimized
%                    discretisation effects for small FSIZE).
%
%   The size of the filtered field is smaller than the original field, to
%   avoid boundary effects (the convolution is done by CONV2 with the
%   option 'valid'). If you prefer to keep the whole field, use
%   FILTERF(F,FSIZE,KERNEL,'same')
%
%   Note : If there are missing data in the field, it is better to first
%   interpolate the data. See INTERPF.
%
%   If FSIZE is an array, applies each element of FSIZE over each element
%   of F (one must have LENGTH(FSIZE)=LENGTH(F)).
%
%   If no output argument, the result is displayed by SHOWF.
%
%   Examples:
%      v = loadvec('*.vc7');
%      showf(filterf(v));
%      showf(filterf(v,2,'flat'));
%      showf(filterf(vec2scal(v,'rot'),2));
%
%   See also SHOWF, MEDIANF, BWFILTERF, ADDNOISEF, INTERPF,
%   GAUSSMAT, CONV2, TEMPFILTERF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.62,  Date: 2016/11/17
%   This function is part of the PIVMat Toolbox


% History:
% 2003/??/??: v1.00, first version.
% 2004/04/30: v1.01.
% 2004/06/26: v1.02, changed help text.
% 2005/02/23: v1.03, cosmetics.
% 2005/04/28: v1.04, propagates the field 'history'
% 2005/09/03: v1.05, arg check added.
% 2005/09/28: v1.06, option 'same' added.
% 2005/10/11: v1.10, now called filterf (from filtervec v1.06, 2005/09/28).
% 2005/10/29: v1.11, bug fixed when F is a scalar field (truncf).
% 2006/03/10: v1.12, new history
% 2006/04/28: v1.13, default value fsize=1, and accepts numeric input
% 2006/09/12: v1.20, now works with varargin; new syntax for the options.
%                    new method 'igauss' (A. Muller)
% 2008/04/15: v1.21, bug fixed in field 'history'
% 2008/09/16: v1.22, another bug fixed in field 'history'
% 2008/10/08: v1.30, missing data are now properly excluded from the
%                    convolution, using NaNs. option 'zeros' removed. use INTERPF instead.
% 2009/03/17: v1.40, FSIZE can be an array
% 2009/04/13: v1.50, main loop 'parfor' (parallel computing toolbox)
% 2010/05/03: v1.51, parfor loop removed (it is slower using parfor!)
% 2013/02/22: v1.60, works with 3D fields
% 2016/05/04: v1.61, help text improved
% 2016/11/17: v1.62, speed improvement

%error(nargchk(1,inf,nargin));

if (ischar(v) || iscellstr(v) || isnumeric(v)),
    v = loadvec(v);
end

if nargin<2
    filtsize=1;
end

if nargin<3
    method='gauss';
end

if numel(filtsize)>1
    if numel(filtsize)~=numel(v)
        error('Dimensions of vector/scalar fields F and filter sizes must be equal.');
    end
else
    filtsize = filtsize * ones(1,numel(v));
end

v=zerotonanfield(v);
fv=v;

comp = numcompfield(v(1));

for i=1:numel(v)    % no parfor here! (otherwise it is slower)

    if filtsize(i)~=0
        
        % defines the convolution matrix:
        if strncmpi(method,'flat',1)
            mat=ones(ceil(filtsize(i)))/ceil(filtsize(i))^2;
        elseif strncmpi(method,'gauss',2)
            mat=gaussmat(filtsize(i),1+2*ceil(3.5*filtsize(i)),'igauss');
        else
            mat=gaussmat(filtsize(i),1+2*ceil(3.5*filtsize(i)));
        end

        % computes the filtered fields:
        if any(strncmpi(varargin,'same',1))
            if comp==1
                fv(i).w=conv2(v(i).w,mat,'same');
            else
                fv(i).vx=conv2(v(i).vx,mat,'same');
                fv(i).vy=conv2(v(i).vy,mat,'same');
                if comp==3
                    fv(i).vz=conv2(v(i).vz,mat,'same');
                end 
            end
        else
            if comp==1
                fv(i).w=conv2(v(i).w,mat,'valid');
                ntrunc=floor((size(v(i).w,1)-size(fv(i).w,1))/2);
            else
                fv(i).vx=conv2(v(i).vx,mat,'valid');
                fv(i).vy=conv2(v(i).vy,mat,'valid');
                if comp==3
                    fv(i).vz=conv2(v(i).vz,mat,'valid');
                end
                ntrunc=floor((size(v(i).vx,1)-size(fv(i).vx,1))/2);
            end
            % computes the new axis (smaller than the original ones,
            %  because the borders are excluded from the convolution):
            fv(i).x = v(i).x((1+ntrunc):(length(v(i).x)-ntrunc));
            fv(i).y = v(i).y((1+ntrunc):(length(v(i).y)-ntrunc));
        end

        fv(i).history = {v(i).history{:} ['filterf(ans, ' num2str(filtsize(i)) ', ''' method ''', ' varargin{:} ')']}';

    end
end

fv=nantozerofield(fv);

if nargout==0
    showf(fv);
    clear fv
end
