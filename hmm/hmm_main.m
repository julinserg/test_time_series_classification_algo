function [AveragePricision, AverageRecall, F_measure, error] = hmm_main(dataTrainArabicDigit,dataTestArabicDigit,nstates,nmix)

%% about
%   классификация  с помощью HMM pmtk library
%% init

setSeed(0); 

%% train
%dataTrainArabicDigit = getTestDataOnTest(NUM);

model = hmm_train(nstates,dataTrainArabicDigit,nmix);

%calcDataForInitHCRF(model);
%[model] = hmm_train_koh(nstates,dataTrainArabicDigit);
save('modelHMM', 'model');


%% test on train data

load modelHMM;
%dataTestArabicDigit = getTestDataOnTest(NUM);
[ll] = hmm_test(dataTestArabicDigit,model);
%[ll label] = hmm_test_koh(dataTestArabicDigit,model);
arrayLL = ll';
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
[AveragePricision, AverageRecall, F_measure, error] =calculateQuality(arrayLabelDetect,arrayLabelTrue,size(label,1));

