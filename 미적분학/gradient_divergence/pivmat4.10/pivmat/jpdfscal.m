function jpdf=jpdfscal(s1,s2,nbin)
%JPDFSCAL  Joint PDF of two scalar fields
%    JPDF = JPDFSCAL(S1,S2) computes the joint PDF of the two scalar fields
%    S1 and S2.
%    JPDF = JPDFSCAL(S1,S2,BIN) specifies the number of bins over each
%    direction (101 by default).
%
%    JPDF is a structure containing the following variables
%      bin1, bin2:   bins used to compute the joint PDF for fields S1 and S2
%      hi:           matrix containing the joint PDF.
%      namew1, namew2:  name of the input scalar fields
%      unitw1, unitw2:  unit of the input scalar fields
%
%    Use JPDFSCAL_DISP to display the result.
%
%    Example:
%       jpdf = jpdfscal(vec2scal(v,'rot'),vec2scal(v,'div'));
%       jpdfscal_disp(jpdf);
%
%    See also JPDFSCAL_DISP.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.10,  Date: 2007/03/27
%   This function is part of the PIVMat Toolbox


% History:
% 2004/04/28: v1.0, first version.
% 2007/03/27: v1.1, cosmetics

% error(nargchk(2,3,nargin));

if nargin<3
    nbin = 101;   % default number of bins
end

if ~(length(s1)==length(s2))
    error('Error: the two scalar fields must have the same size.');
end

max_s1=max(max(abs([s1.w])));
max_s2=max(max(abs([s2.w])));
jpdf.bin1=linspace(-max_s1,max_s1,nbin);
jpdf.bin2=linspace(-max_s2,max_s2,nbin);
jpdf.namew1=s1(1).namew;
jpdf.namew2=s2(1).namew;
jpdf.unitw1=s1(1).unitw;
jpdf.unitw2=s2(1).unitw;

nx=size(s1(1).w,1);
ny=size(s1(1).w,2);
rg=(nbin-1)/2; % number of positive bins
jpdf.hi=zeros(nbin,nbin);
for i=1:length(s1)
    for x=1:nx
        for y=1:ny
            bin1=min([nbin max([1 1+round(rg*(1+s1(i).w(x,y)/max_s1))])]);
            bin2=min([nbin max([1 1+round(rg*(1+s2(i).w(x,y)/max_s2))])]);
            jpdf.hi(bin1, bin2) = jpdf.hi(bin1, bin2) + 1;
        end
    end
end

if nargout==0
    jpdfscal_disp(jpdf);
end
