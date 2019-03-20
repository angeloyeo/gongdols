function vsf_disp(stfun,varargin)
%VSF_DISP  Displays velocity structure functions computed from VSF.
%   VSF_DISP(STFUN,'Property',...) displays the statistics from the
%   structure STFUN created by VSF, as specified by the following properties:
%      - 'stfun': displays the structure functions
%      - 'hist': displays the histograms
%      - 'skewness': displays the skewness factor
%      - 'flatness': displays the flatness factor
%      - more... (see the m-file for details)
%
%   Additional properties may be specified: 
%      - 'norm': normalize the structure functions and the histograms
%      - 'skip': skip the last dr values (which may be noisy)
%   VSF_DISP(STFILE,'Property',...) does the same, loading the Mat-file
%   STFILE saved by VSF.
%
%   Example: 
%      v = loadvec('*.vc7');
%      st = vsf(filterf(v,1));      
%      vsf_disp(st,'hist','skew');
%
%   See also VSF.

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.11,  Date: 2008/03/28
%   This function is part of the PIVMat Toolbox

% History:
% 2004/05/27: v1.00, first version (C. Morize & F. Moisy)
% 2004/07/27: v1.01, help text changed
% 2005/02/23: v1.02, cosmetics.
% 2006/10/29: v1.10, now only the specified plots are displayed.
%                    help text rewritten; option 'rangeskew' removed. 
%                    now included in PIVMat.
% 2008/03/28: v1.11, does not open new figures

% error(nargchk(1,inf,nargin));

if nargin==1
    error('Additional input argument(s) required to display structure functions.');
end;

if ischar(stfun)
    try
        load(stfun);
        if ~exist('stfun','var')
            error('Invalid Mat-File: does not contain a structure STFUN. See VSF.');
        end;
    catch
        error('The Structure function file does not exist. Run VSF to create it.');
    end;
end;

if ~isfield(stfun,'lsf')
    error('Invalid input argument.');
end;

maxorder=size(stfun.lsf,2);

if any(strncmpi(varargin,'skip',4))
    skiplastdr=3;
else
    skiplastdr=0;
end;  
dr=stfun.r(1:(size(stfun.lsf,1)-skiplastdr));
drlen=length(dr);



%%%%%%%%%%%%%%%%%%% DISPLAYS %%%%%%%%%%%%%%%%%%%%%

if any(strncmpi(varargin,'stfun',3))
    for order=2:maxorder,
        subplot(2,2,min(4,order-1));
        if any(strncmpi(varargin,'norm',1))
            range_pos=find(stfun.lsf(1:drlen,order)>0); range_neg=find(stfun.lsf(1:drlen,order)<0);
            loglog(dr(range_pos)*stfun.scaler, stfun.lsf(range_pos,order)/stfun.lsf(end,2)^(order/2),'r+', dr(range_neg)*stfun.scaler,-stfun.lsf(range_neg,order)/stfun.lsf(end,2)^(order/2),'ro');
            hold on;
            range_pos=find(stfun.tsf(1:drlen,order)>0); range_neg=find(stfun.tsf(1:drlen,order)<0);
            loglog(dr(range_pos)*stfun.scaler, stfun.tsf(range_pos,order)/stfun.tsf(end,2)^(order/2),'bx', dr(range_neg)*stfun.scaler,-stfun.tsf(range_neg,order)/stfun.tsf(end,2)^(order/2),'bs');
            legend('<\delta v_L^n> / std(u_x)^n','<\delta v_T^n> / std(u_x)^n');
            line([1 10],[1e-2 1e-2*10^(order/3)]);
            axis([.1 1e3 10^(-2*order) 10]);
            hold off;
        else
            range_pos=find(stfun.lsf(1:drlen,order)>0); range_neg=find(stfun.lsf(1:drlen,order)<0);
            loglog(dr(range_pos)*stfun.scaler, stfun.lsf(range_pos,order),'r+', dr(range_neg)*stfun.scaler,-stfun.lsf(range_neg,order),'ro');
            hold on;
            range_pos=find(stfun.tsf(1:drlen,order)>0); range_neg=find(stfun.tsf(1:drlen,order)<0);
            loglog(dr(range_pos)*stfun.scaler, stfun.tsf(range_pos,order),'bx', dr(range_neg)*stfun.scaler,-stfun.tsf(range_neg,order),'bs');
            legend(['<\delta v_L^n> (' stfun.unitf ')^n'],['<\delta v_T^n> (' stfun.unitf ')^n']);
            %axis([.1 1e3 1e-4 10]);
            hold off;
        end;
        xlabel(['r (' stfun.unitr ')']);
        title([num2str(order) 'th-order S.F.']);
    end;
end;


if any(strncmpi(varargin,'correlation',4))
    corr_long =1-stfun.lsf(1:drlen,2)/(stfun.lsf(end,2)); % bug facteur 2 corrige 27/05/04
    corr_trans=1-stfun.tsf(1:drlen,2)/(stfun.tsf(end,2));
    plot(dr*stfun.scaler,corr_long,'ro-','markersize',3);
    hold on;
    plot(dr*stfun.scaler,corr_trans,'bs-','markersize',3);
    xlabel(['r (' stfun.unitr ')']);
    legend('C_L (r)','C_T (r)');
    axis([0 stfun.scaler*dr(end) -0.2 1]);
    title('Correlation functions');
    line([0 stfun.scaler*max(stfun.dr)],[0 0]);
    hold off;
