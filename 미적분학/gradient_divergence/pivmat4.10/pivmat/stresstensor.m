function [t,b] = stresstensor(v)
%STRESSTENSOR  Reynolds Stress tensor
%   T = STRESSTENSOR(V) returns a 3x3 matrix T containing the 6 components
%   of the stress tensor computed from the 3-components velocity fields V
%   (if V is a 2-components velocity field, T is a 2x2 matrix only).
%
%   T is defined as:  T(i,j) = <u_i u_j>, where <.> denotes spatial and
%   ensemble average (note that the minus sign in the usual definition is
%   NOT included here). This definition assumes that the fields are
%   statistically homogeneous (use VEC2SCAL(V, 'uiuj') to obtain the
%   spatial distribution of the stress tensor for non-homogeneous fields).
%
%   Careful: this function does NOT substract the ensemble average.
%   This has to be done before calling STRESSTENSOR:
%     T = STRESSTENSOR(SUBAVERF(V,'e'));
%
%   [T,B] = STRESSTENSOR(V) also returns the deviatoric tensor B, defined
%   as B(i,j) = T(i,j)/trace(T) - delta(i,j)/C,  where delta(i,j) is the
%   Kronecker (unity) tensor and C the number of components (2 or 3).
%   For isotropic flow, all elements of B must be zero.
%
%   Properties:   
%     T is a symmetric matrix: T(i,j) = T(j,i).
%     The kinetic energy (per unit mass) is given by 2*trace(T).
%     For isotropic flow, T is proportional to the identity matrix.
%     For axisymmetric flow, T is diagonal with two identical elements.
%
%   See also VEC2SCAL, SUBAVERF, STATF.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.01,  Date: 2013/03/18
%   This function is part of the PIVMat Toolbox


% History:
% 2013/03/16: v1.00, first version.
% 2013/03/18: v1.01, cosmetics.


if isfield(v(1),'vz')
    t = zeros(3,3);
    st = statf(vec2scal(v,'uxux')); t(1,1) = st.mean;
    st = statf(vec2scal(v,'uyuy')); t(2,2) = st.mean;
    st = statf(vec2scal(v,'uzuz')); t(3,3) = st.mean;
    st = statf(vec2scal(v,'uxuy')); t(1,2) = st.mean; t(2,1) = st.mean;
    st = statf(vec2scal(v,'uxuz')); t(1,3) = st.mean; t(3,1) = st.mean;
    st = statf(vec2scal(v,'uyuz')); t(2,3) = st.mean; t(3,2) = st.mean;
    b = t/trace(t) - eye(3,3)/3;
else
    t = zeros(2,2);
    st = statf(vec2scal(v,'uxux')); t(1,1) = st.mean;
    st = statf(vec2scal(v,'uyuy')); t(2,2) = st.mean; 
    st = statf(vec2scal(v,'uxuy')); t(1,2) = st.mean; t(2,1) = st.mean;
    b = t/trace(t) - eye(2,2)/2;
end
