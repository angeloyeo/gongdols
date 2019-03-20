function histvec_disp(v,smooth,bin,opt)
%HISTVEC_DISP  Displays distributions of vector fields.
%   HISTVEC_DISP(V) displays the distributions of the components of the
%   vector field(s) V.
%
%   HISTVEC_DISP(V,SMOOTH) computes the velocity distributions averaged
%   over SMOOTH consecutive fields. Use SMOOTH=1 for no smoothing, or
%   SMOOTH=0 to smooth over all the fields (by default). If SMOOTH>1,
%   press a key between each figure.
%
%   HISTVEC_DISP(V,SMOOTH,BIN) computes the histograms among the bins
%   specified by the vector BIN. If this argument is not present, the
%   appropriate range of bins is estimated from the rms of the first
%   field.
%
%   HISTVEC_DISP(...,OPT), where OPT is a string that may contain one or
%   more of the following letters (all by default):
%        'n': normalize the histogram (pdf)
%        'g': also displays a gaussian fit
%        'l': log-coordinate for the y axis
%
%   Example:
%      v = loadvec('*.vc7');
%      histvec_disp(v,5,linspace(-0.5,0.5,50),'ngl');
%
%   See also HISTF, STATF, HISTSCAL_DISP.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.11,  Date: 2016/10/21
%   This function is part of the PIVMat Toolbox


% History:hi
% 2004/04/26: v1.00, first version.
% 2005/02/23: v1.01, cosmetics
% 2005/09/06: v1.02, id.
% 2006/04/28: v1.03, now accepts filenames as input argument
% 2011/03/25: v1.04, loadset removed
% 2013/03/14: v1.10, works with 3d fields
% 2016/10/21: v1.11, bug fixed xlabel

% error(nargchk(1,4,nargin));

if (ischar(v) || iscellstr(v))
    v=loadvec(v);
end % new v1.03
maxframe=length(v);

if nargin<2, smooth=0; end
if smooth==0, smooth=maxframe; end

if nargin<3, bin=0; end
% if bin not defined, computes it from the statistics of the 1st frame
if bin==0
    stat_vx = statf(v(1));
    maxbin=10*stat_vx.rms;
    bin=linspace(-maxbin, maxbin, 100);
end

delta = bin(2)-bin(1);

if nargin<4, opt='ngl'; end

% average the histograms:
for num=1:floor(maxframe/smooth)
    range=((num-1)*smooth+1):(num*smooth);
    sm_hix(num,:)=histf(vec2scal(v(range),'ux'),bin);
    sm_hiy(num,:)=histf(vec2scal(v(range),'uy'),bin);
    if isfield(v(range),'vz')
        sm_hiz(num,:)=histf(vec2scal(v(range),'uz'),bin);
        [sm_stat_vx(num),sm_stat_vy(num),sm_stat_vz(num)] = statf(v(range));
    else
        [sm_stat_vx(num),sm_stat_vy(num)] = statf(v(range));
    end
    % normalise the histograms
    if strfind(lower(opt),'n')
        sm_hix(num,:)=sm_hix(num,:)/(sum(sm_hix(num,:),2)*delta);
        sm_hiy(num,:)=sm_hiy(num,:)/(sum(sm_hiy(num,:),2)*delta);
        if isfield(v(range),'vz')
            sm_hiz(num,:)=sm_hiz(num,:)/(sum(sm_hiz(num,:),2)*delta);
        end
    end
end


% displays the histograms
for num=1:floor(maxframe/smooth)
    range=((num-1)*smooth+1):(num*smooth);
    if strfind(lower(opt),'l')
        if isfield(v(1),'vz')
            semilogy(bin,sm_hix(num,:),'ro',bin,sm_hiy(num,:),'bs',bin,sm_hiz(num,:),'m^');
        else
            semilogy(bin,sm_hix(num,:),'ro',bin,sm_hiy(num,:),'bs');
        end
        maxy=10^(ceil(log10(max([sm_hix(num,:) sm_hiy(num,:)]))));
        miny=10^(floor(log10(min([sm_hix(num,find(sm_hix(num,:)~=0)) sm_hiy(num,find(sm_hiy(num,:)~=0))]))));        
    else
        if isfield(v(1),'vz')
            plot(bin,sm_hix(num,:),'ro',bin,sm_hiy(num,:),'bs',bin,sm_hiz(num,:),'m^');
            plot(bin,sm_hix(num,:),'ro',bin,sm_hiy(num,:),'bs');
        else
            plot(bin,sm_hix(num,:),'ro',bin,sm_hiy(num,:),'bs');
        end
        maxy=1.2*max([sm_hix(num,:) sm_hiy(num,:)]);
        miny=0;
    end
    axis([-15*sm_stat_vy(num).std 15*sm_stat_vy(num).std miny maxy]);
    
    line([0 0],[miny maxy])
    xlabel([v(1).namevx ', ' v(1).namevy ' (' v(1).unitvx ')']);
    if isfield(v(1),'vz')
        legend(v(1).namevx, v(1).namevy, v(1).namevz);
    else
        legend(v(1).namevx, v(1).namevy);
    end
    if strfind(lower(opt),'n')
        ylabel('pdf');
    else
        ylabel('Histogram');
    end
    
    if length(range)>1
        title(texliteral([v(1).setname ' / ' v(range(1)).name '..' v(range(end)).name]));
    else
        title(texliteral([v(1).setname ' / ' v(range(1)).name]));
    end
    
    if strfind(lower(opt),'g')
        hold on
        bin_gauss=linspace(bin(1), bin(length(bin)),2000);
        gauss_vx=max(sm_hix(num,:))*exp(-0.5*(bin_gauss - sm_stat_vx(num).mean).^2 / sm_stat_vx(num).std^2);
        gauss_vy=max(sm_hiy(num,:))*exp(-0.5*(bin_gauss - sm_stat_vy(num).mean).^2 / sm_stat_vy(num).std^2);    
        if isfield(v(1),'vz')
            gauss_vz=max(sm_hiz(num,:))*exp(-0.5*(bin_gauss - sm_stat_vz(num).mean).^2 / sm_stat_vz(num).std^2);
        end
        if strfind(lower(opt),'l')
            if isfield(v(1),'vz')
                semilogy(bin_gauss,gauss_vx,'r-',bin_gauss,gauss_vy,'b-',bin_gauss,gauss_vz,'m-');
            else
                semilogy(bin_gauss,gauss_vx,'r-',bin_gauss,gauss_vy,'b-');
            end
        else
            if isfield(v(1),'vz')
                plot(bin_gauss,gauss_vx,'r-',bin_gauss,gauss_vy,'b-');
            else
                plot(bin_gauss,gauss_vx,'r-',bin_gauss,gauss_vy,'b-',bin_gauss,gauss_vz,'m-');
            end
        end
        hold off
    end
    if ~(smooth==maxframe)
        pause
    end
end
