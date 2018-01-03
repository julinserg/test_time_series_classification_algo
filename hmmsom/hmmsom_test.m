function [post] = hmmsom_test(dataTestArabicDigit,model,cellNetKox)
%% about
%   классификация  с помощью HCRF laybrary - тестирование

%% load test data
fprintf('..........Start test\n');

dataTest = cell(1,1);
k = 1;
for i=1:size(dataTestArabicDigit,1)
    for j=1:size(dataTestArabicDigit,2)
        array = sim(cellNetKox{i},dataTestArabicDigit{i,j});           
        array = vec2ind(array);
        dataTest{k,1} = array;       
        k = k+1;
    end
end
%% test
logprobFn = @hmmLogprob;
[yhat, post] = generativeClassifierPredict(logprobFn, model,dataTest);

fprintf('..........Stop test\n');
