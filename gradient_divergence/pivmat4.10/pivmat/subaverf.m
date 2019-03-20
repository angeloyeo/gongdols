function vv=subaverf(v,opt)
%SUBAVERF  Subtract the ensemble or spatial average of a field
%   FF = SUBAVERF(F) subtracts the 'ensemble average' from the
%   vector/scalar fields F. It subtracts from each F the field averaged
%   over all F, as computed from AVERF. The field subtracted therefore
%   corresponds to an 'ensemble' or 'temporal' average (it is not a spatial
%   average).
%
%   FF = SUBAVERF(F,AXIS) subtracts the spatial average (computed by
%   SPAVERF), averaged over the direction AXIS, where AXIS='X', 'Y' or
%   'XY'.
%
%   If no output argument, the result is displayed by SHOWF.
%
%   Example:
%     v = loadvec('*.VC7');
%     showf(subaverf(v));
%
%   Note: To subtract both an ensemble average and a spatial average, use
%   FF = OPERF('-', F, AVERF(SPAVERF(F,'...')));
%
%   See also AVERF, SPAVERF, AZAVERF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.30,  Date: 2013/04/26
%   This function is part of the PIVMat Toolbox


% History:
% 2005/02/16: v1.00, first version (originally called 'submeanvec')
% 2005/02/18: v1.01, bug fixed for nx <> ny
% 2005/09/07: v1.02, history and arg check added.
% 2005/10/06: v1.03, option 'ensemble' added. now called 'subavervec'.
% 2005/10/11: v1.10, subaverf (from subavervec 1.03, 2005/10/06)
% 2009/11/24: v1.11, cosmetics
% 2013/03/13: v1.20, works with 3D fields
% 2013/04/26: v1.30, now 'ensemble' by default

% error(nargchk(1,2,nargin));

if (ischar(v) || iscellstr(v))
    v=loadvec(v);
end 

if nargin<2
    opt='e';   % <-- default behaviour changed, v1.30 !
end

vv=v;

vecmode=isfield(v(1),'vx');   % 1 for vector field, 0 for scalar field

if strfind(lower(opt),'e')
    ev=averf(v);
end

for i=1:length(v)
    if strfind(lower(opt),'e')   %new v1.03
        if vecmode
            vv(i).vx = (v(i).vx - ev.vx).*logical(v(i).vx);  % modified v1.11
            vv(i).vy = (v(i).vy - ev.vy).*logical(v(i).vy);
            if isfield(v(i),'vz')
                 vv(i).vz = (v(i).vz - ev.vz).*logical(v(i).vz);
            end
        else
            vv(i).w = (v(i).w - ev.w).*logical(v(i).w);
        end
    else
        av=spaverf(v(i),opt);
        if vecmode
            vv(i).vx = (v(i).vx - av.vx).*logical(v(i).vx);
            vv(i).vy = (v(i).vy - av.vy).*logical(v(i).vy);
            if isfield(v(i),'vz')
                vv(i).vz = (v(i).vz - av.vz).*logical(v(i).vz);
            end
        else
            vv(i).w = (v(i).w - av.w).*logical(v(i).w);
        end
    end
    
    vv(i).history = {v(i).history{:} ['subaverf(ans, ''' opt ''')']}';
end

if nargout==0
    showf(vv);
    clear vv
end
