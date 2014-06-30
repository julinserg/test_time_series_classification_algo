%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    NN Classifier with L1 distance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
%Function NNClassifier_L1(Samples_Train,Samples_Test,Labels_Train,Labels_Test)
TO calculate the accuracy of the given otesting round and obtain the
predicted labels using the nearest neighbor classifer
%%INPUT Arguments:
Samples_Train: d x no_of_training_samples matrix
Samples_Test:  d x no_of_testing_samples matrix
Labels_Train:  1 x no_of_training_samples vector including all the labels of the training samples
Labels_Test:   1 x no_of_testing_samples vector including all the labels of the testing samples
%%OUTPUT Arguments:
final_accu: the accuracy of this testing round
PreLabel:      1 x no_of_testing_samples vector including all the predicted labels of the testing samples
%}
function [PreLabel] = NNClassifier_L1(Samples_Train,Samples_Test,Labels_Train)

Train_Model = Samples_Train;
Test_Model = Samples_Test;
numTest = size(Test_Model,2);
numTrain = size(Train_Model,2);

PreLabel = [];

for test_sample_no = 1:numTest
   
    testMat = repmat(Test_Model(:,test_sample_no), 1, numTrain);
    scores_vec = cal_matrix_distance(testMat, Train_Model);

    [min_val min_idx] = min(scores_vec);
    best_label = Labels_Train(1,min_idx);
    PreLabel = [PreLabel, best_label];
end

end

function disVec=cal_matrix_distance(mat1,mat2)
%using L1 as the distance metric
%disVec = sum(abs(mat1 - mat2), 1);
disVec1 = sum((mat1 - mat2).^2, 1);
disVec = disVec1.^0.5;
%you may add other distance matric here:
%....

end
        
                
            
            
            