function [af, std, rms]=averf(f,opt)
%AVERF  Average, standard deviation and rms of vector/scalar fields
%   AF = AVERF(F) returns the average of the vector/scalar fields F.
%   AF is a field of the same type as F (i.e., vector or scalar), whose
%   elements are the average of the elements of the fields F. Depending on
%   the nature of the fields, AF corresponds to a time average, an ensemble
%   average, or a phase average.
%
%   [AF, STD, RMS] = AVERF(F,..) returns additional scalar fields:
%     - STD, standard deviation: at each location (x,y), one has:
%         STD(u) = < [ u - <u> ]^2 >^(1/2),  where <> is a temporal avg.
%     - RMS, root mean square: at each location (x,y), one has:
%         RMS(u) = < u^2 >^(1/2)
%
%   By default, AVERF considers that the zero elements of F are erroneous,
%   and does not include them in the computations. If however you want to
%   force the zero elements to be included in the computations, specify
%   AVERF(F,'0').
%
%   If no output argument is specified, the average field AF is displayed.
%
%   Examples:
%      v = loadvec('*.vc7');
%      showf(averf(v));
%
%      [m, std, rms]=averf(vec2scal(v,'uy'));
%      showf(std);
%
%      averf *.vc7      % shows the average of the files matching *.vc7
%
%   See also SMOOTHF, SPAVERF, SUBAVERF, AZAVERF, PHASEAVERF, STATF


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.40,  Date: 2016/10/16
%   This function is part of the PIVMat Toolbox


% History:
% 2005/02/06: v1.00, first version.
% 2005/10/11: v1.10, averf (from ensavervec v1.00, 2005/10/06). also
%                    computes the rms field.
% 2006/03/10: v1.11, new history
% 2006/04/25: v1.12, bug fixed for scalar fields
% 2013/02/22: v1.20, works with 3D fields
% 2013/05/08: v1.30, bug fixed for computation of rms with 0 components
%                    (thanks Maciej Bujalski)
% 2016/10/09: v1.40, output parameters changed. Now the 2nd parameter is
%                    the standard deviation (before called "rms") while the
%                    3rd parameter is the true rms.


%error(nargchk(1,2,nargin));

if (ischar(f) || iscellstr(f) || isnumeric(f))
    f=loadvec(f);
end

if nargin<=1, opt=''; end

af=f(1);

vecmode=isfield(f(1),'vx');   % 1 for vector field, 0 for scalar field

nx=length(f(1).x);
ny=length(f(1).y);

nf = length(f); % number of fields

if vecmode
    af.vx=zeros(nx,ny);
    af.vy=zeros(nx,ny);
    nzx=zeros(nx,ny);
    nzy=zeros(nx,ny);
    if isfield(f(1),'vz')
        af.vz=zeros(nx,ny);
        nzz=zeros(nx,ny);
    end
    for n=1:nf
        af.vx = af.vx+f(n).vx;
        af.vy = af.vy+f(n).vy;
        nzx = nzx+logical(f(n).vx~=0); % counts the nonzero elements
        nzy = nzy+logical(f(n).vy~=0); % counts the nonzero elements
        if isfield(f(n),'vz')
            af.vz = af.vz+f(n).vz;
            nzz = nzz+logical(f(n).vz~=0);
        end
    end
    
    if strfind(opt,'0')
        af.vx=af.vx/nf; % normalise with all the elements (including 0)
        af.vy=af.vy/nf;
        if isfield(f(1),'vz')
            af.vz=af.vz/nf;
        end
    else
        af.vx = af.vx./nzx;
        af.vx(isnan(af.vx)) = 0;
        af.vy = af.vy./nzy;
        af.vy(isnan(af.vy)) = 0;
        if isfield(f(1),'vz')
            af.vz = af.vz./nzz;
            af.vz(isnan(af.vz)) = 0;
        end
    end
    
else
    
    af.w=zeros(nx,ny);
    nzw=zeros(nx,ny);
    for n=1:nf,
        nzw = nzw+logical(f(n).w~=0);
        af.w = af.w+double(f(n).w); % changed v1.12
    end
    if strfind(opt,'0')  % bug fixed here, v1.20
        af.w = af.w/nf;
    else
        af.w = af.w./nzw;
        af.w(isnan(af.w)) = 0;
    end
end

af.name=['<' f(1).name '...' f(end).name '>'];

af.history = {{f.history}' ['averf(ans, ''' opt ''')']}';

if nargout==0
    showf(af);
    clear af
end

% compute here std and rms, if necessary

if nargout>1
    rms=f(1);
    std=f(1);
    if vecmode
        rms=rmfield(rms,{'vx','vy','unitvx','unitvy','namevx','namevy'});
        if isfield(f(1),'vz')
            rms=rmfield(rms,{'vz','unitvz','namevz'});
        end
        std=rms;
        rms.unitw = f(1).unitvx;
        rms.namew = 'rms(u)';
        std.unitw = f(1).unitvx;
        std.namew = 'std(u)';
    else
        std.namew = ['std(' f(1).namew ')'];
        rms.namew = ['rms(' f(1).namew ')'];
    end
    std.w = zeros(nx,ny);
    rms.w = zeros(nx,ny);
    nzw=zeros(nx,ny);
    for n=1:nf
        if vecmode
            if isfield(f(1),'vz')
                rms.w = rms.w + ((f(n).vx        ).*logical(f(n).vx)).^2 + ((f(n).vy        ).*logical(f(n).vy)).^2 + ((f(n).vz        ).*logical(f(n).vz)).^2  ; %FIXED
                std.w = std.w + ((f(n).vx - af.vx).*logical(f(n).vx)).^2 + ((f(n).vy - af.vy).*logical(f(n).vy)).^2 + ((f(n).vz - af.vz).*logical(f(n).vz)).^2  ; %FIXED
                nzw = nzw+logical((f(n).vx~=0)&(f(n).vy~=0)&(f(n).vz~=0));
            else
                rms.w = rms.w + ((f(n).vx        ).*logical(f(n).vx)).^2 + ((f(n).vy        ).*logical(f(n).vy)).^2 ; % FIXED
                std.w = std.w + ((f(n).vx - af.vx).*logical(f(n).vx)).^2 + ((f(n).vy - af.vy).*logical(f(n).vy)).^2 ; % FIXED
                nzw = nzw+logical((f(n).vx~=0)&(f(n).vy~=0));
            end
        else
            rms.w = rms.w + ((f(n).w       ).*logical(f(n).w)).^2; % FIXED
            std.w = std.w + ((f(n).w - af.w).*logical(f(n).w)).^2; % FIXED
            nzw=nzw+logical(f(n).w~=0);
        end
    end
    if strfind(opt,'0')
        std.w = std.w/nf;
        rms.w = rms.w/nf;
    else
        std.w = std.w./nzw;
        rms.w = rms.w./nzw;
    end
    std.w = std.w.^0.5;
    std.history = {{f.history}' 'std(ans)'}';
    rms.w = rms.w.^0.5;
    rms.history = {{f.history}' 'rms(ans)'}';
end
