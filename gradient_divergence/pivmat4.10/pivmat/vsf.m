function stfun=vsf(v,varargin)
%VSF  Structure functions of a vector field, histograms of increments
%   STFUN = VSF(F) computes the longitudinal and transverse structure
%   functions of the vector field F, and the histograms of the longitudinal
%   and transverse increments. If F is an array of fields, the structure
%   functions are (ensemble) averaged over the fields.
%
%   Longitudinal (resp. Transverse) structure functions of order n are the
%   moments of the vector increments as a function of the separation r,
%   <(v(x+r) - v(x))^n>, where v is the projection of the velocity along
%   (resp. perpendicular) to r, and the brackets <> denote both spatial
%   average and ensemble average (if F is an array of fields).
%
%   The structure STFUN contains the following fields:
%     - r :           separation lengths (in mesh units)
%     - unitr:        unit of separation length (e.g., 'mm')
%     - scaler :      scale (in physical units) of a unit separation
%     - lsf, tsf :    R-by-ORDER matrix containing the longitudinal and
%                     transverse structure functions of order ORDER.
%     - lsfabs, tsfabs : idem as lsf and tsf, with absolute values.
%     - skew_long, skew_trans: long. and trans. skewness factor.
%     - flat_long, flat_trans: long. and trans. flatness factor.
%     - bin :         bins for the histograms
%     - binwidth:     width of a bin
%     - hlvi, htvi :  (R x BINVEC) matrix containing the longitudinal and
%                     transverse histograms of velocity increments.
%     - pdflvi, pdftvi: normalized long. and trans. histograms (PDF).
%     - history:      remind from which field vsf has been called.
%     - n:            nbre of points used in the computation.
%     - nfields:      nbre of fields used in the computation (given by
%                     LENGTH(V)).
%
%   The resulting structure STFUN may be displayed using VSF_DISP.
%
%   STFUN = VSF(F, 'PropertyName', PropertyValue, ...) also specifies the
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
%      - 'parallel' :    parallelized computation (using parfor loop).
%                        First open a matlab pool to use parallel
%                        computing.
%
%   By default, VSF considers the values 0 as erroneous, and does not
%   include them in the histogram and in the computation of the S.F.
%   If however the values 0 are to be included, specify VSF(...,'0').
%	 
%   Example:
%      % plot the 2nd order S.F. of a set of vector fields:
%      v = loadvec('*.vc7');
%      stfun = vsf(filterf(v,1),'maxorder',6);
%      loglog(stfun.r*stfun.scaler, stfun.lsf(:,2));
%
%   Example:
%      stfun = vsf(loadvec('*.vc7'));
%      vsf_disp(stfun, 'hist', 'skew');
%    
%   See also VSF_DISP, SSF, HISTF, CORRF, SPECF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 2.20,  Date: 2013/04/09
%   This function is part of the PIVMat Toolbox


% History:
% 2004/05/22: v1.00, first version.
% 2004/07/27: v1.10, VSF completely replaces COMPUTE_VSF.
% 2004/10/05: v1.20, computes all SF from pdfs only. SF are now Centered.
% 2005/02/23: v1.21, cosmetics.
% 2006/10/29: v2.00, help text rewritten; pre-allocated arrays; file not
%                    saved by default; new field history.
%                    now included in PIVMat.
% 2006/12/08: v2.01, bug fixed binwidth
% 2007/04/11: v2.02, more efficient ('hi' in a loop). help text improved
% 2008/03/28: v2.03, returns n and nfields
% 2010/01/25: v2.04, help text improved
% 2013/01/08: v2.10, bug fixed for the sign of the transverse S.F.
%                    (thanks Basile)
% 2013/04/09: v2.20, option 'paral' added for parallelized computation
%                    (thanks Antoine!!)


center_sf = true;  % compute the centered structure functions.
 % (set to false to compute the non-centered sf)
 
% error(nargchk(1,7,nargin));

if (ischar(v) || iscellstr(v) || isnumeric(v)),
    v = loadvec(v);
end

% Definition of the binning vector for the histograms:
bin=0; % default value
if any(strncmpi(varargin,'bin',3)),
    bin = varargin{1+find(strncmpi(varargin,'bin',3),1,'last')};
end
if bin==0
    % Default binning
    stat_vx = statf(v(1));
    maxbin = 10*stat_vx.rms;
    bin = linspace(-maxbin, maxbin, 1000);
end
binwidth=abs(bin(2)-bin(1));

