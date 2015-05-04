
clear;
clc;

%% about
%   классификация  с помощью HMM pmtk library
%% init

nstates = 7;
setSeed(0); 

NUM = 1
%% train
dataTrainArabicDigit = getTrainData(NUM);
%dataTrainArabicDigit = getTestDataOnTest(NUM);
model = hmm_train(nstates,dataTrainArabicDigit);
%calcDataForInitHCRF(model);
%[model] = hmm_train_koh(nstates,dataTrainArabicDigit);
save('modelHMM', 'model');


%% test on train data

load modelHMM;
dataTestArabicDigit = getTrainData(NUM);
%dataTestArabicDigit = getTestDataOnTest(NUM);
[ll label] = hmm_test(dataTestArabicDigit,model);
%[ll label] = hmm_test_koh(dataTestArabicDigit,model);

% prepare test result
arrayLL = ll';
k = 0;
for i=1: size(label,1)
    for j=1:size(label,2)
        k = (i-1)*size(label,2)+ j;
        arrayLabel(1,k) = label{i,j}(1,1);
        for c = 1:size(arrayLL,1)
            if (c == i)
                arrayLabel(c,k) = 1;
            else
                arrayLabel(c,k) = 0;
            end;
        end;
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
calculateQuality(arrayLabelDetect,arrayLabelTrue,size(label,1));
save('arrayLabelDetectTrainHMM.mat','arrayLabelDetect');
save('arrayLLTrainHMM.mat','arrayLL');
save('arrayLabelTrueTrainHMM.mat','arrayLabelTrue');
%% test on test data
clear('arrayLabelDetect','arrayLabelTrue','arrayLabel','arrayLL');
load modelHMM;
dataTestArabicDigit = getTestDataOnTest(NUM);
%dataTestArabicDigit = getTrainData(NUM);
[ll label] = hmm_test(dataTestArabicDigit,model);
%[ll label] = hmm_test_koh(dataTestArabicDigit,model);

% prepare test result
k = 0;
arrayLL = ll';
for i=1: size(label,1)
    for j=1:size(label,2)
        k = (i-1)*size(label,2)+ j;
        arrayLabel(1,k) = label{i,j}(1,1);
        for c = 1:size(arrayLL,1)
            if (c == i)
                arrayLabel(c,k) = 1;
            else
                arrayLabel(c,k) = 0;
            end;
        end;
    end;
end;

% считаем основной показатель качества
for i=1:size(arrayLL,2)
    [c index] = max(arrayLL(:,i));
     arrayLabelDetect(1,i) = index-1;    
end;
for i =1:size(label,1)
    for j=1:size(label,2)
     arrayLabelTrue(1,(i-1)*size(label,2)+j) = label{i,j}(1,1); 
    end;
end;
calculateQuality(arrayLabelDetect,arrayLabelTrue,size(label,1));
save('arrayLabelDetectTestHMM.mat','arrayLabelDetect');
save('arrayLLTestHMM.mat','arrayLL');
save('arrayLabelTrueTestHMM.mat','arrayLabelTrue');
