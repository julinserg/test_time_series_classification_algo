function [R] = hcrf_train(R,dataTrainArabicDigit)
%% about
%   классификация арабских цифр с помощью HCRF library - обучение модели

%% load train data
fprintf('..........Start train\n');

labelTrainArabicDigit = cell(1,1);

for i=1:size(dataTrainArabicDigit,1)
    for j=1:size(dataTrainArabicDigit,2)
        labelTrainArabicDigit{i,j} = repmat(i-1, 1, size(dataTrainArabicDigit{i,j},2));
    end;
end;

[R{2}.model R{2}.stats] = train(dataTrainArabicDigit, labelTrainArabicDigit, R{2}.params); 
fprintf('..........Stop train\n');
