function [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = hcrf_main(dataTrainArabicDigit,dataTestArabicDigit,R)

%% train

hcrf_train(R,dataTrainArabicDigit);
matHCRF('saveModel','fileModel_hcrf','fileFeatureDefinition_hcrf');
%% test on test data
[PrecisionT, RecallT, F_mT, errorT] = hcrf_test_l(dataTestArabicDigit);
%% test on train data
[PrecisionTR, RecallTR, F_mTR, errorTR] = hcrf_test_l(dataTrainArabicDigit);

function [AveragePrecision, AverageRecall, F_measure, error] = hcrf_test_l(dataTest)
[ll] = hcrf_test(dataTest);
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
for i=1:size(dataTest,1)
    for j=1:size(dataTest,2)       
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
[AveragePrecision, AverageRecall, F_measure,error] =calculateQuality(arrayLabelDetect,arrayLabelTrue,size(label,1));