% separations:
r=0;
if any(strncmpi(varargin,'r',1))
    r = varargin{1+find(strncmpi(varargin,'r',1),1,'last')};
end
if r==0,
    r=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 18 20 22 24 26 28 30 32 36 40 44 48 52 56 60 64 72 80 96 112 128 142 160 176 192 224 256];
    maxdr=min([length(v(1).x) length(v(1).y)]);
    r=r(1:find(r<maxdr,1,'last'));
end
ndr=length(r);

% maxorder:
maxorder = 4;
if any(strncmpi(varargin,'maxorder',3)),
    maxorder = max(4,varargin{1+find(strncmpi(varargin,'maxorder',3),1,'last')});
end
if maxorder>30
    error('Maximum order too large.');
end

%include zero vectors? (true if option '0' is NOT present)
validvector = ~any(strcmp(varargin,'0'));

% initialisations:
stfun.hlvi   = zeros(ndr,length(bin));
stfun.htvi   = zeros(ndr,length(bin));
stfun.pdflvi = zeros(ndr,length(bin));
stfun.pdftvi = zeros(ndr,length(bin));


% computes the histograms for each vector field and stacks them:
% 09/04/2013 option 'paral'
if any(strncmpi(varargin,'parallel',3))
    try matlabpool open
    end
    parfor i=1:numel(v)
        hi(i)=comphistv(v(i),bin,r,validvector); % modified v2.02
    end
    for rr=1:ndr
        for i=1:numel(v)
            stfun.hlvi(rr,:) = stfun.hlvi(rr,:) + hi(i).hlvi(rr,:);
            stfun.htvi(rr,:) = stfun.htvi(rr,:) + hi(i).htvi(rr,:);
        end
    end
else
    for i=1:numel(v)
        hi=comphistv(v(i),bin,r,validvector); % modified v2.02
        for rr=1:ndr
            stfun.hlvi(rr,:) = stfun.hlvi(rr,:) + hi.hlvi(rr,:);
            stfun.htvi(rr,:) = stfun.htvi(rr,:) + hi.htvi(rr,:);
        end
    end
end

% find the largest non-empty r
% (assuming that all the v(i) have the same size)
ndr = length(find(sum(hi(1).hlvi,2)));  
r = r(1:ndr);

% computes the pdf (normalized histograms) and the means (should be approx.
% zero):
meanlvi=zeros(1,ndr);
meantvi=zeros(1,ndr);

for rr=1:ndr
    
    % PDF of increments:
    nlvi=sum(stfun.hlvi(rr,:));
    if nlvi,
        stfun.pdflvi(rr,:) = stfun.hlvi(rr,:) / (nlvi*binwidth);
    else
        stfun.pdflvi(rr,:) = zeros(1,length(bin));
    end
    ntvi=sum(stfun.htvi(rr,:));
    if ntvi,
        stfun.pdftvi(rr,:) = stfun.htvi(rr,:) / (ntvi*binwidth);
    else
        stfun.pdftvi(rr,:) = zeros(1,length(bin));
    end
    
    % Structure functions:
    if ~center_sf
        % Computes the (non-centered) structure functions
        for order=1:maxorder,
            stfun.lsf(rr,order)    = sum(stfun.pdflvi(rr,:).*bin.^order)*binwidth;
            stfun.tsf(rr,order)    = sum(stfun.pdftvi(rr,:).*bin.^order)*binwidth;
            stfun.lsfabs(rr,order) = sum(stfun.pdflvi(rr,:).*abs(bin).^order)*binwidth;
            stfun.tsfabs(rr,order) = sum(stfun.pdftvi(rr,:).*abs(bin).^order)*binwidth;
        end
    else
        % Computes the (centered) structure functions
        meanlvi(rr) = sum(stfun.pdflvi(rr,:).*bin)*binwidth;
        meantvi(rr) = sum(stfun.pdftvi(rr,:).*bin)*binwidth;
        for order=1:maxorder,
            stfun.lsf(rr,order)    = sum(stfun.pdflvi(rr,:).*(bin-meanlvi(rr)).^order)*binwidth;
            stfun.tsf(rr,order)    = sum(stfun.pdftvi(rr,:).*(bin-meanlvi(rr)).^order)*binwidth;
            stfun.lsfabs(rr,order) = sum(stfun.pdflvi(rr,:).*abs(bin-meanlvi(rr)).^order)*binwidth;
            stfun.tsfabs(rr,order) = sum(stfun.pdftvi(rr,:).*abs(bin-meanlvi(rr)).^order)*binwidth;
        end
    end
    
    % Skewness and flatness:
    stfun.skew_long(rr)  = stfun.lsf(rr,3)/stfun.lsf(rr,2)^(3/2);
    stfun.skew_trans(rr) = stfun.tsf(rr,3)/stfun.tsf(rr,2)^(3/2);
    stfun.flat_long(rr)  = stfun.lsf(rr,4)/stfun.lsf(rr,2)^2;
    stfun.flat_trans(rr) = stfun.tsf(rr,4)/stfun.tsf(rr,2)^2;
