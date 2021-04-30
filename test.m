clc;
clear;
%% ������������� ���� ������� (������� ���������� �������)
% ������ ���������� ������� = ���������� ���� ����������
%isOpen = parpool('size') > 0;
%if ~isOpen
%   parpool open 4;
%end;
fprintf('..........START EXPERIMENT - MAIN\n');
%%
N_STATES = 5;
N_MIX = 0;
%currentModel = "NPMPGM_KMEANS"; % 1-HMM 2-HCRF 3-NPMPGM_SOM 4-NPMPGM_KMEANS 5-KNN 6-DHMM+SOM 7-DHMM+KMEANS 8-NPMPGM_EM 9-LSTM

%TRAINFOLDSIZE = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 660];
%TRAINFOLDSIZE = [ 20, 30, 40, 50, 60, 70, 80];
%TRAINFOLDSIZE = [20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200];
%TRAINFOLDSIZE = [50];
%TRAINFOLDSIZE = [20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120,130,140,150,160,170,180,190,200];
%dataTrainUCI = getTrainData(1,UCIDATASET);
%dataTest = getTestData(1,UCIDATASET);
% groupDATA = {'ArticularyWordRecognition' 'AtrialFibrillation' 'BasicMotions' ...
%     'CharacterTrajectories' 'Cricket' 'EigenWorms' 'Epilepsy' ...
%     'EthanolConcentration' 'ERing' 'FaceDetection' 'FingerMovements' ...
%     'HandMovementDirection' 'Handwriting' 'Heartbeat' 'InsectWingbeat' ...
%     'JapaneseVowels' 'Libras' 'LSST' 'MotorImagery' 'NATOPS' 'PenDigits' ...
%     'PEMS-SF' 'Phoneme' 'RacketSports' 'SelfRegulationSCP1' 'SelfRegulationSCP2' ...
%     'SpokenArabicDigits' 'StandWalkJump' 'UWaveGestureLibrary' };

% fail - 'FaceDetection' 'InsectWingbeat' 'Phoneme' 'MotorImagery'

INDEX_DATASET = 1;
groupDATA = {'ArticularyWordRecognition' 'AtrialFibrillation' 'BasicMotions' ...
  'CharacterTrajectories' 'Cricket' 'EigenWorms' 'Epilepsy' 'EthanolConcentration' ...
  'ERing' 'FingerMovements' 'HandMovementDirection' 'Handwriting' 'Heartbeat' 'JapaneseVowels' ...
  'Libras' 'LSST' 'NATOPS' 'PenDigits' 'PEMS-SF' 'RacketSports' ...
  'SelfRegulationSCP1' 'SelfRegulationSCP2' 'SpokenArabicDigits' ...
  'StandWalkJump' 'UWaveGestureLibrary'};

groupDATATEST = groupDATA;

for groupDATAId = 1:length(groupDATA)
    groupDATA{groupDATAId} = append(groupDATA{groupDATAId} , '-' , num2str(INDEX_DATASET));
end

%    groupDATA = { 'SpokenArabicDigits-1'};
%    groupDATATEST = { 'SpokenArabicDigits'};
  % groupDATA = { 'HandMovementDirection'};
% myBestOn 7 - ArticularyWordRecognition Cricket EigenWorms JapaneseVowels UWaveGestureLibrary
% myBestOn 7 - ArticularyWordRecognition Cricket EigenWorms ERing
% JapaneseVowels MotorImagery UWaveGestureLibrary
% myBestOn 5 - ArticularyWordRecognition Cricket EigenWorms ERing
% JapaneseVowels MotorImagery
% myBestOn 3 - Cricket EigenWorms ERing JapaneseVowels MotorImagery NATOPS
% myBestOn 9 - ArticularyWordRecognition Cricket EigenWorms ERing
% JapaneseVowels MotorImagery UWaveGestureLibrary
groupMODEL = { 'DHMM+KMEANS' };
ResultCellAccuracy = cell(length(groupDATA), length(groupMODEL)+1);
ResultCellOverfit = cell(length(groupDATA), length(groupMODEL)+1);

TRAINFOLDSIZE  = [ 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 30, 35, 40, 45, 50];
 
% TRAINFOLDSIZE_ONE = 10;
% TRAINFOLDSIZE = [TRAINFOLDSIZE_ONE];
% if size(dataTrainUCI,2) < TRAINFOLDSIZE_ONE
%     TRAINFOLDSIZE = [size(dataTrainUCI,2)];
% end

