function ff=addnoisef(f,eps,opt,nc)
%ADDNOISEF  Add noise to vector/scalar fields
%   FF = ADDNOISEF(F) adds 10% normally-distributed white noise to the
%   vector/scalar field(s) F.
%
%   FF = ADDNOISEF(F, EPS) specifies that the standard deviation of the
%   white noise is EPS times that of the field(s) F (EPS=0.1 by default).
%
%   FF = ADDNOISEF(F, EPS, OPT) specifies whether the noise is additive
%   (OPT='add', by default) or multiplicative (OPT='mul').
%
%   FF = ADDNOISEF(F, EPS, OPT, N) first filters the noise at scale N (in
%   mesh units) before adding/multiplying it to the field(s) F.
%
%   Example:
%      v = loadvec('*.vc7');
%      showf(addnoisef(v));
%
%   See also OPERF, SHOWF, RANDVEC.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.2,  Date: 2013/03/13
%   This function is part of the PIVMat Toolbox


% History:
% 2005/10/29: v1.0, first version.
% 2011/04/01: v1.1, noise is now normally-distributed (randn instead of
%                   rand)
% 2013/03/13: v1.2, works with 3d fields

%error(nargchk(1,4,nargin));

if ~exist('eps','var'), eps=0.1; end
if ~exist('opt','var'), opt='add'; end
if ~exist('nc','var'), nc=0; end
opt=lower(opt);

vecmode=isfield(f(1),'vx');   % 1 for vector field, 0 for scalar field

nx=length(f(1).x);
ny=length(f(1).y);
st=statf(f);
ff=f;

if eps~=0
    for i=1:length(f)
        if strfind(opt,'add')
            if vecmode  
                ff(i).vx = f(i).vx + aleamat(nx,ny,nc)*eps*st.std; 
                ff(i).vy = f(i).vy + aleamat(nx,ny,nc)*eps*st.std;
                if isfield(f(i),'vz')
                    ff(i).vz = f(i).vz + aleamat(nx,ny,nc)*eps*st.std;
                end                    
            else
                ff(i).w = f(i).w + aleamat(nx,ny,nc)*eps*st.std;
            end
        else
            if vecmode
                ff(i).vx = f(i).vx .*(1+aleamat(nx,ny,nc)*eps);
                ff(i).vy = f(i).vy .*(1+aleamat(nx,ny,nc)*eps);
                if isfield(f(i),'vz')
                    ff(i).vz = f(i).vz .*(1+aleamat(nx,ny,nc)*eps);
                end 
            else
                ff(i).w = f(i).w .*(1+aleamat(nx,ny,nc)*eps);
            end
        end
        ff(i).history = {f(i).history{:} ['addnoisef(ans, ' num2str(eps) ', ''' opt ''')']}';
        ff(i).name=[f(i).name '+noise'];
    end
end

if nargout==0
    showf(ff);
    clear ff
end


% this subfunction returns a random matrix of size
% nx*ny, filtered at scale nc, with a standard deviation
% normalized to unity:
function a=aleamat(nx,ny,nc)
a=randn(nx,ny);
if nc~=0
    a=conv2(a,gaussmat(nc),'same');
end


