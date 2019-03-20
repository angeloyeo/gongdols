function mi=interpolat(m,varargin)
% INTERPOLAT  Interpolates the 0 elements of a matrix
%    P = INTERPOLAT(M) interpolates the matrix M, i.e. replaces the 0
%    elements of the matrix by the average of their 4 closest nonzero
%    neighbours.
%
%    P = INTERPOLAT(M,'fill') re-iterates the interpolation until no zero
%    elements remain.
%
%    THIS FUNCTION IS KEPT FOR COMPATIBILITY. USE INTERPF INSTEAD.

%    F. Moisy
%    Revision: 1.21,  Date: 2008/04/30

%    See also FILTERF.

% History:
% 2003/02/28: v1.00, first version.
% 2005/02/02: v1.10, replace a 0 element with the average computed from the
%                    nonzero neighbours (instead of all neighbours).
% 2005/09/03: v1.11, cosmetics.
% 2005/10/14: v1.20, option 'fill' added.
% 2008/04/30: v1.21, cosmetics

% error(nargchk(1,2,nargin));

nx=size(m,1); ny=size(m,2);

mi=m;

if any(mi(:)==0)
    for i=1:nx
        for j=1:ny
            if (mi(i,j)==0)
                % elements in the corners:
                if     ((i==1)  && (j==1)),  mi(1,1)   = (m(2,1)+m(1,2))/2;
                elseif ((i==nx) && (j==1)),  mi(nx,1)  = (m(nx-1,1)+m(nx,2))/2;
                elseif ((i==1)  && (j==ny)), mi(1,ny)  = (m(2,ny)+m(1,ny-1))/2;
                elseif ((i==nx) && (j==ny)), mi(nx,ny) = (m(nx-1,ny)+m(nx,ny-1))/2;
                    % elements along the borders:
                elseif ((i==1)  && (j~=1) && (j~=ny)), mi(1,j)  = (m(1,j-1)+m(1,j+1)+m(2,j))/3;
                elseif ((i==nx) && (j~=1) && (j~=ny)), mi(nx,j) = (m(nx,j-1)+m(nx,j+1)+m(nx-1,j))/3;
                elseif ((j==1)  && (i~=1) && (i~=nx)), mi(i,1)  = (m(i-1,1)+m(i+1,1)+m(i,2))/3;
                elseif ((j==ny) && (i~=1) && (i~=nx)), mi(i,ny) = (m(i-1,ny)+m(i+1,ny)+m(i,ny-1))/3;
                    % other elements:
                else
                    %mi(i,j)=(m(i-1,j)+m(i+1,j)+m(i,j-1)+m(i,j+1))/4;
                    % computes the number of nonzero neighbours: (change 2 fev
                    % 2005):
                    nbnzne = sum( (~(m(i-1,j)==0)) + (~(m(i+1,j)==0)) + (~(m(i,j-1)==0)) + (~(m(i,j+1)==0)) );
                    if nbnzne,
                        mi(i,j) = (m(i-1,j)+m(i+1,j)+m(i,j-1)+m(i,j+1))/nbnzne;
                    end
                end
            end
        end
    end
end


if any(mi(:)==0) && any(strcmpi(varargin,'fill'))
    mi = interpolat(mi,varargin{:});
end
