function [AveragePricision, AverageRecall, F_measure, error] = hcrf_main(dataTrainArabicDigit,dataTestArabicDigit,R)

%% train

hcrf_train(R,dataTrainArabicDigit);
matHCRF('saveModel','fileModel_hcrf','fileFeatureDefinition_hcrf');
%% test prepare

[ll] = hcrf_test(dataTestArabicDigit);

% prepare test result
k = 0;
for i=1: size(ll,1)
    for j=1:size(ll,2)
        k = (i-1)*size(ll,2)+ j;
        arrayLL(:,k) = ll{i,j}(:,1);  
    end;
end;
arrayLL_old = arrayLL';
post = exp(normalizeLogspace(arrayLL_old));
arrayLL = post';

label = cell(1,1);
k = 1;
for i=1:size(dataTestArabicDigit,1)
    for j=1:size(dataTestArabicDigit,2)       
        label{i,j}(1,1) = i-1; 
        k = k+1;
    end;
end;

for i=1:size(arrayLL,2)
    [c index] = max(arrayLL(:,i));
     arrayLabelDetect(1,i) = index-1;    
end;
for i =1:size(label,1)
    for j=1:size(label,2)
     arrayLabelTrue(1,(i-1)*size(label,2)+j) = label{i,j}(1,1); 
    end;
end;
[AveragePricision, AverageRecall, F_measure,error] =calculateQuality(arrayLabelDetect,arrayLabelTrue,size(label,1));
% save('arrayLabelDetectTrainHCRF.mat','arrayLabelDetect');
% save('arrayLLTrainHCRF.mat','arrayLL');
% save('arrayLabelTrueTrainHCRF.mat','arrayLabelTrue');
