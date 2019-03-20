function statvec_disp(v,smooth)
%STATVEC_DISP  Displays statistics of vector fields.
%   STATVEC_DISP(V) displays statistics (mean, rms and standard deviation)
%   of a set of vector fields as a function of the field number.
%
%   The first 3 subplots show the evolution of the velocity statistics,
%   for each velocity component:
%    - Mean velocity <Vx>, <Vy>, <Vz>  (where <> is the spatial average)
%    - rms velocity <Vx^2>^(1/2), <Vy^2>^(1/2), <Vz^2>^(1/2)
%    - standard deviation <(Vx-<Vx>)^2>^(1/2), <(Vy-<Vy>)^2>^(1/2), etc.
%
%   The last subplot shows the energy (summed over the 2 or 3 velocity
%   components):
%     E_total = (<Vx^2> + <Vy^2> + <Vz^2>) / 2
%     E_mean  = (<Vx>^2 + <Vy>^2 + <Vz>^2) / 2
%     E_turbulent = (<(Vx-<Vx>)^2> + <(Vy-<Vy>)^2 + <(Vz-<Vz>)^2>) / 2
%   (note that E_total = E_mean + E_turbulent)
%
%   STATVEC_DISP(V,SMOOTH) smoothes the statistics over SMOOTH consecutive
%   vector fields. Use SMOOTH=1 for no smoothing (by default).  Use
%   SMOOTH=0 for smoothing over the whole fields (display only one point).
%
%   Example:
%      v = loadvec('*.vc7');
%      statvec_disp(v,10);
%
%   See also STATF, HISTF, HISTVEC_DISP.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.12,  Date: 2016/10/21
%   This function is part of the PIVMat Toolbox


% History:
% 2004/04/22: v1.00, first version.
% 2005/02/23: v1.01, cosmetics
% 2005/09/06: v1.02, id.
% 2005/09/15: v1.03, output arg suppressed.
% 2006/04/27: v1.04, optimized; now reads the setname of v
% 2011/03/25: v1.05, loadset removed
% 2012/05/31: v1.06, help text improved
% 2013/03/14: v1.10, works with 3D fields
% 2013/03/18: v1.11, markers removed
% 2016/10/21: v1.12, labels and legends now use the field data

% error(nargchk(1,2,nargin));

if (ischar(v) || iscellstr(v)), v=loadvec(v); end % new v1.04
maxframe=length(v);

if nargin<2, smooth=1; end
if smooth==0, smooth=maxframe; end

% average the statistics
sm_frame=1:floor(maxframe/smooth);
for num=sm_frame
    range=((num-1)*smooth+1):(num*smooth);
    sm_stat_vx(num)=statf(vec2scal(v(range),'ux'));
    sm_stat_vy(num)=statf(vec2scal(v(range),'uy'));
    if isfield(v(range),'vz')
        sm_stat_vz(num)=statf(vec2scal(v(range),'uz'));
    end
end

% displays the results
subplot(2,2,1);
if isfield(v(1),'vz')
    plot(sm_frame*smooth,[sm_stat_vx(sm_frame).mean],'r-', sm_frame*smooth, [sm_stat_vy(sm_frame).mean],'b-',sm_frame*smooth,[sm_stat_vz(sm_frame).mean],'m-');
    legend(['<' v(1).namevx '>'],['<' v(1).namevy '>'],['<' v(1).namevz '>']);
else
    plot(sm_frame*smooth,[sm_stat_vx(sm_frame).mean],'r-', sm_frame*smooth, [sm_stat_vy(sm_frame).mean],'b-');
    legend(['<' v(1).namevx '>'],['<' v(1).namevy '>']);
end
xlabel('field num');
ylabel(v(1).unitvx);

title('Mean velocity, <V_i>');
line([min(sm_frame*smooth) max(sm_frame*smooth)],[0 0])
ax=ylim;
ylim(max(abs(ax))*[-1 1]);

subplot(2,2,2);
if isfield(v(1),'vz')
    ke_tot=([sm_stat_vx(sm_frame).rms].^2 + [sm_stat_vy(sm_frame).rms].^2 + [sm_stat_vz(sm_frame).rms].^2)/2;
    ke_turb=([sm_stat_vx(sm_frame).std].^2 + [sm_stat_vy(sm_frame).std].^2 + [sm_stat_vz(sm_frame).std].^2)/2;
    ke_mean=([sm_stat_vx(sm_frame).mean].^2 + [sm_stat_vy(sm_frame).mean].^2 + [sm_stat_vz(sm_frame).mean].^2)/2;
else
    ke_tot=([sm_stat_vx(sm_frame).rms].^2 + [sm_stat_vy(sm_frame).rms].^2)/2;
    ke_turb=([sm_stat_vx(sm_frame).std].^2 + [sm_stat_vy(sm_frame).std].^2)/2;
    ke_mean=([sm_stat_vx(sm_frame).mean].^2 + [sm_stat_vy(sm_frame).mean].^2)/2;
end
plot(sm_frame*smooth,ke_tot,'r-', sm_frame*smooth,ke_turb,'b-', sm_frame*smooth,ke_mean,'m-');
legend('E total','E turb','E mean');
xlabel('field num');
ylabel(['E (' v(1).unitvx ')^2']);
title('Total, mean and turbulent kinetic energies');
ax=ylim;
ylim([0 max(ylim)]);

subplot(2,2,3);
if isfield(v(1),'vz')
    plot(sm_frame*smooth,[sm_stat_vx(sm_frame).std],'r-', sm_frame*smooth, [sm_stat_vy(sm_frame).std],'b-', sm_frame*smooth, [sm_stat_vz(sm_frame).std],'m-');
    legend(['std(' v(1).namevx ')'],['std(' v(1).namevy ')'],['std(' v(1).namevz ')']);
else
    plot(sm_frame*smooth,[sm_stat_vx(sm_frame).std],'r-', sm_frame*smooth, [sm_stat_vy(sm_frame).std],'b-');
    legend(['std(' v(1).namevx ')'],['std(' v(1).namevy ')']);
end
xlabel('field num');
ylabel(v(1).unitvx);
title('Standard deviation, std(V_i) = <(V_i-<V_i>)^2>^{1/2}');
ax=ylim;
ylim([0 max(ylim)]);

subplot(2,2,4);
if isfield(v(1),'vz')
    plot(sm_frame*smooth,[sm_stat_vx(sm_frame).rms],'r-', sm_frame*smooth, [sm_stat_vy(sm_frame).rms],'b-',sm_frame*smooth, [sm_stat_vz(sm_frame).rms],'m-');
    legend(['rms(' v(1).namevx ')'],['rms(' v(1).namevy ')'],['rms(' v(1).namevz ')']);
else
    plot(sm_frame*smooth,[sm_stat_vx(sm_frame).rms],'r-', sm_frame*smooth, [sm_stat_vy(sm_frame).rms],'b-');
    legend(['rms(' v(1).namevx ')'],['rms(' v(1).namevy ')']);
end
xlabel('field num');
ylabel(v(1).unitvx);
title('rms velocity, rms(V_i) = <V_i^2>^{1/2}');
ax=ylim;
ylim([0 max(ylim)]);

