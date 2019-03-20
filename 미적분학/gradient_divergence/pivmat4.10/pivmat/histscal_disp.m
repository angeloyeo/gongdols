function histscal_disp(s,smooth,bin,opt)
%HISTSCAL_DISP  Displays distributions of scalar fields.
%   HISTSCAL_DISP(S) displays the distributions of the scalar field(s) S.
%
%   HISTSCAL_DISP(S,SMOOTH) computes the velocity distributions averaged
%   over SMOOTH consecutive fields. Use SMOOTH=1 for no smoothing, or
%   SMOOTH=0 to smooth over all the fields (by default).  If SMOOTH>1,
%   press a key between each figure.
%
%   HISTSCAL_DISP(S,SMOOTH,BIN) computes the histograms among the bins
%   specified by the vector BIN. If this argument is not present, the
%   appropriate range of bins is estimated from the rms of the first
%   field.
%
%   HISTSCAL_DISP(...,OPT), where OPT is a string that may contain one or
%   more of the following letters (all by default):
%        'n': normalize the histogram (pdf)
%        'g': also displays a gaussian fit
%        'l': log-coordinate for the y axis
%
%   Example:
%      v = loadvec('*.vc7');
%      histscal_disp(vec2scal(v,'rot'));
%
%   See also HISTF, HISTVEC_DISP.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.11,  Date: 2016/10/21
%   This function is part of the PIVMat Toolbox


% History:
% 2004/04/26: v1.00, first version.
% 2004/09/23: v1.01, the mean of the Gaussian histo is not subtracted.
% 2005/02/23: v1.02, cosmetics
% 2005/09/06: v1.03, id.
% 2006/10/06: v1.04, do not create a new figure at each plot
% 2008/10/20: v1.05, now works with non-double scalar images (IMX/IM7)
% 2013/03/13: v1.10, slight changes
% 2016/10/21: v1.11, new default binning for fields with non-zero mean

% error(nargchk(1,4,nargin));

maxframe=length(s);

if nargin<2, smooth=0; end
if smooth==0, smooth=maxframe; end

if isfield(s,'vx')
    s=vec2scal(s,'ux');
end

for i=1:numel(s)   % new v1.05
    s(i).w = double(s(i).w);
end

if nargin<3, bin=0; end
% if bin not defined, computes if from the statistics of the 1st frame

if bin==0
    stat=statf(s(1));
    if stat.mean < stat.std
        bin = linspace(-20*stat.std, 20*stat.std, 200);
    else   % new v1.11
        bin = linspace(stat.mean-20*stat.std, stat.mean+20*stat.std, 200);
    end
end

delta = bin(2)-bin(1);

if nargin<4, opt='ngl'; end

% average the histograms:
for num=1:floor(maxframe/smooth)
    range=((num-1)*smooth+1):(num*smooth);
    sm_hi(num,:)=histf(s(range),bin);
    sm_stat(num)=statf(s(range));
    % normalise les histos
    if findstr(lower(opt),'n'),
        sm_hi(num,:)=sm_hi(num,:)/(sum(sm_hi(num,:),2)*delta);
    end
end


% displays the histograms
for num=1:floor(maxframe/smooth)  
    range=((num-1)*smooth+1):(num*smooth);
    if strfind(lower(opt),'l')
        semilogy(bin,sm_hi(num,:),'ro');
        maxy=10^(ceil(log10(max(sm_hi(num,:)))));
        miny=10^(floor(log10(min(sm_hi(num,find(sm_hi(num,:)~=0))))));        
    else
        plot(bin,sm_hi(num,:),'ro');
        maxy=1.2*max(sm_hi(num,:));
        miny=0;
    end
    
    ylim([miny maxy]);
    if sm_stat(num).mean < sm_stat(num).std
        xlim([-15*sm_stat(num).std, 15*sm_stat(num).std]);
    else
        xlim([sm_stat(num).mean-15*sm_stat(num).std, sm_stat(num).mean+15*sm_stat(num).std]);
    end
    
    line([0 0],[miny maxy]);  
    xlabel([s(1).namew ' (' s(1).unitw ')']);
    if strfind(lower(opt),'n')
        ylabel('pdf');
    else
        ylabel('Histogram');
    end
    
    if length(range)>1
        title(texliteral([s(1).setname ' / ' s(range(1)).name '..' s(range(end)).name]));
    else
        title(texliteral([s(1).setname ' / ' s(range(1)).name]));
    end
        
    if strfind(lower(opt),'g')
        hold on
        bin_gauss=linspace(bin(1), bin(length(bin)),2000);
%        gauss_vx=1/(sqrt(2*pi)*sm_stat(num).std)*exp(-0.5*(bin_gauss - sm_stat(num).mean).^2 / sm_stat(num).std^2);
        gauss_vx=1/(sqrt(2*pi)*sm_stat(num).std)*exp(-0.5*(bin_gauss).^2 / sm_stat(num).std^2);
        if strfind(lower(opt),'l')
            semilogy(bin_gauss,gauss_vx,'b-');   
        else
            plot(bin_gauss,gauss_vx,'b-');   
        end
        hold off
    end
    if ~(smooth==maxframe)
        pause
    end
end
