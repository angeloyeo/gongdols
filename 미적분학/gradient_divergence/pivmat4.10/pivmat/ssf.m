function stfun=ssf(s,dim,varargin)
%SSF  Structure functions of a scalar field, histograms of increments
%   STFUN = SSF(F,DIM) computes the structure functions of the scalar field
%   F and the histograms of the scalar increments along the dimension DIM
%   (with DIM=1, 2, or 'x','y'). If F is an array of fields, the structure
%   functions are averaged over the fields.
%
%   Structure functions of order n are the moments of the scalar increments
%   as a function of the separation r, <(s(x+r) - s(x))^n>.
%
%   The structure STFUN contains the following fields:
%     - r :           separation lengths (in mesh units)
%     - unitr:        unit of separation length (e.g., 'mm')
%     - scaler :      scale (in physical units) of a unit separation
%     - sf :          R-by-ORDER matrix containing the structure functions
%                     of order ORDER.
%     - sfabs :       idem as sf, with absolute values.
%     - skew:         skewness factor.
%     - flat:         flatness factor.
%     - bin :         bins for the histograms
%     - binwidth:     width of a bin
%     - hsi :         (R x BINVEC) matrix containing the histograms of
%                     scalar increments.
%     - pdfsi :       normalized histograms (PDF).
%     - history:      remind from which field vsf has been called.
%     - n:            nbre of points used in the computation.
%     - nfields:      nbre of fields used in the computation (given by
%                     LENGTH(S)).
%
%   STFUN = SSF(S, 'PropertyName', PropertyValue, ...) also specifies the
%   optional input arguments:
%      - 'bin', BIN :    vector where velocity increments should be bined.
%                        By default, 1000 bins are taken, chosen from the
%                        rms of the first field.
%      - 'r', R :        list of separations delta_r over which increments
%                        are computed, given in mesh units (should be
%                        smaller than the largest extent of the field).
%                        If not specified, a default separation list is
%                        used.
%      - 'maxorder', ORDER: maximum order of structure function (usually
%                           between 4 and 8). ORDER=4 is taken by default
%                           (although its convergence may not be
%                           guaranteed).
%
%   By default, SSF considers the values 0 as erroneous, and does not
%   include them in the histogram. If however the values 0 are to be
%   included, specify VSF(...,'0');
%
%   Example:
%      v = loadvec('*.vc7');
%      stfun = ssf(filterf(vec2scal(v,'rot')));
%
%   See also VSF, VSF_DISP, HISTF, CORRF, SPECF.

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.00,  Date: 2008/05/19
%   This function is part of the PIVMat Toolbox

% History:
% 2008/05/19: v1.00, first version, from VSF (2008/03/28: v2.03)


center_sf = false;  % compute the centered structure functions.
% (set to false to compute the non-centered sf)

% error(nargchk(1,inf,nargin));

if ~isfield(s(1),'w')
    error('SSF works only with scalar fields. Use SSF(VEC2SCAL(...)).');
end

if ischar(dim)
    switch lower(dim)
        case 'x', dim=1;
        case 'y', dim=2;
    end
end

% Binvec:
bin=0; % default value
if any(strncmpi(varargin,'bin',3)),
    bin = varargin{1+find(strncmpi(varargin,'bin',3),1,'last')};
end
if bin==0,
    stat_s=statf(s(1));
    maxbin=10*stat_s.rms;
    bin=linspace(-maxbin, maxbin, 1000);
end
binwidth=abs(bin(2)-bin(1));

% separations:
r=0;
if any(strncmpi(varargin,'r',1))
    r = varargin{1+find(strncmpi(varargin,'r',1),1,'last')};
end
if r==0,
    r=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 18 20 22 24 26 28 30 32 36 40 44 48 52 56 60 64 72 80 96 112 128 142 160 176 192 224 256];
    maxdr=min([length(s(1).x) length(s(1).y)]);
    r=r(1:find(r<maxdr,1,'last'));
end
ndr=length(r);

% maxorder:
maxorder=4;
if any(strncmpi(varargin,'maxorder',3)),
    maxorder = max(4,varargin{1+find(strncmpi(varargin,'maxorder',3),1,'last')});
end
if maxorder>30
    error('Maximum order too large.');
end

%include zero vectors? (true if option '0' is NOT present)
validscalar = ~any(strcmp(varargin,'0'));

% initialisations:
stfun.hsi=zeros(ndr,length(bin));
stfun.pdfsi=zeros(ndr,length(bin));
stfun.pdfsi=zeros(ndr,length(bin));


