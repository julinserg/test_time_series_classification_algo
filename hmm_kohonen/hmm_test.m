function [post labelTest] = hmm_test(dataTestArabicDigit,model)
%% about
%   классификация  с помощью HCRF laybrary - тестирование

%% load test data
fprintf('..........Start test\n');

dataTest = cell(1,1);
labelTest = cell(1,1);
k = 1;
for i=1:size(dataTestArabicDigit,1)
    for j=1:size(dataTestArabicDigit,2)
        dataTest{k,1} = dataTestArabicDigit{i,j};
        labelTest{i,j}(1,1) = i-1; 
        k = k+1;
    end;
end;

%% test
logprobFn = @hmmLogprob;
[yhat, post] = generativeClassifierPredict(logprobFn, model,dataTest);

fprintf('..........Stop test\n');
