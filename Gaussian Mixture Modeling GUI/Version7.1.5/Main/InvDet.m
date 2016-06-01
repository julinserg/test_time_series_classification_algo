function [InvM, detM, RankM, InvMCrit, detMCrit]= InvDet(M)
n = size(M,1);  r=0;
eps = 2.2 * 10e-10;

if n == 1
    InvM = 1/M;
    detM = M;
    RankM = 1;
elseif n==2
    detM = M(1,1)*M(2,2) - M(1,2)*M(2,1);
    InvM = 1/detM*[M(2,2) -M(1,2); -M(2,1) M(1,1)];
    RankM = 2;
elseif n>2
    InvM                = zeros(n,n);
    B                   = M;
    A                   = zeros(n, 2*n);
    A(1:n,1:n)          = B;
    for i=1:n, A(i,i+n) = 1; end

    for k=1:n
        maxpivot=A(k,k);
        if maxpivot == 0,
            maxpivot = eps;
        end
        npivot=k;
        for i=k:n
            if maxpivot == 0,
                maxpivot = eps;
            end

            if A(i,k) == 0,
                A(i,k) = eps;
            end

            if maxpivot < abs(A(i,k))
                maxpivot = A(i,k);
                npivot=i;
            end
        end

        if npivot~=k
            for j=k:2*n
                temp       = A(npivot,j);
                A(npivot,j)= A(k,j);
                A(k,j)     = temp;
            end
            r=r+1;
        end

        for i=1:n
            if i > k
                if A(k,k) == 0
                    disp('Singular CovMatrix');
                    [ InvM, detM, RankM]= ...
                                      UseOnlyNonZeroEigValues(M,n);
                    return
                end
                D  = - A(i,k)/ A(k,k);
                for j=k:2*n
                    A(i,j) = A(i,j) + D*A(k,j) ;
                end
            end
        end
    end
          
    detM = 1;

    for k=1:n
        D = A(k,k);
        detM = detM * A(k,k);
        for j = k:2*n,
            A(k,j) = A(k,j) / D ;
        end
    end

    for k=n:-1:2
        for i=1: k-1
            D = A(i,k);
            for j=(i+1): 2*n,
                A(i,j) = A(i,j) - D*A(k,j);
            end
        end
    end

    detM = detM*(-1)^r;
    InvM(1:n, 1:n) = A(1:n, (n+1):(2*n) );
    RankM = n;
end
          
if detM < eps && n > 1
    [InvMCrit, detMCrit, RankM ]= UseOnlyNonZeroEigValues(M,n);
elseif detM > eps || n == 1
    InvMCrit = InvM;
    detMCrit = detM;
end

%------Alternative Method (to Treat Singularities) ---------------- 
function [InvM, detM, RankM ] = UseOnlyNonZeroEigValues(M,n)

[EigVec, EigVal] = eig(M);
EigVal = diag(EigVal);
IndxNonZeroEigVals = find(abs(EigVal) > 1e-4);

if isempty( IndxNonZeroEigVals)
    RankM = 0;
    InvM = zeros(n,n);
    detM = 0;
    return
end

LIndxNonZeroEigVals  = length( IndxNonZeroEigVals );
InvEigCovs = zeros(n,n);

for IndexEigVals  =  IndxNonZeroEigVals'
    InvEigCovs = InvEigCovs + ...
        1 / EigVal(IndexEigVals)  * ...
           (EigVec(:, IndexEigVals ) * EigVec(:, IndexEigVals )' );
end

detM      = prod( EigVal(   IndxNonZeroEigVals ) );
RankM     = LIndxNonZeroEigVals;
InvM      = InvEigCovs;
return
