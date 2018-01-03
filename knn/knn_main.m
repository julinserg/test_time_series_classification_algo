function [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = knn_main(dataTrainArabicDigit,dataTestArabicDigit)


%% test on test data
[PrecisionT, RecallT, F_mT, errorT] = knn_test_l(dataTrainArabicDigit, dataTestArabicDigit);
PrecisionTR = 1;
RecallTR = 1;
F_mTR = 1;
errorTR = 0;

function [AveragePrecision, AverageRecall, F_measure, error] = knn_test_l( dataTrain, dataTest)
index = 1;
for k1 = 1:size(dataTest,1)
for k2 = 1:size(dataTest,2)
    for i = 1 : size(dataTrain,1)
        for j = 1 : size(dataTrain,2)
            matrixDist(i,j) = dtw_distance(dataTrain{i,j},dataTest{k1,k2});
        end
    end
    minVec = min(matrixDist');
    [min_val min_idx]  = min(minVec);
    arrayLabelDetect(index) = min_idx - 1;
    index = index + 1;
end
end

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

function dist = dtw_distance( mat1, mat2 )
dist = dtw(mat1,mat2);

