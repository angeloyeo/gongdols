function cv = changefieldf(v,varargin)
%CHANGEFIELDF   Change the values of variables in a PIVMat structure
%   CV = CHANGEFIELDF(V, 'var1', value1, 'var2', value2, ...) returns a
%   PIVMat structure array CV identical to the input structure V, in which
%   the variables 'var1', 'var2' etc. receive the new specified values
%   value1, value2 etc. Variables in a PIVMat structures are labels and
%   units of x and y axis, values of x and y coordinates, etc. See LOADVEC
%   for a complete list of available variables.
%   
%   V = CHANGEFIELDF(V, 'unitx', 'm') is equivalent to V.unitx = 'm'.
%   However, if V is a structure array of vector/scalar fields, CHANGEFIELDF
%   applies the changes to each element V(i).
%
%   For instance, PIVMat structures have their axis labels named 'x'
%   and 'y' by default. In order to change these labels to 'X' and 'Z',
%   enter the following:
%
%      v = changefieldf(v,'namex','X','namey','Z');
%
%   You can also specify non-string arguments for the value1, value2...
%   For instance, in order to invert the values of the x axis,
%
%      v = changefieldf(v, 'x', v(1).x(end:-1:1));
%
%   See also  SHIFTF, EXTRACTF, RESIZEF, OPERF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.00,  Date: 2011/03/25
%   This function is part of the PIVMat Toolbox

% History:
% 2011/03/25: v1.00, first version.


%error(nargchk(1,inf,nargin));

cv = v;
nvar = nargin-1;

if mod(nvar,2)~=0 || nvar==0
    error('PIVMat:changefieldf:WrongInput','Specify pairs of variable names / values.');
end

for i=1:numel(v)
    for j=1:(nvar/2)
        cv(i).(varargin{2*j-1}) = varargin{2*j};
    end
    cv(i).history = {v(i).history{:} 'changefieldf(ans, ...)'}';
end
