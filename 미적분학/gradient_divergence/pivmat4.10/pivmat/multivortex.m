function v=multivortex(nfield,nsize,numvortex,varargin)
%MULTIVORTEX  Vector fields of randomly distributed Burgers vortices
%   V = MULTIVORTEX(NFIELD, NSIZE, NUMVORTEX) returns NFIELD vector fields
%   of size NSIZExNSIZE points (1 point = 1 mm), containing a set of
%   NUMVORTEX random Burgers vortices (vortices with Gaussian vorticity and
%   divergence profiles). The location, core size, vorticity and divergence
%   of each vortex is random. V is a standard PIVMat structure array, which
%   can be displayed using SHOWF.
%
%   Default parameters are NFIELD=1, NSIZE=128, NUMVORTEX=8.
%
%   Note: Vortex centers are distrubuted in an area larger than the field
%   of interest, in order to ensure statistical homogeneity. As a
%   consequence, NUMVORTEX is the *average* number of vortex per field.  
%
%   V = MULTIVORTEX(..., 'Property1','Property2') specifies additional
%   vortex properties:
%     'asym'   all vortices have positive vorticity
%     '2d'     impose zero divergence
%
%   Examples:
%     showf(multivortex(1,256,6,'asym'),'rot');
%
%     v = addnoisef(multivortex(10,128,5,'2d'));
%     showf(filterf(v),'rot','contourf',12);
%
%   See also SHOWF, VORTEX, ADDNOISEF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.01,  Date: 2013/01/09
%   This function is part of the PIVMat Toolbox


% History:
% 2013/01/08: v1.00, first version.
% 2013/01/09: v1.01, cosmetics


if ~exist('nfield','var'), nfield=1; end
if ~exist('nsize','var'), nsize=128; end
if ~exist('numvortex','var'), numvortex=8; end

% total area is 9 times larger than the area of interest:
numvortex = ceil(numvortex*9);  

for k=1:nfield
    v(k).vx = zeros(nsize,nsize);
    v(k).vy = zeros(nsize,nsize);
    
    % initialize the vortex properties (core size, vorticity, location...)
    for num = 1:numvortex
        % vortex centers are distributed inside AND outside the area to
        % improve homogeneity (here only 1/9 are inside)
         icenter(num) = 1 + nsize*(3*rand-1);
         jcenter(num) = 1 + nsize*(3*rand-1);
        
        % vorticity: bimodal Gaussian distribution, centered on +2 and -2
        omega(num) = sign(rand-0.5)*(2+randn);
        
        % divergence: Gaussian distribution, centered on 0
         if any(strcmpi(varargin,'2d'))
             div(num) = 0;
         else
            div(num) = randn/2;
         end
        % core size: Gaussian distribution, centered on NSIZE*0.06
        core(num) = 0.015*(4+randn)*nsize;
    end
    
    % Asymmetric vorticity distribution?
    if any(strcmpi(varargin,'asym'))
        omega = abs(omega);
    end
    
    % fill the velocity fields:
    for i=1:nsize
        for j=1:nsize
            for num = 1:numvortex
                radius = sqrt((i-icenter(num))^2 + (j-jcenter(num))^2);
                ampl = core(num)^2/radius^2*(1-exp(-(radius/core(num))^2)) / 1000;
                v(k).vx(i,j) = v(k).vx(i,j) + ampl * (-omega(num)*(j-jcenter(num)) + div(num)*(i-icenter(num)));
                v(k).vy(i,j) = v(k).vy(i,j) + ampl * ( omega(num)*(i-icenter(num)) + div(num)*(j-jcenter(num)));
            end
        end
    end
    
    v(k).x=(1:nsize)-1;
    v(k).y=(1:nsize)-1;
    v(k).ysign='Y axis upward';
    v(k).namex='x';
    v(k).namey='y';
    v(k).namevx='vx';
    v(k).namevy='vy';
    v(k).unitx='mm';
    v(k).unity='mm';
    v(k).unitvx='m/s';
    v(k).unitvy='m/s';
    v(k).history={'multivortex'};
    v(k).name='Multivortex';
    v(k).setname='-';
end

