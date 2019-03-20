function vv=spaverf(v,opt)
%SPAVERF  Spatial average over X and/or Y of a vector/scalar field
%   FF = SPAVERF(F) computes the spatial average of the vector/scalar
%   field F.  FF is a uniform vector/scalar field. If F is an array of
%   fields, SPAVERF(F) computes the individual spatial average of each
%   field.
%
%   FF = SPAVERF(F,AXIS) averages over the AXIS direction, where AXIS is
%   'X', 'Y' or 'XY'. Default is 'XY'.  FF is a vector/scalar field uniform
%   in the AXIS direction.
%
%   By default, SPAVERF considers that the zero elements of F are erroneous,
%   and does not include them in the computations. If however you want to
%   force the zero elements to be included in the computations, specify
%   SPAVERF(F,'0').
%
%   If no output argument, the result is displayed by SHOWF.
%
%   See also SMOOTHF, AVERF, SUBAVERF, AZAVERF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.20,  Date: 2013/02/22
%   This function is part of the PIVMat Toolbox


% History:
% 2005/02/06: v1.00, first version.
% 2005/10/12: v1.10, new name spaverf, works with vector and scalar fields
%                    (from avervec v1.00, 2005/10/06).
% 2005/10/21: v1.11, zero elements not included in the average by default.
% 2013/02/22: v1.20, works with 3D fields

% error(nargchk(1,2,nargin));

if (ischar(v) || iscellstr(v) || isnumeric(v))
    v=loadvec(v);
end

if nargin==1
    opt='xy';
end

vv = v;

vecmode = isfield(v(1),'vx');   % 1 for vector field, 0 for scalar field

nx=length(v(1).x);
ny=length(v(1).y);

for i=1:length(v)   % do NOT use parfor here!
    switch strrep(lower(opt),'0',''),
        case 'x',
            if vecmode,
                if strfind(opt,'0'),
                    vv(i).vx=ones(nx,1)*mean(v(i).vx,1);
                    vv(i).vy=ones(nx,1)*mean(v(i).vy,1);
                    if isfield(v(i),'vz')
                        vv(i).vz=ones(nx,1)*mean(v(i).vz,1);
                    end
                else
                    vv(i).vx=ones(nx,1)*meannz(v(i).vx,1);
                    vv(i).vy=ones(nx,1)*meannz(v(i).vy,1);
                    if isfield(v(i),'vz')
                        vv(i).vz=ones(nx,1)*meannz(v(i).vz,1);
                    end
                end
            else
                if findstr(opt,'0'),
                    vv(i).w=ones(nx,1)*mean(v(i).w,1);
                else
                    vv(i).w=ones(nx,1)*meannz(v(i).w,1);
                end
            end
        case 'y',
            if vecmode,
                if findstr(opt,'0'),
                    vv(i).vx=mean(v(i).vx,2)*ones(1,ny);
                    vv(i).vy=mean(v(i).vy,2)*ones(1,ny);
                    if isfield(v(i),'vz')
                        vv(i).vz=mean(v(i).vz,2)*ones(1,ny);
                    end
                else
                    vv(i).vx=meannz(v(i).vx,2)*ones(1,ny);
                    vv(i).vy=meannz(v(i).vy,2)*ones(1,ny);
                    if isfield(v(i),'vz')
                        vv(i).vz=meannz(v(i).vz,2)*ones(1,ny);
                    end
                end
            else
                if strfind(opt,'0')
                    vv(i).w=mean(v(i).w,2)*ones(1,ny);
                else
                    vv(i).w=meannz(v(i).w,2)*ones(1,ny);
                end
            end
        case 'xy',
            if vecmode
                if strfind(opt,'0')
                    vv(i).vx=ones(nx,ny)*mean(mean(v(i).vx));
                    vv(i).vy=ones(nx,ny)*mean(mean(v(i).vy));
                    if isfield(v(i),'vz')
                        vv(i).vz=ones(nx,ny)*mean(mean(v(i).vz));
                    end
                else
                    vv(i).vx=ones(nx,ny)*sum(sum(v(i).vx))/sum(sum(logical(v(i).vx~=0)));
                    vv(i).vy=ones(nx,ny)*sum(sum(v(i).vy))/sum(sum(logical(v(i).vy~=0)));
                    if isfield(v(i),'vz')
                        vv(i).vz=ones(nx,ny)*sum(sum(v(i).vz))/sum(sum(logical(v(i).vz~=0)));
                    end
                end
            else
                if strfind(opt,'0')
                    vv(i).w=ones(nx,ny)*mean(mean(v(i).w));
                else
                    vv(i).w=ones(nx,ny)*sum(sum(v(i).w))/sum(sum(logical(v(i).w~=0)));
                end
            end
        otherwise
            error('Invalid AXIS');
    end
    vv(i).history = {v(i).history{:} ['spaverf(ans, ''' opt ''')']}';
end

if nargout==0
    showf(vv);
    clear vv
end
