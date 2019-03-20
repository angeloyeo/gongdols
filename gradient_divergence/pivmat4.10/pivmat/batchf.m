function res=batchf(varargin)
%BATCHF  Execute PIVMat functions over a series of files
%   RES = BATCHF(FILENAME,FUN) executes the function FUN for each file
%   matching FILENAME. Wildcards (*) and brackets ([]) may be used (see
%   RDIR). This is formally equivalent to calling the function FUN
%   with the argument LOADVEC(FILENAME), except that the fields are not
%   stored into memory, but are processed from disk one by one by the
%   function FUN. This is useful for handling a large number of files
%   which cannot be stored into a structure array for lack of memory. All
%   the file formats supported by LOADVEC are also supported by BATCHF.
%   The result RES is an array whose elements are the output of the
%   function FUN applied to each file matching FILENAME.
%
%   RES = BATCHF(FILENAME,FUN,ARG) also passes the argument(s) ARG to
%   the function FUN. This is formally equivalent as FUN(LOADVEC(...),ARG)
%   (this works only for simple arguments, as strings and numbers, not for 
%   arrays and cell arrays).
%
%   RES = BATCHF(..., 'nodisp') does not display the function call for
%   each file matching FILENAME in the command window.
%
%   Examples:
%
%      st=batchf('set*/B00001.VEC','statf') calls the function STATF for
%      each file B00001.VEC in each directory matching 'set*'.
%
%      batchf('set*/B*.VEC','showf','rot',8) is equivalent to
%      SHOWF(LOADVEC('set*/B*.VEC'),'rot',8), except that the files are
%      not stored in a structure array.
%
%   If the function FUN to be executed is more complex, you may create a
%   M-File called 'myfunction.m', that contains the complex computation to
%   be executed for each field V, and to execute RES = 
%   BATCHF(FILENAME,'myfunction').
%
%   Example: Create the following M-File called 'enstrophy.m':
%        function z = enstrophy(v),
%        stat = statf(vec2scal(filterf(v,1),'rot'));
%        z = stat.rms^2;
%   Then call:
%        z = batchf('set*/*.vc7','enstrophy');
%
%   See also LOADVEC, LOADARRAYVEC, RDIR.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.10,  Date: 2007/11/15
%   This function is part of the PIVMat Toolbox


% History:
% 2005/10/29: v1.00, first version.
% 2007/04/05: v1.01, new option 'nodisp'
% 2007/11/15: v1.10, just renamed 'batchf'

%error(nargchk(2,inf,nargin));

filename=rdir(varargin{1});

if ~isempty(filename)
    for i=1:length(filename),
        if exist(filename{i},'file')
            callstr=[varargin{2} '(loadvec(''' filename{i} ''')'];
            for j=3:nargin,
                if ischar(varargin{j}),
                    callstr=[callstr ',''' varargin{j} ''''];
                else
                    callstr=[callstr ',' num2str(varargin{j})];
                end
            end
            callstr=[callstr ')'];
            if nargout==0,
                if ~any(strncmpi(varargin,'nodisp',3)) %new v1.01
                    disp(callstr);
                end
                eval(callstr);
            else
                disp(['varargout(' num2str(i) ') = ' callstr]);
                res(i)=eval(callstr);
            end
        else
            error([filename{i} ' not found.']);
        end
    end
else
    error('No file match.');
end
