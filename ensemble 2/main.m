clear;
clc;
% one test - HMM
load arrayLabelDetectTestHMM.mat
test_arrayLabelDetectOne = arrayLabelDetect;
load arrayLLTestHMM.mat
test_arrayLLOne = arrayLL;
load arrayLabelTrueTestHMM.mat
test_arrayLabelTrue = arrayLabelTrue;
%one train -HMM
load arrayLabelDetectTrainHMM.mat
train_arrayLabelDetectOne = arrayLabelDetect;
load arrayLLTrainHMM.mat
train_arrayLLOne = arrayLL;
load arrayLabelTrueTrainHMM.mat
train_arrayLabelTrue = arrayLabelTrue;

%two test - HCRF
load arrayLabelDetectTestHCRF.mat
test_arrayLabelDetectTwo = arrayLabelDetect;
load arrayLLTestHCRF.mat
test_arrayLLTwo = arrayLL;
load arrayLabelTrueTestHMM.mat
test_arrayLabelTrue = arrayLabelTrue;
%two train - HCRF
load arrayLabelDetectTrainHCRF.mat
train_arrayLabelDetectTwo = arrayLabelDetect;
load arrayLLTrainHCRF.mat
train_arrayLLTwo = arrayLL;
load arrayLabelTrueTrainHMM.mat
train_arrayLabelTrue = arrayLabelTrue;

% %two test - Spectr
% load arrayLabelDetectTestSP.mat
% test_arrayLabelDetectTwo = arrayLabelDetectLaplas;
% load arrayLLTestSP.mat
% test_arrayLLTwo = arrayLLFldVec;
% %two train - Spectr
% load arrayLabelDetectTrainSP.mat
% train_arrayLabelDetectTwo = arrayLabelDetectLaplas;
% load arrayLLTrainSP.mat
% train_arrayLLTwo = arrayLLFldVec;

ensembleFun( test_arrayLabelDetectOne,test_arrayLLOne,test_arrayLabelDetectTwo,test_arrayLLTwo,test_arrayLabelTrue,train_arrayLabelDetectOne,train_arrayLLOne,train_arrayLabelDetectTwo,train_arrayLLTwo,train_arrayLabelTrue )