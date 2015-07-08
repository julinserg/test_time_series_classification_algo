function [loglikeTestArabicDigit] = hcrf_test(dataTestArabicDigit)
%% about
%   классификация арабских цифр с помощью HCRF laybrary - тестирование

%% load test data
fprintf('..........Start test\n');

loglikeTestArabicDigit = cell(1,1);
for i=1:size(dataTestArabicDigit,1)
    for j=1:size(dataTestArabicDigit,2)
        %labelTestArabicDigit{i,j} = repmat(i-1, 1, size(dataTestArabicDigit{i,j},2));
        matHCRF('setData',dataTestArabicDigit(i,j),[],int32(0));
        matHCRF('test');
        ll =matHCRF('getResults');
        loglikeTestArabicDigit(i,j) = ll;
    end;
end;
fprintf('..........Stop test\n');