% computes the histograms for each vector field and stacks them:
for i=1:length(s)
    hi=comphists(s(i),bin,r,validscalar,dim); % modified v2.02
    for rr=1:ndr,
        stfun.hsi(rr,:) = stfun.hsi(rr,:) + hi.hsi(rr,:);
    end
end

% find the largest non-empty r
% (assuming that all the v(i) have the same size)
ndr=length(find(sum(hi(1).hsi,2)));
r=r(1:ndr);

% computes the pdf (normalized histograms) and the means (should be approx.
% zero):
meansi=zeros(1,ndr);

for rr=1:ndr,
    % PDF of increments:
    nsi=sum(stfun.hsi(rr,:));
    if nsi
        stfun.pdfsi(rr,:) = stfun.hsi(rr,:) / (nsi*binwidth);
    else
        stfun.pdfsi(rr,:) = zeros(1,length(bin));
    end

    % Structure functions:
    if ~center_sf
        % Computes the (non-centered) structure functions
        for order=1:maxorder,
            stfun.sf(rr,order) = sum(stfun.pdfsi(rr,:).*bin.^order)*binwidth;
            stfun.sfabs(rr,order) = sum(stfun.pdfsi(rr,:).*abs(bin).^order)*binwidth;
        end
    else
        % Computes the (centered) structure functions
        meansi(rr) = sum(stfun.pdfsi(rr,:).*bin)*binwidth;
        meansi(rr) = sum(stfun.pdfsi(rr,:).*bin)*binwidth;
        for order=1:maxorder,
            stfun.sf(rr,order) = sum(stfun.pdfsi(rr,:).*(bin-meansi(rr)).^order)*binwidth;
            stfun.sfabs(rr,order) = sum(stfun.pdfsi(rr,:).*abs(bin-meansi(rr)).^order)*binwidth;
        end
    end

    % Skewness and flatness:
    stfun.skew(rr)=stfun.sf(rr,3)/stfun.sf(rr,2)^(3/2);
    stfun.flat(rr)=stfun.sf(rr,4)/stfun.sf(rr,2)^2;
end

stfun.r=r;
stfun.scaler=abs(s(1).x(2)-s(1).x(1));
stfun.unitr=s(1).unitx;
stfun.bin=bin;
stfun.binwidth=binwidth;
stfun.unitf=s(1).unitw;

% history field:
if length(s)>1,
    stfun.history = {s(1).history ; ...
        ['[concat fields 1..' num2str(length(s)) ']']; ...
        'ssf(ans)'};
else
    stfun.history = {s.history{:} 'ssf(ans)'}';
end

stfun.n = length(s)*length(s(1).x)*length(s(1).y);
stfun.nfields = length(s);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% END %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function hi=comphists(s,bin,r,validscalar,dim)
% internal function, that computes the histograms
% for a single scalar field.
% validscalar=true means that only nonzeros elements are used


nx=size(s.w,1);
ny=size(s.w,2);

for rr=1:length(r),

    if dim==1
        % horizontal shift
        if (r(rr)<nx),
            % computes the horizontal increments:
            dsx = s.w((1+r(rr)):nx, 1:ny) - s.w(1:(nx-r(rr)), 1:ny);
            % kills (ie: puts to 0) the vel.incr. computed from erroneous
            % (zero) vectors:
            if validscalar, dsx = dsx .* logical(s.w((1+r(rr)):nx, 1:ny)~=0) .* logical(s.w(1:(nx-r(rr)), 1:ny)~=0); end
            dsx_vect = reshape(dsx, 1, (nx-r(rr))*ny);  % converts the matrix into vector
            hi.hsi(rr,:) = hist( dsx_vect(dsx_vect~=0), bin );            % computes the histogram of the nonzero values.
        else
            hi.hsi(rr,:)=0;
        end
    elseif dim==2
        % vertical shift
        if (r(rr)<ny)
            dsy = s.w (1:nx, (1+r(rr)):ny) - s.w (1:nx, 1:(ny-r(rr)));
            if validscalar, dsy = dsy .* logical(s.w (1:nx, (1+r(rr)):ny)~=0) .* logical(s.w (1:nx, 1:(ny-r(rr)))~=0); end
            dsy_vect = reshape(dsy, 1, nx*(ny-r(rr)));
            hi.hsi(rr,:) = hist(dsy_vect(dsy_vect~=0),bin);

        else
            hi.hsi(rr,:)=0;
        end
    end

end
