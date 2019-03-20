function [V,ratio_var_mtx] = my_lda(data1,data2)
% data1: N x 2 matrix
% data2: N x 2 matrix
% w: output vector for LDA

n1 = size(data1,1);
n2 = size(data2,1);

%% mean of data
mu1 = mean(data1);
mu2 = mean(data2);

mu = (mu1 + mu2)/2;

%% within variance

% distances of data from its mean
d1 = data1-repmat(mu1,n1,1);
d2 = data2-repmat(mu2,n2,1);

% variance of each datum
s1 = d1'*d1;
s2 = d2'*d2;

sw = s1+s2;

%% between variance
sb1 = n1*(mu1-mu)'*(mu1-mu);
sb2 = n2*(mu2-mu)'*(mu2-mu);

SB = sb1+sb2;

ratio_var_mtx= sw \ SB;

[V,D] = eig(ratio_var_mtx);

[D, eig_val_order] = sort(diag(D),'descend');  % sort eigenvalues in descending order

V = V(:,eig_val_order);

end