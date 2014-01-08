function [A, Z] = normalizeTraps(A,X, dim)
% Make the entries of a (multidimensional) array sum to 1
% [A, z] = normalize(A) normalize the whole array, where z is the normalizing constant
% [A, z] = normalize(A, dim)
% If dim is specified, we normalize the specified dimension only.
% dim=1 means each column sums to one
% dim=2 means each row sums to one
%
%%
% Set any zeros to one before dividing.
% This is valid, since s=0 iff all A(i)=0, so
% we will get 0/1=0

% This file is from pmtk3.googlecode.com

if(nargin < 3) 

    Z = trapz(X,A,2);
    Z(Z==0) = 1;
    ZM = repmat(Z',size(A,2),1);
    A = A./ZM';
    
else
    z = sum(A, dim);
    z(z==0) = 1;
    A = bsxfun(@rdivide, A, z);
end
end
