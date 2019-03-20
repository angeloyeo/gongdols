function n=nam(v,siz)
%NAM  Computes the NAM (Normalized Angular Momentum) of a vector field
%   N = NAM(F,FSIZE) computes the NAM (Normalized Angular Momentum) of the
%   vector field(s) N, using size FSIZE (in mesh units)
%
%   See also  SHOWF, MEDIANF, BWFILTERF, ADDNOISEF, INTERPF,
%   GAUSSMAT, CONV2.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.01,  Date: 2013/01/09
%   This function is part of the PIVMat Toolbox


% History:
% 2009/04/01: v1.00, first version.
% 2013/06/09: v1.01, bug fixed in history field for length(v)>1


% error(nargchk(1,2,nargin));

if (ischar(v) || iscellstr(v) || isnumeric(v)),
    v = loadvec(v);
end

if nargin<2
    siz=1;
end

n=vec2scal(v,'norm');
nx=length(v(1).x);
ny=length(v(1).y);
normfactor = (2*siz+1)^2-1;

for i=1:numel(v)

    for x = (1+siz):(nx-siz)
        for y=(1+siz):(ny-siz)
            int = 0;
            for xx = -siz:siz
                for yy = -siz:siz
                    if (xx~=0 && yy~=0)
                        cont = (v(i).x(x+xx)-v(i).x(x))*v(i).vy(x+xx,y+yy) - (v(i).y(y+yy)-v(i).y(y))*v(i).vx(x+xx,y+yy);
                        normdist = sqrt((v(i).x(x+xx)-v(i).x(x))^2+(v(i).y(y+yy)-v(i).y(y))^2);
                        normvit = sqrt((v(i).vx(x+xx,y+yy))^2+(v(i).vy(x+xx,y+yy))^2);
                        int = int + cont/(normdist*normvit);
                    end
                end
            end
            n(i).w(x,y) = int / normfactor;
        end
    end
   
    n(i).history = {v(i).history{:} ['nam(ans, ' num2str(siz) ')']}';
    n(i).namew = 'NAM';
    n(i).unitw = '';

end

n=truncf(n,siz);

if nargout==0
    showf(n);
    clear n
end
