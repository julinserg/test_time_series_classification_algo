function [arrayLL] = testModel(Probability,cellNetKox,dataTest)
index = 1;
for i = 1:size(dataTest,1)
  for j = 1:size(dataTest,2)
     p = dataTest{i,j};
    parfor m = 1:size(cellNetKox,1)
       w= cellNetKox{m}.iw{1,1};       
       [S,R11] = size(w);
       [R2,Q] = size(p);
       z = zeros(S,Q);
       w = w';
       copies = zeros(1,Q);
       for ii=1:S
         z(ii,:) = sum((w(:,ii+copies)-p).^2,1); % l2-norm
       % z(ii,:) = sum(abs(w(:,ii+copies)-p),1); % l1 -norm
       end;
       z = -z.^0.5;
      % z = -z;
       n= z;
       [maxn,rows] = max(n,[],1);
       [logB scale] = normalizeLogspace(n');
       B = exp(logB');
       pi = repmat(5,1,size(w',1));
       pi(1,rows(1,1)) = 10;
       pi = normalizeLogspace(pi);
       pi = exp(pi);
       A =  Probability{m}.A;
       logp = hmmFilter(pi, A, B);
       logp = logp + sum(scale);     
       arrayLL(index,m) = logp;          
    end;
    index = index + 1;
  end;
end;
arrayLL = arrayLL';