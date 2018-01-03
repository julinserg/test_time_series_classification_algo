function [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = lstm_main(dataTrainArabicDigit,dataTestArabicDigit)

%% train
[lstm_net, miniBatchSize] = lstm_train(dataTrainArabicDigit);


save('lstm_net', 'lstm_net');

%% load model
load lstm_net;

%% test on test data
[PrecisionT, RecallT, F_mT, errorT] = lstm_test_l(dataTestArabicDigit,lstm_net, miniBatchSize);
%% test on train data
[PrecisionTR, RecallTR, F_mTR, errorTR] = lstm_test_l(dataTrainArabicDigit,lstm_net, miniBatchSize);

function [AveragePrecision, AverageRecall, F_measure, error] = lstm_test_l(dataTest,lstm_net, miniBatchSize)

[YPred] = lstm_test(dataTest,lstm_net, miniBatchSize);
arrayLabelDetect = double(YPred');
on = ones(1,size(arrayLabelDetect,2));
arrayLabelDetect = arrayLabelDetect - on;

label = cell(1,1);
k = 1;
for i=1:size(dataTest,1)
    for j=1:size(dataTest,2)       
        label{i,j}(1,1) = i-1; 
        k = k+1;
    end
end
for i =1:size(label,1)
    for j=1:size(label,2)
     arrayLabelTrue(1,(i-1)*size(label,2)+j) = label{i,j}(1,1); 
    end
end
[AveragePrecision, AverageRecall, F_measure, error] =calculateQuality(arrayLabelDetect,arrayLabelTrue,size(label,1));