end

stfun.r = r;
stfun.scaler = abs(v(1).x(2)-v(1).x(1));
stfun.unitr = v(1).unitx;
stfun.bin = bin;
stfun.binwidth = binwidth;
stfun.unitf = v(1).unitvx;

% history field:
if length(v)>1
    stfun.history = {v(1).history ; ...
        ['[concat fields 1..' num2str(length(v)) ']']; 'vsf(ans)'};
else
    stfun.history = {v.history{:} 'vsf(ans)'}';
end

%new v2.03
stfun.n = length(v)*length(v(1).x)*length(v(1).y);
stfun.nfields = length(v);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% END %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function hi=comphistv(v,bin,r,validvector)
% internal function, that computes the long. and transv. histograms
% for a single vector field.
% validvector=true means that only nonzeros elements are used


nx=size(v.vx,1);
ny=size(v.vy,2);

for rr=1:length(r),

    % horizontal shift
    if (r(rr)<nx),
        % computes the horizontal increments of the horizontal component of the velocity (i.e.: longitudinal increments):
        dvlx = v.vx((1+r(rr)):nx, 1:ny) - v.vx(1:(nx-r(rr)), 1:ny);       
        % kills (i.e.: puts to 0) the vel.incr. computed from erroneous
        % (zero) vectors:
        if validvector, dvlx = dvlx .* logical(v.vx((1+r(rr)):nx, 1:ny)~=0) .* logical(v.vx(1:(nx-r(rr)), 1:ny)~=0); end
        dvlx_vect = reshape(dvlx, 1, (nx-r(rr))*ny);  % converts the matrix into vector
        hdvlx = hist( dvlx_vect(dvlx_vect~=0), bin );            % computes the histogram of the nonzero values.

        % computes the horizontal increment of the vertical component of velocity (i.e.: transverse):
        dvty = v.vy((1+r(rr)):nx, 1:ny) - v.vy(1:(nx-r(rr)), 1:ny);
        if validvector, dvty = dvty .* logical(v.vy((1+r(rr)):nx, 1:ny)~=0) .* logical(v.vy(1:(nx-r(rr)), 1:ny)~=0); end
        dvty_vect = reshape(dvty, 1, (nx-r(rr))*ny);  
        hdvty = hist( dvty_vect(dvty_vect~=0), bin );

    else
        hdvlx=0;
        hdvty=0;
    end

    % vertical shift
    if (r(rr)<ny),
        dvtx = -v.vx (1:nx, (1+r(rr)):ny) + v.vx (1:nx, 1:(ny-r(rr)));
          % (bug fixed here for the sign of dvtx, v2.10)
        if validvector, dvtx = dvtx .* logical(v.vx (1:nx, (1+r(rr)):ny)~=0) .* logical(v.vx (1:nx, 1:(ny-r(rr)))~=0); end
        dvtx_vect = reshape(dvtx, 1, nx*(ny-r(rr)));
        hdvtx = hist(dvtx_vect(dvtx_vect~=0),bin);

        dvly = v.vy (1:nx, (1+r(rr)):ny) - v.vy (1:nx, 1:(ny-r(rr)));
        if validvector, dvly = dvly .* logical(v.vy (1:nx, (1+r(rr)):ny)~=0) .* logical(v.vy (1:nx, 1:(ny-r(rr)))~=0); end     
        dvly_vect = reshape(dvly, 1, nx*(ny-r(rr)));
        hdvly = hist(dvly_vect(dvly_vect~=0),bin);

    else
        hdvtx=0;
        hdvly=0;
    end

    hi.hlvi(rr,:)=hdvlx+hdvly;      % sums the histograms of longitudinal velocity increments
    hi.htvi(rr,:)=hdvtx+hdvty;      % sums the histograms of transverse velocity increments
  
end
