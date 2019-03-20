function s = vec2scal(v,mode,opt)
%VEC2SCAL  Compute scalar fields from vector fields
%   S = VEC2SCAL(V,MODE) returns scalar field(s) S computed from the vector
%   field(s) V according to the specified MODE. The resulting scalar
%   field(s) S can be displayed using SHOWF. Available scalar modes are:
%
%      norm2d          2D norm (ux^2+uy^2)^(1/2)
%      norm3d          3D norm (ux^2+uy^2+uz^2)^(1/2)
%      norm            applies norm2d or norm3d, depending on the field
%      ux, uy, uz      x, y or z component of the vector field
%      en, ken         kinetic energy, norm^2 / 2  (where norm is 2D or 3D)
%      curl (or rot)   curl (z-component of vorticity field)
%      absrot          absolute value of the curl
%      div             2D divergence (dux/dx + duy/dy)
%      ens             enstrophy (=square of z-vorticity / 2)
%      rad, deg        velocity angle (tan(angle)=vy/vx), in rad or deg
%      strain          norm of the strain rate, sqrt(s1^2 + s2^2),
%                      where s1 and s2 are the 2D strain eigenvalues.
%      q               Q-criterion, Q = (enstrophy - strain^2)/2
%      eps2D           2D squared strain rate  (epsilon/nu)
%      eps3D           3D squared strain rate (only 6 components)
%      epsaxi          axisymmetric (w.r.t. y-axis) squared strain rate 
%      duidxj          spatial derivatives  (du_i / dx_j), with i=x,y,z
%                      and j=x,y (for instance, duzdy)
%      uiuj (or tij)   Components of the Reynolds stress tensor u_i*u_j,
%                      with i,j=x,y,z  (for instance, uxuy, uyuz, 
%                      or txy, tyz, etc.)
%                      (Careful: the average is NOT subtracted)
%      smin            minimum eigenvalue
%      real, imag      extracts the real part or the imaginary part
%
%   If input argument MODE is ommitted, 'norm' (for a 2D field) or 'uz'
%   (for a 3D field) is taken by default.
%
%   Adding '-' (minus sign) before MODE (e.g., '-rot') inverts the result.
%
%   The resulting scalar field S contains the following fields:
%      x,y:                 vectors containing the X and Y coordinates
%      w:                   matrix containing the scalar field
%      namex, unitx, namey, unity: strings for the name and unit of coord
%      namew, unitw:        strings for the name and unit of the matrix w
%      name:                name of the VEC file from which originates V
%      setname:             name of the current directory
%      history:             Remind from which command S has been obtained
%
%   The scalar fields built from derivatives (e.g., rot, div, ens etc.)
%   are computed from 2nd-order centered differences.
%
%   S = VEC2SCAL(FILE) is a shortcut for S = VEC2SCAL(LOADVEC(FILE)).
%
%   By default, vectors with a zero component are considered as erroneous,
%   and are not used for the computation of the derivative fields (rot,
%   div, eps, duxdx, ...). If however you want to keep them in the
%   computation, specify  VEC2SCAL(V,MODE,'keepzero').
%
%   VEC2SCAL(...), without output argument, shows the result with SHOWF.
%
%   Examples:
%     showf(vec2scal(v,'div'));
%     showf(vec2scal(filterf('*.vc7',2),'rot'));
%     stat_rot = statf(vec2scal(v,'rot'));
%     vec2scal *.vc7 ken
%
%   See also SHOWF, GRADIENTF, OPERF, CONVERT3DTO2DF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 3.02,  Date: 2015/12/08
%   This function is part of the PIVMat Toolbox


