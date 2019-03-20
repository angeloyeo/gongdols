function ff=operf(op,f1,f2)
%OPERF  Perform operation on vector/scalar fields
%   FF = OPERF(OP,F1,F2) performs operation specified by OP on the fields
%   F1 and F2. Valid operations are '+', '-', '.*' and './'. F1 and F2 must
%   be of the same type (vector or scalar fields). If
%   LENGTH(F1)=LENGTH(F2), the operation is performed for each field. If
%   LENGTH(F2)=1, the operation is performed using the single field F2 for
%   each field F1.
%
%   FF = OPERF(OP,F,N), where N is a number, performs operation specified
%   by OP on the field F.  Valid operations are:
%      '+', '-', '*', '/' and '.^' : adds, subtracts etc. the value N
%      '>', '<', '=', '>=', '<=' : conserves only the values of the fields
%           satisfying the criterion F>N (or F<N etc.)
%      'b>', 'b<', 'b=', 'b>=', 'b<=' : binarizes the fields according to
%           the criterion F>N (or F<N etc.)
%
%   FF = OPERF(OP,F) performs the unary operation OP on field(s) F.
%   Valid operations are:
%     - '-' (inverts the field), '+' (does nothing)
%     - 'log', 'exp', 'abs', 'logabs', 'real', 'imag', 'conj', etc.
%     - any MODE operation from VEC2SCAL (e.g., OPERF('rot',V) is equivalent
%       to VEC2SCAL(V,'rot')).
%
%   OPERF(..) without output argument shows the result with SHOWF.
%
%   Examples:
%     v = loadvec('*.vc7');
%     showf(operf('-',v));
%     showf(operf('/',vec2scal(v,'rot'),2));
%
%   See also VEC2SCAL, SHOWF, AVERF, SPAVERF, SUBAVERF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.10,  Date: 2017/02/01
%   This function is part of the PIVMat Toolbox


% History:
% 2005/10/29: v1.0, first version.
% 2006/04/27: v1.01, accepts length(F2)=1 even if length(F1)>1
% 2006/07/17: v1.02, new unary operations: 'log' and 'exp'
% 2007/04/12: v1.03, bug fixes for scalar output
% 2011/06/15: v1.04, new operations: 'real' and 'imag' + others
% 2015/09/21: v1.05, bug fixed operation with scalar, thanks Nath
% 2017/02/01: v1.10, binarization added



% error(nargchk(2,3,nargin));

vm1 = isfield(f1(1),'vx');   % 1 for vector field, 0 for scalar field

if nargin==2  % unary operations:
    switch op
        case {'+','-'}
            ff = f1;
            for i=1:length(f1)
                ff(i).history = {f1(i).history{:} ['operf(''' op ''', ans)']}';
                ff(i).name=[op f1(i).name];
                if vm1
                    ff(i).vx = eval([op 'f1(i).vx']);
                    ff(i).vy = eval([op 'f1(i).vy']);
                    if isfield(f1(i),'vz')
                        ff(i).vz = eval([op 'f1(i).vz']);
                    end                        
                else
                    ff(i).w = eval([op 'f1(i).w']);
                end
            end
        case {'log','exp','abs','logabs','real','imag','conj','angle','atan2','sin','cos','tan','asin','acos','atan'} % new v1.02, modified v1.04
            ff = f1;
            for i=1:length(f1)
                ff(i).history = {f1(i).history{:} ['operf(''' op ''', ans)']}';
                ff(i).name=[op f1(i).name];
                if vm1
                    if strcmp(op,'logabs')
                        ff(i).vx = eval('log(abs(f1(i).vx))');
                        ff(i).vy = eval('log(abs(f1(i).vy))');
                        if isfield(f1(i),'vz')
                            ff(i).vz = eval('log(abs(f1(i).vz))');
                        end                            
                    else
                        ff(i).vx = eval([op '(f1(i).vx)']);
                        ff(i).vy = eval([op '(f1(i).vy)']);
                        if isfield(f1(i),'vz')
                            ff(i).vz = eval([op '(f1(i).vz)']);
                        end
                    end
                else
                    if strcmp(op,'logabs')
                        ff(i).w = eval('log(abs(f1(i).w))');
                    else
                        ff(i).w = eval([op '(f1(i).w)']);
                    end
                end
            end            
        otherwise  % 'rot', 'div' etc.
            if vm1
                ff=vec2scal(f1,op);
            else
                error('Invalid syntax for unary operations');
            end
    end

else   % binary operations:
    if isstruct(f2)   % if F2 is a field
        switch op
            case {'+','-','.*','./'}
                ff = f1;
                for i=1:length(f1)
                    f2temp = f2(min(i,length(f2))); % if F2 has only one element, use this element through the computation (new v1.01):
                    ff(i).history = {f1(i).history{:} '="ans1"' f2temp.history{:} '="ans2"' ['operf(''' op ''', ans1, ans2)']}';
                    ff(i).name=[f1(i).name op f2temp.name];
                    if vm1
                        ff(i).vx = eval(['f1(i).vx' op 'f2temp.vx']);
                        ff(i).namevx=[f1(i).namevx op f2temp.namevx];
                        ff(i).vy = eval(['f1(i).vy' op 'f2temp.vy']);
                        ff(i).namevx=[f1(i).namevy op f2temp.namevy];
                        if isfield(f1(i),'vz')
                            ff(i).vz = eval(['f1(i).vz' op 'f2temp.vz']);
                            ff(i).namevz=[f1(i).namevz op f2temp.namevz];
                        end 
                    else
                        ff(i).w = eval(['f1(i).w' op 'f2temp.w']);
                        ff(i).namew=[f1(i).namew op f2temp.namew];
                    end
                end % for i
            otherwise
                error('Invalid syntax. Valid binary operations for fields are +, -, .*, ./');
        end % switch op

    else % if F2 is a number:
        switch op
            case {'+','-','*','/','.^','b>','b<','b>=','b<=','b=','b=='}
                ff=f1;
                for i=1:length(f1)
                    ff(i).history = {f1(i).history{:} ['operf(''' op ''', ans, ' num2str(f2) ')']}';
                    ff(i).name=[f1(i).name op num2str(f2)];
                    op = strrep(op,'b','');
                    if vm1
                        ff(i).vx = eval(['f1(i).vx' op 'f2']);
                        ff(i).vy = eval(['f1(i).vy' op 'f2']);
                        if isfield(f1(i),'vz')
                            ff(i).vz = eval(['f1(i).vz' op 'f2']);
                        end
                    else
                        ff(i).w = eval(['f1(i).w' op 'f2']);
                    end
                end % for i
            case {'>','<','>=','<=','=','=='}
                ff=f1;
                for i=1:length(f1)
                    ff(i).history = {f1(i).history{:} ['operf(''' op ''', ans, ' num2str(f2) ')']}';
                    ff(i).name=[f1(i).name op num2str(f2)];
                    if vm1
                        ff(i).vx = eval(['f1(i).vx' op 'f2']).*ff(i).vx;
                        ff(i).vy = eval(['f1(i).vy' op 'f2']).*ff(i).vy;
                        if isfield(f1(i),'vz')
                            ff(i).vz = eval(['f1(i).vz' op 'f2']).*ff(i).vz;
                        end
                    else
                        ff(i).w = eval(['f1(i).w' op 'f2']).*ff(i).w;
                    end
                end % for i
            otherwise
                error('Invalid syntax. Valid operations are +, -, *, /, .^');
        end % switch op
    end
end % else nargin


if nargout==0
    showf(ff);
    clear ff
end
