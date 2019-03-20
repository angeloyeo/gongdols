function df = timederivativef(f,order)
%TIMEDERIVATIVEF  Time derivative
%   DF = TIMEDERIVATIVEF(F) returns the time derivative (central finite
%   difference) of the vector/scalar fields F. The time unit is not taken
%   into account here: the resulting field DF has same unit as the input
%   field F (use OPERF('/',DF,DT) to obtain a proper time derivative).
%
%   DF = TIMEDERIVATIVEF(F, N) specifies the order:
%     N=2: (Default Value): second-order central difference, with single
%          sided differences for the 1st and last frame (similar to
%          Matlab's GRADIENT function). One has LENGTH(DF) = LENGTH(F).  
%     N=1: first-order finite difference (similar to Matlab's DIFF function).
%          One has LENGTH(DF) = LENGTH(F)-1.
%
%   Example:
%      v = loadvec('*.vc7');
%      showf(timederivativef(v));
%
%   See also SMOOTHF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.00,  Date: 2017/02/01
%   This function is part of the PIVMat Toolbox


% History:
% 2017/02/01: v1.00, first version.


if (ischar(f) || iscellstr(f) || isnumeric(f))
    f=loadvec(f);
end

comp = numcompfield(f(1));

switch order
    case 1
        df=f(1:end-1);
        for i=1:length(f)-1
            switch comp
                case 1
                    df(i).w  = f(i+1).w - f(i).w;
                case 2
                    df(i).ux = f(i+1).ux - f(i).ux;
                    df(i).uy = f(i+1).uy - f(i).uy;
                case 3
                    df(i).ux = f(i+1).ux - f(i).ux;
                    df(i).uy = f(i+1).uy - f(i).uy;
                    df(i).uz = f(i+1).uz - f(i).uz;
            end
            df(i).history = {f(i).history{:} 'timederivativef(ans,1)'}';
        end
    case 2
        df=f;
        for i=2:length(f)-1
            switch comp
                case 1
                    df(i).w  = (f(i+1).w - f(i-1).w)/2;
                case 2
                    df(i).ux = (f(i+1).ux - f(i-1).ux)/2;
                    df(i).uy = (f(i+1).uy - f(i-1).uy)/2;
                case 3
                    df(i).ux = (f(i+1).ux - f(i-1).ux)/2;
                    df(i).uy = (f(i+1).uy - f(i-1).uy)/2;
                    df(i).uz = (f(i+1).uz - f(i-1).uz)/2;
            end
            df(i).history = {f(i).history{:} 'timederivativef(ans,2)'}';     
        end
        % borders:
        switch comp
            case 1
                df(1).w = f(2).w - f(1).w;
                df(end).w = f(end).w - f(end-1).w;
            case 2
                df(1).ux = f(2).ux - f(1).ux;
                df(1).uy = f(2).uy - f(1).uy;
                df(end).ux = f(end).ux - f(end-1).ux;
                df(end).uy = f(end).uy - f(end-1).uy;
            case 3
                df(1).ux = f(2).ux - f(1).ux;
                df(1).uy = f(2).uy - f(1).uy;
                df(1).uz = f(2).uz - f(1).uz;
                df(end).ux = f(end).ux - f(end-1).ux;
                df(end).uy = f(end).uy - f(end-1).uy;
                df(end).uz = f(end).uz - f(end-1).uz;
        end       
end