% History:
% 2004/03/01: v1.00, first version.
% 2005/05/25: v1.01, bug fixed with "curl" = 1/2 vorticity
% 2004/06/21: v1.02, added computation of epsilon (energy dissipation)
% 2004/06/22: v1.10, added computation of du_i/dx_j and strain, redefined
%                    curl and divergence, defined new axis x and y.
% 2004/06/30: v1.11, added help text.
% 2005/02/07: v1.12, propagates the 'name' and 'setname' fields
% 2005/02/09: v1.13, bug corrected about 'name' and 'setname'
% 2005/02/22: v1.14, cosmetics
% 2005/03/30: v1.15, change the vorticity sign for the Coriolis experiment
% 2005/05/28: v1.16, propagates the 'history' field
% 2005/06/06: v1.17, replaced the option 'cor' by 'norm'.
% 2005/09/01: v1.18, check arg added.
% 2005/09/15: v1.19, global variable 'manip' suppressed. Label for
%                    normalized fields changed.
% 2005/10/12: v1.20, error for unknown mode added.
% 2005/10/13: v1.21, now accepts filenames.
% 2005/10/19: v1.30, option 'normalisation' suppressed. help text changed.
% 2005/10/21: v1.40, bug Y-axis up/down-ward fixed. Modes with '-' added.
%                    Now uses the axis units to determine the scalar units.
% 2005/10/29: v1.41, displays the result if no output argument.
% 2005/11/18: v1.42, option 'angle' added
% 2006/03/03: v1.43, all fields are propagated, whatever they are.
% 2006/04/28: v1.44, bug fixed with mode=strain
% 2006/05/19: v1.50, vectors with a zero component not used for derivative
%                    fields (cf. option 'keepzero')
% 2006/05/26: v1.51, Q criterion added.
% 2006/10/31: v2.00, derivatives now computed from 2nd order centered
%                    differences.
% 2007/07/13: v2.01, new option 'smin'
% 2007/07/27: v2.02, new option 'lups'
% 2008/10/08: v2.10, now use zerotonanfield, to handle properly missing
%                    data (NaNs).
% 2008/10/16: v2.11, do not use NaNs for LUPS
% 2008/10/22: v2.12, idem for SMIN
% 2009/03/11: v2.13, definition of enstrophy now includes factor 1/2.
%                    definition of Q is now correct
% 2009/12/11: v2.14, new scalar conversion added: Reynolds stress tensor
% 2011/05/16: v2.15, take the absolute value for energy (ok for
%                    complex-valued fields)
% 2013/01/08: v2.16, field names changed (omega, epsilon etc).
% 2013/02/22: v3.00, works with 3D fields
% 2015/08/27, v3.01, added eps2D, eps3d, epsaxi
% 2015/12/08, v3.02, bug fixed for 'strain'

% error(nargchk(1,3,nargin));

if (ischar(v) || iscellstr(v) || isnumeric(v)),
    v=loadvec(v);
end % changed v1.21

if nargin<2,
    mode='norm';
end

if nargin<3, % new v1.44
    opt='nonzero';
end

if ~strcmp(opt,'keepzero') && ~strcmp(mode,'lups') && ~strcmp(mode,'smin')
    v=zerotonanfield(v);  % convert zeros to NaNs (new v2.11-2.12)
end

% new v1.43: s is idem as v, except for those fields which are removed:
s = rmfield(v, {'vx', 'vy', 'unitvx', 'unitvy','namevx','namevy'});
if isfield(v, 'vz')
    s=rmfield(s,{'vz','unitvz','namevz'});
end