end;

if any(strncmpi(varargin,'s3/r',4))
    n3lsf=-stfun.lsf(1:drlen,3)'./(dr*stfun.scaler/1000);
    semilogx(dr*stfun.scaler,n3lsf,'ro-');
    xlabel(['r (' stfun.unitr ')']);
    ylabel(['-<\delta v_L^3> / r  ((' stfun.unitf ')^2)']);
    title('Normalized 3rd-order L.S.F.');
    line([.1 1e2],[0 0]);
    axis([1 100 -1.2*max(abs(n3lsf)) 1.2*max(abs(n3lsf))]);
end;

if any(strncmpi(varargin,'ess2',4))
    loglog(stfun.lsf(1:drlen,2), stfun.lsf(1:drlen,4),'ro-',...
        stfun.tsf(1:drlen,2), stfun.tsf(1:drlen,4),'bs-');
    xlabel(['<\delta v^2> ((' stfun.unitf ')^2)']);
    ylabel(['<\delta v^4> ((' stfun.unitf ')^4)']);
    legend('Long.','Trans.');
    title('Extended Self-Similarity');
end;

if any(strncmpi(varargin,'skewness',4))
    semilogx(dr*stfun.scaler,-stfun.skew_long(1:drlen),'r+-');
    xlabel(['r (' stfun.unitr ')']);
    ylabel('- S_L = - <\delta v_L^3> / <\delta v_L^2>^{3/2}');
    title('Skewness factors');
    axis([1 1e3 -0.8 0.8]);
    line([1 1e3],[0 0]);
    grid;
end;

if any(strncmpi(varargin,'flatness',4))
    loglog(dr*stfun.scaler,stfun.flat_long(1:drlen),'ro-','markersize',3);
    hold on;
    loglog(dr*stfun.scaler,stfun.flat_trans(1:drlen),'bs-','markersize',3);
    xlabel(['r (' stfun.unitr ')']);
    ylabel('F');
    title('Flatness factors');
    legend('F_L','F_T');
    axis([1 1e2 2 20]);
    line([.1 1000],[3 3]);
    hold off;
end;

if any(strncmpi(varargin,'s3n',3))
    range_pos=find(stfun.lsf(1:drlen,3)>0);
    range_neg=find(stfun.lsf(1:drlen,3)<0);
    loglog(dr(range_pos)*stfun.scaler, stfun.skew_long(range_pos),'r+', ...
           dr(range_neg)*stfun.scaler,-stfun.skew_long(range_neg),'ro');
    xlabel(['r (' stfun.unitr ')']);
    ylabel('S_L = <\delta v_L^3> / <\delta v_L^2>^{3/2}');
    if (~isempty(range_pos) && ~isempty(range_neg)),legend('S>0','S<0'); end;
    if (~isempty(range_pos) && isempty(range_neg)),legend('S>0'); end;
    if (isempty(range_pos) && ~isempty(range_neg)),legend('S<0'); end;
    title('Skewness factors');
    axis([1 1e2 1e-3 1]);
end;

if any(strncmpi(varargin,'hist',1))
    plotn=0;
    for r=1:3:length(dr),
        plotn=min(4,plotn+1);
        subplot(2,2,plotn);
        if any(strncmpi(varargin,'norm',1))
            semilogy(stfun.bin/sqrt(stfun.lsf(r,2)),stfun.hlvi(r,:),'ro','markersize',3);
            hold on;
            semilogy(stfun.bin/sqrt(stfun.tsf(r,2)),stfun.htvi(r,:),'bs','markersize',3);
            xlabel('\delta v_r / <\delta v_r^2>^{1/2}');
            %%% gaussian fit
            binvec_gauss=linspace(stfun.bin(1), stfun.bin(end),5000);
            semilogy((binvec_gauss/sqrt(stfun.lsf(r,2))),max(stfun.hlvi(r,:))*exp(-(1/2)*(((binvec_gauss/sqrt(stfun.lsf(r,2)))).^2)),'k-');
            maxy=10^(ceil(log10(max(max([stfun.hlvi(:,:) stfun.htvi(:,:)])))));
            axis([-20 20 maxy*1e-6 maxy]);
            hold off;
        else          
            semilogy(stfun.bin,stfun.hlvi(r,:),'ro-','markersize',3);
            hold on;
            semilogy(stfun.bin,stfun.htvi(r,:),'bs-','markersize',3);
            xlabel(['(' stfun.unitf ')']);
            maxy=10^(ceil(log10(max(max([stfun.hlvi(:,:) stfun.htvi(:,:)])))));
            axis([-20*sqrt(stfun.lsf(r,2)) 20*sqrt(stfun.lsf(r,2)) 0 maxy]);
            hold off;
        end;
        legend('\delta v_L','\delta v_T');
        ylabel('histograms');
        title(['r = ' num2str(dr(r)) '\delta x = ' num2str(dr(r)*stfun.scaler) ' ' stfun.unitr]);
        line([0 0],[1 maxy]);
    end;
end;