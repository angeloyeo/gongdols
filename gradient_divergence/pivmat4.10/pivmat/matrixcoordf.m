function [i,j] = matrixcoordf(f,x,y)
%MATRIXCOORDF Returns the matrix-coordinates of a point in a field
%   [i,j] = MATRIXCOORDF(F, X, Y) returns the coordinates of the closest
%   matrix element corresponding to the point (X,Y) expressed in physical
%   units, using the spatial calibration of the field F.
%
%   Attention: Different matrix indexing conventions are used in Matlab and
%   PIVMat! According to the PIVMat convention, the first index I is
%   horizontal, and the second index J is vertical.
%
%   See also SHOWF, PROBEF.

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.00,  Date: 2012/05/31
%   This function is part of the PIVMat Toolbox


% History:
% 2012/05/31: v1.00, first version.

i = find(f(1).x>x, 1);
j = find(f(1).y>y, 1);