for i=1:numel(v)
    % new v1.40:
    nx=length(v(i).x);
    ny=length(v(i).y);

    scalex=abs(v(i).x(2)-v(i).x(1));
    scaley=abs(v(i).y(2)-v(i).y(1));
    
    % determines the time scale factor for quantities in s^-1 or s^-2
    if strcmp(v(i).unitx,'mm') && strcmp(v(i).unitvx,'m/s')
        timeunit='s';  timescale=1e3; % in seconds
    elseif strcmp(v(i).unitx,'m') && strcmp(v(i).unitvx,'m/s')
        timeunit='s';  timescale=1;
    elseif strcmp(v(i).unitx,'mm') && strcmp(v(i).unitvx,'mm/s')
        timeunit='s';  timescale=1;
    elseif strcmp(v(i).unitx,'m') && strcmp(v(i).unitvx,'mm/s')
        timeunit='s';  timescale=1e-3;
    else
        timeunit=['(' v(i).unitx '/(' v(i).unitvx '))'];  timescale=1; % unknown units
    end

    switch strtok(lower(mode),'+-'), % removes +- sign from mode
        case {'ux','vx','u'},
            s(i).w=v(i).vx;
            s(i).unitw=v(i).unitvx;
            s(i).namew=v(i).namevx;
            
        case {'uy','vy','v'},
            s(i).w=v(i).vy;
            s(i).unitw=v(i).unitvy;
            s(i).namew=v(i).namevy;
            
        case {'uz','vz','w'};
            s(i).w=v(i).vz;
            s(i).unitw=v(i).unitvz;
            s(i).namew=v(i).namevz;
            
        case {'txx','uxux','ux2','tauxx'}, 
            s(i).w=v(i).vx.^2;
            s(i).unitw=['(' v(i).unitvx ')^2'];
            s(i).namew=[v(i).namevx '^2'];
            
        case {'tyy','uyuy','uy2','tauyy'},
            s(i).w=v(i).vy.^2;
            s(i).unitw=['(' v(i).unitvy ')^2'];
            s(i).namew=[v(i).namevy '^2'];
        
        case {'tzz','uzuz','uz2','tauzz'},
            s(i).w=v(i).vz.^2;
            s(i).unitw=['(' v(i).unitvz ')^2'];
            s(i).namew=[v(i).namevz '^2'];
            
        case {'txy','uxuy','tauxy','tyx','uyux','tauyx'},
            s(i).w=v(i).vx.*v(i).vy;
            s(i).unitw=['(' v(i).unitvx ')^2'];
            s(i).namew=[v(i).namevx ' ' v(i).namevy];
        
        case {'txz','uxuz','tauxz','tzx','uzux','tauzx'},
            s(i).w=v(i).vx.*v(i).vz;
            s(i).unitw=['(' v(i).unitvx ')^2'];
            s(i).namew=[v(i).namevx ' ' v(i).namevz];
            
        case {'tyz','uyuz','tauyz','tzy','uzuy','tauzy'},
            s(i).w=v(i).vy.*v(i).vz;
            s(i).unitw=['(' v(i).unitvx ')^2'];
            s(i).namew=[v(i).namevy ' ' v(i).namevz];
            
        case 'norm3d'    
            s(i).w = sqrt(abs(v(i).vx).^2+abs(v(i).vy).^2+abs(v(i).vz).^2); % new v3.00
            s(i).namew = ['[ (' v(i).namevx ')^2 + (' v(i).namevy ')^2 + (' v(i).namevz ')^2 ]^{1/2}'];
            s(i).unitw=v(i).unitvx;
        
        case 'norm2d'    
            s(i).w = sqrt(abs(v(i).vx).^2+abs(v(i).vy).^2); % changed v2.15
            s(i).namew = ['[ (' v(i).namevx ')^2 + (' v(i).namevy ')^2 ]^{1/2}'];
            s(i).unitw=v(i).unitvx;
           
        case 'norm'
            if isfield(v(i),'vz')
                s(i).w = sqrt(abs(v(i).vx).^2+abs(v(i).vy).^2+abs(v(i).vz).^2); % new v3.00
                s(i).namew = ['[ (' v(i).namevx ')^2 + (' v(i).namevy ')^2 + (' v(i).namevz ')^2 ]^{1/2}'];
            else
                s(i).w = sqrt(abs(v(i).vx).^2+abs(v(i).vy).^2); % changed v2.15
                s(i).namew = ['[ (' v(i).namevx ')^2 + (' v(i).namevy ')^2 ]^{1/2}'];
            end
            s(i).unitw=v(i).unitvx;
            
        case {'en','ken','energy'},
            if isfield(v(i),'vz')
                s(i).w = (abs(v(i).vx).^2+abs(v(i).vy).^2+abs(v(i).vz).^2)/2;  % changed v2.15
            else
                s(i).w = (abs(v(i).vx).^2+abs(v(i).vy).^2)/2;  % changed v2.15
            end
            s(i).unitw=['(' v(i).unitvx ')^2'];
            s(i).namew='E';
            
        case {'angle','rad'}, % new v1.42
            if strcmp(s(i).ysign,'Y axis downward'),
                s(i).w = mod(atan2(-v(i).vy,v(i).vx),2*pi);
            else
                s(i).w = mod(atan2(v(i).vy,v(i).vx),2*pi);
            end
            s(i).unitw='rad';
            s(i).namew='velocity angle';
            
        case 'deg' 
            if strcmp(s(i).ysign,'Y axis downward'),
                s(i).w = mod(atan2(-v(i).vy,v(i).vx),2*pi)*180/pi;
            else
                s(i).w = mod(atan2(v(i).vy,v(i).vx),2*pi)*180/pi;
            end
            s(i).unitw='deg';
            s(i).namew='velocity angle';

        
        % ---------- Scalar conversion involving gradients ----------- %
          
        
        case {'curl','rot'}, % new method (v>=2): 2nd order difference, using Matlab's CURL function
            [mx,my]=meshgrid(v(i).x,v(i).y);
            s(i).w = 2*curl(mx, my, v(i).vx', v(i).vy')'*timescale;
            if strcmp(s(i).ysign,'Y axis downward'),
                s(i).w = -s(i).w;   % (xyz) is indirect 
            end
            s(i).namew='\omega';
            s(i).unitw=[timeunit '^{-1}'];
            
            
        case {'abscurl','absrot'},
            ma=vec2scal(v(i),'rot');
            s(i).w = abs(ma.w);
            s(i).unitw=[timeunit '^{-1}'];
            s(i).namew='|\omega|';
            
            
        case 'div' % new method (v>=2): uses Matlab's DIVERGENCE function
            [mx,my]=meshgrid(v(i).x,v(i).y);
            s(i).w = divergence(mx,my,v(i).vx',v(i).vy')'*timescale;
            s(i).namew='Div';
            s(i).unitw=[timeunit '^{-1}'];
           
            
        case {'z','ens','enstrophy'},
            ma=vec2scal(v(i),'rot');
            s(i).w = ma.w.^2 / 2;  % definition modified v2.13
            s(i).unitw=[timeunit '^{-2}'];
            s(i).namew='Z';
            
        case {'q'},
            mens=vec2scal(v(i),'ens');
            meps=vec2scal(v(i),'eps');
            s(i).w = (mens.w - meps.w)/2;
            s(i).unitw=[timeunit '^{-2}'];
            s(i).namew='Q';
            
            
       case {'duxdx','dvxdx','uxx','vxx'}
            s(i).w = gradient(v(i).vx',scalex,scaley)'*timescale;
            s(i).unitw='s^{-1}';
            s(i).namew='du_x/dx';
            
            
        case {'duydx','dvydx','uyx','vyx'}
            s(i).w = gradient(v(i).vy',scalex,scaley)'*timescale;
            s(i).unitw=[timeunit '^{-1}'];
            s(i).namew='du_y/dx';
            
            
        case {'duxdy','dvxdy','uxy','vxy'}
            s(i).w = gradient(v(i).vx,scaley,scalex)*timescale;
            s(i).unitw=[timeunit '^{-1}'];
            s(i).namew='du_x/dy';
            
                    
        case {'duydy','dvydy','uyy','vyy'}
            s(i).w = gradient(v(i).vy,scaley,scalex)*timescale;
            s(i).unitw=[timeunit '^{-1}'];
            s(i).namew='du_y/dy';
 
        case {'duzdx','dvzdx','uzx','vzx'}
            s(i).w = gradient(v(i).vz',scalex,scaley)'*timescale;
            s(i).unitw=[timeunit '^{-1}'];
            s(i).namew='du_z/dx';
            
        case {'duzdy','dvzdy','uzy','vzy'}
            s(i).w = gradient(v(i).vz,scaley,scalex)*timescale;
            s(i).unitw=[timeunit '^{-1}'];
            s(i).namew='du_z/dy'; 
            
            
        case {'eps2d','epsilon'}
            % computes the 4 velocity derivatives (in s^-1):
            duxdx = gradient(v(i).vx',scalex,scaley)'*timescale;
            duydx = gradient(v(i).vy',scalex,scaley)'*timescale;
            duxdy = gradient(v(i).vx,scaley,scalex)*timescale;
            duydy = gradient(v(i).vy,scaley,scalex)*timescale;
            s(i).w = duxdx.^2 + duydy.^2 + ((duxdy+duydx).^2)/2;
            s(i).unitw=[timeunit '^{-2}'];
            s(i).namew='\epsilon_{2D}';
            
        case {'eps3d'}
            % computes the 6 velocity derivatives (in s^-1):
            duxdx = gradient(v(i).vx',scalex,scaley)'*timescale;
            duydx = gradient(v(i).vy',scalex,scaley)'*timescale;
            duxdy = gradient(v(i).vx,scaley,scalex)*timescale;
            duydy = gradient(v(i).vy,scaley,scalex)*timescale;
            duzdx = gradient(v(i).vz',scalex,scaley)'*timescale;
            duzdy = gradient(v(i).vz,scaley,scalex)*timescale;
            s(i).w = duxdx.^2 + duydx.^2 + duzdx.^2 ...
                + duxdy.^2 +duydy.^2 + duzdy.^2;
            s(i).unitw=[timeunit '^{-2}'];
            s(i).namew='\epsilon_{3D}';
        
        case {'epsaxi'}
            % computes the 6 velocity derivatives (in s^-1):
            duxdx = gradient(v(i).vx',scalex,scaley)'*timescale;
            duydx = gradient(v(i).vy',scalex,scaley)'*timescale;
            duxdy = gradient(v(i).vx,scaley,scalex)*timescale;
            duydy = gradient(v(i).vy,scaley,scalex)*timescale;
            duzdx = gradient(v(i).vz',scalex,scaley)'*timescale;
            duzdy = gradient(v(i).vz,scaley,scalex)*timescale;
            s(i).w = 2*duxdx.^2 + 2*duydx.^2 + 2*duzdx.^2 ...
                + duxdy.^2 +duydy.^2 + duzdy.^2;
            s(i).unitw=[timeunit '^{-2}'];
            s(i).namew='\epsilon_{axi}';
            
        case {'smin'}
            % computes the minimum principal strain (new v2.01)
            duxdx = gradient(v(i).vx',scalex,scaley)'*timescale;
            duydx = gradient(v(i).vy',scalex,scaley)'*timescale;
            duxdy = gradient(v(i).vx,scaley,scalex)*timescale;
            duydy = gradient(v(i).vy,scaley,scalex)*timescale;
            for x=1:size(duxdx,1)
                for y=1:size(duxdx,2)
                    s(i).w(x,y) = min(real(eig([duxdx(x,y), duydx(x,y) ; duxdy(x,y), duydy(x,y)])));
                end
            end
            s(i).unitw=[timeunit '^{-1}'];
            s(i).namew='s_{min}';
            
        case {'lups'}
            % computes the largest unsigned principal strain (new v2.02)
            duxdx = gradient(v(i).vx',scalex,scaley)'*timescale;
            duydx = gradient(v(i).vy',scalex,scaley)'*timescale;
            duxdy = gradient(v(i).vx,scaley,scalex)*timescale;
            duydy = gradient(v(i).vy,scaley,scalex)*timescale;
            for x=1:size(duxdx,1)
                for y=1:size(duxdx,2)
                    s(i).w(x,y) = max(abs(eig([duxdx(x,y), duydx(x,y) ; duxdy(x,y), duydy(x,y)])));
                end
            end
            s(i).unitw=[timeunit '^{-1}'];
            s(i).namew='LUPS';
        
            
        case 'strain'
            ma=vec2scal(v(i),'eps2D');
            s(i).w = sqrt(ma.w);
            s(i).unitw=[timeunit '^{-1}'];
            s(i).namew='s';
            
        otherwise,
            error('PIVMAT:vec2scal:unknownScalarConversion',...
                ['Unknown scalar conversion mode ''' mode '''']);
    end
    
    %new v1.31
    if strfind(mode,'-'),
        s(i).w = -s(i).w;
        s(i).namew=['-' s(i).namew];
    end
    
    % computes the new axis:
    % (shifts half a cell if the resulting scalar field size is one cell
    % smaller than the initial vector field size)
    s(i).x = v(i).x(1:size(s(i).w,1))+(nx-size(s(i).w,1))*abs(v(i).x(2)-v(i).x(1))/2;
    s(i).y = v(i).y(1:size(s(i).w,2))+(ny-size(s(i).w,2))*abs(v(i).y(2)-v(i).y(1))/2;
    
    s(i).namex=v(i).namex;
    s(i).namey=v(i).namey;
    s(i).unitx=v(i).unitx;
    s(i).unity=v(i).unity;

    % added FM 28/04/2005: propagates field 'history'
    s(i).history = {v(i).history{:} ['vec2scal(ans, ''' mode ''', ''' opt ''')']}';
end

if ~strcmp(opt,'keepzero')
    s=nantozerofield(s);  % convert back NaNs to zeros (new v2.10)
end

%new v1.41:
if nargout==0
    showf(s);
    clear s
end
