function Index = mycrosvalid( N, K )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
Index = ones(1,N);
FOLD_SIZE = round(N/K);
if FOLD_SIZE > 0
  ind_b = 1;
  ind_end = FOLD_SIZE;
  nf = 1;
  while  ind_end <= N
    Index(1,ind_b:ind_end) = nf;
    nf = nf + 1;
    ind_b = ind_end + 1;
    ind_end = ind_b + FOLD_SIZE - 1;
  end
  Index(1,ind_b:N) = nf - 1;
end


end