nameModelIndex = 0;
for groupMODELId = 1:length(groupMODEL)
nameModelIndex = nameModelIndex + 1;
currentModel = groupMODEL{groupMODELId};
nameDataSetIndex = 0;

RESULTMATRIX_ACCURACY = cell(length(groupDATA), size(TRAINFOLDSIZE,2) + 1);
RESULTMATRIX_OVERFIT = cell(length(groupDATA), size(TRAINFOLDSIZE,2) + 1);
for groupDATAId = 1:length(groupDATA)
fprintf('..........START EXPERIMENT - %s - %s\n', currentModel, groupDATA{groupDATAId});

nameDataSetTrain = append(groupDATA{groupDATAId}, '_TRAIN.mat') ;
nameDataSetTest = append(groupDATATEST{groupDATAId}, '_TEST.mat') ;
nameDataSetIndex = nameDataSetIndex + 1;

dataTrainUCI = getData2020(nameDataSetTrain);
dataTest = getData2020(nameDataSetTest);


%%
endD = 0;
index = 0;

isSmallData = 0;
for ii = 1: size(TRAINFOLDSIZE,2)
    index = index + 1;
    endD = TRAINFOLDSIZE(ii);     
    if isSmallData == 0
        if endD > size(dataTrainUCI,2)
            endD = size(dataTrainUCI,2);
            isSmallData = 1;
        end
    else
        [RESULTMATRIX_ACCURACY, RESULTMATRIX_OVERFIT] = setNullToResultMatrix(RESULTMATRIX_ACCURACY, RESULTMATRIX_OVERFIT, groupDATA, ...
                    groupDATAId, nameDataSetIndex, index);
        continue;
    end
    
    dataTrain = dataTrainUCI(:,1:endD);    
    K_FOLD = size(dataTrainUCI,2)/endD;    
    Indices = mycrosvalid( size(dataTrainUCI,2), K_FOLD );
    K_FOLD = 1;
    for cros_iter = 1 : K_FOLD
        dataTrainCross = dataTrainUCI(:,Indices == cros_iter );        
        if (currentModel == "HMM")
            diag = 0;
            try
                [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = hmm_main(dataTrainCross,dataTest,N_STATES,N_MIX,diag); 
            catch
                [RESULTMATRIX_ACCURACY, RESULTMATRIX_OVERFIT] = setNullToResultMatrix(RESULTMATRIX_ACCURACY, RESULTMATRIX_OVERFIT, groupDATA, ...
                    groupDATAId, nameDataSetIndex, index);
                continue;
            end
            fprintf('Test %s Error  = %f\n', currentModel, errorT);
            fprintf('Train %s Error  = %f\n', currentModel, errorTR);   
        end
        if (currentModel == "HCRF")
            load sampleData;
            %load initDataTransHMMtoHCRF
            %paramsData.weightsPerSequence = ones(1,512);
            %paramsData.factorSeqWeights = 1;
            R{2}.params = paramsNodHCRF;
            %R{2}.params.rangeWeights = [-1,1];
            R{2}.params.nbHiddenStates = N_STATES;
            R{2}.params.modelType = 'hcrf';
            R{2}.params.GaussianHCRF = 0;
            R{2}.params.windowRecSize = 0;
            R{2}.params.windowSize = 0;
            R{2}.params.optimizer = 'bfgs';
            R{2}.params.regFactorL2 = 1;
            R{2}.params.regFactorL1 = 0;
            % R{2}.params.initWeights = initDataTransHMMtoHCRF;
            [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = hcrf_main(dataTrainCross,dataTest,R);
            fprintf('Test %s Accuracy  = %f\n', currentModel, 1 - errorT); 
            fprintf('Train %s Accuracy  = %f\n', currentModel, 1 - errorTR);     
        end
        if (currentModel == "NPMPGM_SOM")        
            %% ������������� ���������� ��������������    
            row_map = 1; % ����������� ����� ����� ��������
            col_map = N_STATES; % ����������� �������� ����� ��������
            epohs_map = 1000; % ����������� ���� �������� ����� ��������
            val_dirichlet = 0; % �������� ������������� �������
            [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = npmpgm_main(dataTrainCross,dataTest,row_map,col_map,epohs_map,val_dirichlet);            
            fprintf('Test %s Accuracy  = %f\n', currentModel, 1- errorT);  
            fprintf('Train %s Accuracy  = %f\n', currentModel, 1 - errorTR);            
        end      
         if (currentModel == "NPMPGM_KMEANS-S0")        
            %% ������������� ���������� ��������������    
            row_map = 1; % ����������� ����� ����� ��������
            col_map = N_STATES; % ����������� �������� ����� ��������
            epohs_map = 1000; % ����������� ���� �������� ����� ��������
            val_dirichlet = 0; % �������� ������������� ������� 
            isNewModel = 0;
            [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = ...
            npmpgm_kmeans_main(dataTrainCross,dataTest,row_map,col_map,epohs_map,val_dirichlet, isNewModel);            
            fprintf('Test %s Accuracy  = %f\n', currentModel, 1 - errorT);  
            fprintf('Train %s Accuracy  = %f\n', currentModel, 1 - errorTR);            
         end 
         if (currentModel == "NPMPGM_KMEANS-S1")        
            %% ������������� ���������� ��������������    
            row_map = 1; % ����������� ����� ����� ��������
            col_map = N_STATES; % ����������� �������� ����� ��������
            epohs_map = 1000; % ����������� ���� �������� ����� ��������
            val_dirichlet = 0; % �������� ������������� ������� 
            isNewModel = 1;
            [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = ...
            npmpgm_kmeans_main(dataTrainCross,dataTest,row_map,col_map,epohs_map,val_dirichlet, isNewModel);            
            fprintf('Test %s Accuracy  = %f\n', currentModel, 1 - errorT);  
            fprintf('Train %s Accuracy  = %f\n', currentModel, 1 - errorTR);            
         end 
        if (currentModel == "KNN")        
            [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = knn_main(dataTrainCross,dataTest); 
            fprintf('Test KNN Accuracy  = %f\n', currentModel, 1 - errorT);
            fprintf('Train KNN Accuracy  = %f\n', currentModel, 1 - errorTR);   
        end
        if (currentModel == "DHMM+SOM")        
            %% ������������� ���������� ��������������    
            row_map = 10; % ����������� ����� ����� ��������
            col_map = 10; % ����������� �������� ����� ��������
            epohs_map = 1000; % ����������� ���� �������� ����� ��������   
            try
                [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = hmmsom_main(dataTrainCross,dataTest,row_map,col_map,epohs_map,N_STATES,0);  
            catch
                [RESULTMATRIX_ACCURACY, RESULTMATRIX_OVERFIT] = setNullToResultMatrix(RESULTMATRIX_ACCURACY, RESULTMATRIX_OVERFIT, groupDATA, ...
                    groupDATAId, nameDataSetIndex, index);
                continue;
            end
            fprintf('Test %s Accuracy  = %f\n', currentModel, 1 - errorT);  
            fprintf('Train %s Accuracy  = %f\n', currentModel, 1 - errorTR);
            
        end
        if (currentModel == "DHMM+KMEANS")        
            %% ������������� ���������� ��������������    
            row_map = 10; % ����������� ����� ����� ��������
            col_map = 10; % ����������� �������� ����� ��������
            epohs_map = 1000; % ����������� ���� �������� ����� �������� 
            try
                [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = hmmsom_main(dataTrainCross,dataTest,row_map,col_map,epohs_map,N_STATES,1);
            catch
                [RESULTMATRIX_ACCURACY, RESULTMATRIX_OVERFIT] = setNullToResultMatrix(RESULTMATRIX_ACCURACY, RESULTMATRIX_OVERFIT, groupDATA, ...
                    groupDATAId, nameDataSetIndex, index);
                continue;
            end
            fprintf('Test %s Accuracy  = %f\n', currentModel, 1 - errorT);  
            fprintf('Train %s Accuracy  = %f\n', currentModel, 1 - errorTR);
            
        end       
        if (currentModel == "NPMPGM_EM")        
            %% ������������� ���������� ��������������    
            row_map = 1; % ����������� ����� ����� ��������
            col_map = N_STATES; % ����������� �������� ����� ��������
            epohs_map = 1000; % ����������� ���� �������� ����� ��������
            val_dirichlet = 0; % �������� ������������� �������
            try
                [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = npmpgm_em_main(dataTrainCross,dataTest,row_map,col_map,epohs_map,val_dirichlet);
            catch
                [RESULTMATRIX_ACCURACY, RESULTMATRIX_OVERFIT] = setNullToResultMatrix(RESULTMATRIX_ACCURACY, RESULTMATRIX_OVERFIT, groupDATA, ...
                    groupDATAId, nameDataSetIndex, index);
                continue;
            end
            fprintf('Test %s Accuracy  = %f\n', currentModel, 1 - errorT);  
            fprintf('Train %s Accuracy  = %f\n', currentModel, 1 - errorTR);            
        end
        if (currentModel == "LSTM")        
            [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = lstm_main(dataTrainCross,dataTest); 
            fprintf('Test %s Accuracy  = %f\n', currentModel, 1 - errorT);
            fprintf('Train %s Accuracy  = %f\n', currentModel, 1 - errorTR);   
        end
        ResultCellAccuracy(nameDataSetIndex, 1) = { groupDATA{groupDATAId}};
        ResultCellOverfit(nameDataSetIndex, 1) = { groupDATA{groupDATAId}};       
        ResultCellAccuracy(nameDataSetIndex, nameModelIndex + 1) = {num2str(1 - errorT, 4)};       
        ResultCellOverfit(nameDataSetIndex, nameModelIndex + 1) = {num2str(errorT - errorTR, 4)};  
        
        RESULTMATRIX_ACCURACY(nameDataSetIndex,1) = { groupDATA{groupDATAId}}; 
        RESULTMATRIX_OVERFIT(nameDataSetIndex, 1) = { groupDATA{groupDATAId}};  
        RESULTMATRIX_ACCURACY(nameDataSetIndex,index + 1) = {1 - errorT};   
        RESULTMATRIX_OVERFIT(nameDataSetIndex,index + 1) = {errorT - errorTR};
    end    
end
%%
fprintf('..........STOP EXPERIMENT - %s - %s\n', currentModel, groupDATA{groupDATAId});
end
end
% Convert cell to a table and use first row as variable names
NameDataSetVar = {'NameDataSet'};
TableHeader = [ NameDataSetVar groupMODEL];
TableAccuracy = cell2table(ResultCellAccuracy, 'VariableNames',TableHeader);
TableOverfit= cell2table(ResultCellOverfit, 'VariableNames',TableHeader);
% Write the table to a CSV file
writetable(TableAccuracy,append('Accuracy(dataIndex - ', int2str(INDEX_DATASET), ', state-', int2str(N_STATES), ', size -', ...
int2str(TRAINFOLDSIZE(end)), ').csv'))
writetable(TableOverfit,append('Overfit(dataIndex - ', int2str(INDEX_DATASET), ', state-', int2str(N_STATES), ', size -', ...
int2str(TRAINFOLDSIZE(end)), ').csv'))

NameArraySizeDataSet = string(TRAINFOLDSIZE);
TableHeader2 = [ NameDataSetVar NameArraySizeDataSet];
TableAccuracySeq = cell2table(RESULTMATRIX_ACCURACY, 'VariableNames',TableHeader2);
TableOverfitSeq= cell2table(RESULTMATRIX_OVERFIT, 'VariableNames',TableHeader2);
strModelName = groupMODEL{size(groupMODEL)};
writetable(TableAccuracySeq,append('AccuracySeq(model - ', ...
strModelName ,', state-', int2str(N_STATES), ', dataIndex-', int2str(INDEX_DATASET), ').csv'))
writetable(TableOverfitSeq,append('OverfitSeq(model - ', ...
strModelName ,', state-', int2str(N_STATES), ', dataIndex-', int2str(INDEX_DATASET), ').csv'))

fprintf('..........STOP EXPERIMENT - MAIN\n');

function [RESULTMATRIX_ACCURACY, RESULTMATRIX_OVERFIT] = setNullToResultMatrix(RESULTMATRIX_ACCURACY, RESULTMATRIX_OVERFIT, groupDATA, ...
groupDATAId, nameDataSetIndex, index)
    RESULTMATRIX_ACCURACY(nameDataSetIndex,1) = { groupDATA{groupDATAId}}; 
    RESULTMATRIX_OVERFIT(nameDataSetIndex, 1) = { groupDATA{groupDATAId}};
    RESULTMATRIX_ACCURACY(nameDataSetIndex,index + 1) = {0};   
    RESULTMATRIX_OVERFIT(nameDataSetIndex,index + 1) = {0};
end