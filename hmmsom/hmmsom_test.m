function [post] = hmmsom_test(dataTestArabicDigit,model,cellNetKox,use_k_means)
%% about
%   классификация  с помощью HCRF laybrary - тестирование

%% load test data
fprintf('..........Start test\n');

dataTest = cell(1,1);
k = 1;
if use_k_means == 0
    for i=1:size(dataTestArabicDigit,1)
        for j=1:size(dataTestArabicDigit,2)
            array = sim(cellNetKox{i},dataTestArabicDigit{i,j});           
            array = vec2ind(array);
            dataTest{k,1} = array;       
            k = k+1;
        end
    end
else
    for i=1:size(dataTestArabicDigit,1)
        for j=1:size(dataTestArabicDigit,2)
          % array = sim(cellNetKox{i},dataTrainRaw{i,j});           
          % array = vec2ind(array);
            p = dataTestArabicDigit{i,j};
            w= cellNetKox{i};       
            [S,R11] = size(w);
            [R2,Q] = size(p);
            z = zeros(S,Q);
            w = w';
            copies = zeros(1,Q);
            for ii=1:S
              z(ii,:) = sum((w(:,ii+copies)-p).^2,1);
            end
            n = -z.^0.5;
            [maxn,array] = max(n,[],1);
           dataTest{k,1} = array;
           k = k+1;
        end
    end
end
%% test
logprobFn = @hmmLogprob;
[yhat, post] = generativeClassifierPredict(logprobFn, model,dataTest);

fprintf('..........Stop test\n');
