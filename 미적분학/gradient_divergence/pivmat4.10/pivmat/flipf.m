function fv=flipf(v,dir)
%FLIPF  Flip vector/scalar fields about vertical or horizontal axis.
%   FF = FLIPF(F,DIR) returns vector or scalar fields F flipped (mirrored)
%   about the vertical or the horizontal axis. DIR is:
%     'x': left-right mirror,
%     'y': top-bottom mirror,
%     'xy': both (i.e., central symmetry)
%     '': nothing.
%
%   Note that the x and y axis are unchanged.
%
%   Example:
%      v = flipf(loadvec('*.vc7'), 'y');
%      showf(v);
%
%   See also  ROTATEF, SHIFTF, EXTRACTF, TRUNCF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.10,  Date: 2013/03/13
%   This function is part of the PIVMat Toolbox


% History:
% 2011/02/05: v1.00, first version.
% 2013/03/13: v1.10, works with 3d fields

% error(nargchk(1,2,nargin));

if (ischar(v) || iscellstr(v) || isnumeric(v))
    v = loadvec(v);
end

if nargin<2,
    dir='x';
end

fv=v;

vecmode = isfield(v(1),'vx');   % 1 for vector field, 0 for scalar field

for i=1:numel(v)
    switch lower(dir)
        case 'x'
            if vecmode
                fv(i).vx = -fv(i).vx(end:-1:1,:);
                fv(i).vy =  fv(i).vy(end:-1:1,:);
                if isfield(fv(i),'vz')
                    fv(i).vz =  fv(i).vz(end:-1:1,:);
                end
                    
            else
                fv(i).w = fv(i).w(end:-1:1,:);
            end
        case 'y'
            if vecmode
                fv(i).vx =  fv(i).vx(:,end:-1:1);
                fv(i).vy = -fv(i).vy(:,end:-1:1);
                if isfield(fv(i),'vz')
                    fv(i).vz =  fv(i).vz(:,end:-1:1);
                end
            else
                fv(i).w = fv(i).w(:,end:-1:1);
            end
        case {'xy','yx'}
            if vecmode
                fv(i).vx = -fv(i).vx(end:-1:1,end:-1:1);
                fv(i).vy = -fv(i).vy(end:-1:1,end:-1:1);
                if isfield(fv(i),'vz')
                    fv(i).vz =  fv(i).vz(:,end:-1:1);
                end
            else
                fv(i).w = fv(i).w(end:-1:1,end:-1:1);
            end
        case ''
        otherwise
            error('Unknown argument for FLIPF');
    end
    
    fv(i).history = {v(i).history{:} ['flipf(ans, ''' dir ''')']}';

end

if nargout==0
    showf(fv);
    clear fv
end
