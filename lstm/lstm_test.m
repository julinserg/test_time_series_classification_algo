function [YPred] = lstm_test(dataTestArabicDigit,lstm_net, miniBatchSize)
%% about
%   классификация  с помощью HCRF laybrary - тестирование

%% load test data
fprintf('..........Start test\n');

dataTest = cell(1,1);
k = 1;
for i=1:size(dataTestArabicDigit,1)
    for j=1:size(dataTestArabicDigit,2)
        dataTest{k,1} = dataTestArabicDigit{i,j};       
        k = k+1;
    end;
end;

%% test
YPred = classify(lstm_net,dataTest);

fprintf('..........Stop test\n');
