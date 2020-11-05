clc;
clear;
%% Инициализация пула потоков (задание количества потоков)
% обычно количества потоков = количеству ядер процессора
%isOpen = parpool('size') > 0;
%if ~isOpen
%   parpool open 4;
%end;

fprintf('..........START EXPERIMENT\n');
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

% fail - 'FaceDetection' 'InsectWingbeat' 'Phoneme'

% groupDATA = {'ArticularyWordRecognition' 'AtrialFibrillation' 'BasicMotions' ...
%      'CharacterTrajectories' 'Cricket' 'EigenWorms' 'Epilepsy' 'EthanolConcentration' ...
%      'ERing' 'FingerMovements' 'HandMovementDirection' 'Handwriting' 'Heartbeat' 'JapaneseVowels' ...
%      'Libras' 'LSST' 'MotorImagery' 'NATOPS' 'PenDigits' 'PEMS-SF' 'RacketSports' ...
%      'SelfRegulationSCP1' 'SelfRegulationSCP2' 'SpokenArabicDigits' ...
%      'StandWalkJump' 'UWaveGestureLibrary'};

groupDATA = {'MyRndGaussHmm' 'MyRndNoiseGaussHmm-6-5-15-50-600-0.1' ...
    'MyRndNoiseGaussHmm-6-5-5-50-600-0.1' 'MyRndNoiseGaussHmm-6-5-30-50-600-0.1' ...
    'MyRndNoiseGaussHmm-6-5-15-50-600-0.5'};
% myBestOn 7 - ArticularyWordRecognition Cricket EigenWorms JapaneseVowels UWaveGestureLibrary
% myBestOn 7 - ArticularyWordRecognition Cricket EigenWorms ERing
% JapaneseVowels MotorImagery UWaveGestureLibrary
% myBestOn 5 - ArticularyWordRecognition Cricket EigenWorms ERing
% JapaneseVowels MotorImagery
% myBestOn 3 - Cricket EigenWorms ERing JapaneseVowels MotorImagery NATOPS
% myBestOn 9 - ArticularyWordRecognition Cricket EigenWorms ERing
% JapaneseVowels MotorImagery UWaveGestureLibrary
groupMODEL = {'NPMPGM_KMEANS' 'DHMM+KMEANS' 'HMM' };
ResultCellError = cell(length(groupDATA), 3);
ResultCellOverfit = cell(length(groupDATA), 3);

nameModelIndex = 0;
for groupMODELId = 1:length(groupMODEL)
nameModelIndex = nameModelIndex + 1;
currentModel = groupMODEL{groupMODELId};
nameDataSetIndex = 0;

for groupDATAId = 1:length(groupDATA)
nameDataSetTrain = append(groupDATA{groupDATAId}, '_TRAIN.mat') ;
nameDataSetTest = append(groupDATA{groupDATAId}, '_TEST.mat') ;
nameDataSetIndex = nameDataSetIndex + 1;

dataTrainUCI = getData2020(nameDataSetTrain);
dataTest = getData2020(nameDataSetTest);
TRAINFOLDSIZE = [size(dataTrainUCI,2)];
%%
endD = 0;
index = 0;
RESUTMATRIX_TRAIN = zeros(9, size(TRAINFOLDSIZE,2));
RESULTMATRIX_TEST = zeros(9, size(TRAINFOLDSIZE,2));

for ii = 1: size(TRAINFOLDSIZE,2) 
    endD = TRAINFOLDSIZE(ii);
    dataTrain = dataTrainUCI(:,1:endD);  
    index = index + 1;
    %RESULTMATRIX_X(use,index) = endD;
    %RESULTMATRIX_X(use,index) = endD;
    %RESULTMATRIX_X(use,index) = endD;
    K_FOLD = size(dataTrainUCI,2)/endD;    
    Indices = mycrosvalid( size(dataTrainUCI,2), K_FOLD );
    K_FOLD = 1;
    for cros_iter = 1 : K_FOLD
        dataTrainCross = dataTrainUCI(:,Indices == cros_iter );        
        if (currentModel == "HMM")
            diag = 0;
            [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = hmm_main(dataTrainCross,dataTest,N_STATES,N_MIX,diag); 
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
            fprintf('Test %s Error  = %f\n', currentModel, errorT); 
            fprintf('Train %s Error  = %f\n', currentModel, errorTR);     
        end
        if (currentModel == "NPMPGM_SOM")        
            %% Инициализация параметров классификатора    
            row_map = 1; % колличество строк карты Кохонена
            col_map = N_STATES; % колличество столбцов карты Кохонена
            epohs_map = 1000; % колличество эпох обучения карты Кохонена
            val_dirichlet = 0; % параметр распределения Дирихле
            [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = npmpgm_main(dataTrainCross,dataTest,row_map,col_map,epohs_map,val_dirichlet);            
            fprintf('Test %s Error  = %f\n', currentModel, errorT);  
            fprintf('Train %s Error  = %f\n', currentModel, errorTR);            
        end
         if (currentModel == "NPMPGM_KMEANS")        
            %% Инициализация параметров классификатора    
            row_map = 1; % колличество строк карты Кохонена
            col_map = N_STATES; % колличество столбцов карты Кохонена
            epohs_map = 1000; % колличество эпох обучения карты Кохонена
            val_dirichlet = 0; % параметр распределения Дирихле
            [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = npmpgm_kmeans_main(dataTrainCross,dataTest,row_map,col_map,epohs_map,val_dirichlet);            
            fprintf('Test %s Error  = %f\n', currentModel, errorT);  
            fprintf('Train %s Error  = %f\n', currentModel, errorTR);            
         end        
        if (currentModel == "KNN")        
            [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = knn_main(dataTrainCross,dataTest); 
            fprintf('Test KNN Error  = %f\n', currentModel, errorT);
            fprintf('Train KNN Error  = %f\n', currentModel, errorTR);   
        end
        if (currentModel == "DHMM+SOM")        
            %% Инициализация параметров классификатора    
            row_map = 10; % колличество строк карты Кохонена
            col_map = 10; % колличество столбцов карты Кохонена
            epohs_map = 1000; % колличество эпох обучения карты Кохонена           
            [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = hmmsom_main(dataTrainCross,dataTest,row_map,col_map,epohs_map,N_STATES,0);            
            fprintf('Test %s Error  = %f\n', currentModel, errorT);  
            fprintf('Train %s Error  = %f\n', currentModel, errorTR);
            
        end
        if (currentModel == "DHMM+KMEANS")        
            %% Инициализация параметров классификатора    
            row_map = 10; % колличество строк карты Кохонена
            col_map = 10; % колличество столбцов карты Кохонена
            epohs_map = 1000; % колличество эпох обучения карты Кохонена           
            [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = hmmsom_main(dataTrainCross,dataTest,row_map,col_map,epohs_map,N_STATES,1);            
            fprintf('Test %s Error  = %f\n', currentModel, errorT);  
            fprintf('Train %s Error  = %f\n', currentModel, errorTR);
            
        end       
        if (currentModel == "NPMPGM_EM")        
            %% Инициализация параметров классификатора    
            row_map = 1; % колличество строк карты Кохонена
            col_map = N_STATES; % колличество столбцов карты Кохонена
            epohs_map = 1000; % колличество эпох обучения карты Кохонена
            val_dirichlet = 0; % параметр распределения Дирихле
            [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = npmpgm_em_main(dataTrainCross,dataTest,row_map,col_map,epohs_map,val_dirichlet);            
            fprintf('Test %s Error  = %f\n', currentModel, errorT);  
            fprintf('Train %s Error  = %f\n', currentModel, errorTR);            
        end
        if (currentModel == "LSTM")        
            [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = lstm_main(dataTrainCross,dataTest); 
            fprintf('Test %s Error  = %f\n', currentModel, errorT);
            fprintf('Train %s Error  = %f\n', currentModel, errorTR);   
        end
        ResultCellError(nameDataSetIndex, 1) = { groupDATA{groupDATAId}};
        ResultCellOverfit(nameDataSetIndex, 1) = { groupDATA{groupDATAId}};       
        ResultCellError(nameDataSetIndex, nameModelIndex + 1) = {num2str(errorT, 4)};       
        ResultCellOverfit(nameDataSetIndex, nameModelIndex + 1) = {num2str(errorT - errorTR, 4)};  
        %RESULTMATRIX_TRAIN(use,index) = RESULTMATRIX_TRAIN(use,index) + errorTR;   
        %RESULTMATRIX_TEST(use,index) =  RESULTMATRIX_TEST(use,index) + errorT;
    end
    %RESULTMATRIX_TRAIN(use,index) =  RESULTMATRIX_TRAIN(use,index) / K_FOLD;
    %RESULTMATRIX_TEST(use,index) =  RESULTMATRIX_TEST(use,index) / K_FOLD;
    %fprintf('Test CrossValidation Error  = %f\n', RESULTMATRIX_TEST(use,index));  
    %fprintf('Train CrossValidation Error  = %f\n', RESULTMATRIX_TRAIN(use,index));
    %save('RESULTMATRIX_TRAIN.mat', 'RESULTMATRIX_TRAIN');
    %save('RESULTMATRIX_TEST.mat', 'RESULTMATRIX_TEST');
    
end
%%
fprintf('..........STOP EXPERIMENT - %s\n', groupDATA{groupDATAId});
end
end
% Convert cell to a table and use first row as variable names
NameDataSetVar = {'NameDataSet'};
TableHeader = [ NameDataSetVar groupMODEL];
TableError = cell2table(ResultCellError, 'VariableNames',TableHeader);
TableOverfit= cell2table(ResultCellOverfit, 'VariableNames',TableHeader);
% Write the table to a CSV file
writetable(TableError,append('Result-state-', int2str(N_STATES), '-error.csv'))
writetable(TableOverfit,append('Result-state-', int2str(N_STATES), '-overfit.csv'))

fprintf('..........STOP EXPERIMENT\n');
%% PLOT
%set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');
%set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); 
%figure('Units', 'normalized', 'OuterPosition', [0 0 1 1]);
%hold on;
%plot(RESULTMATRIX_X(use,:), RESULTMATRIX_TRAIN(use,:),'r','LineWidth',3);
%plot(RESULTMATRIX_X(use,:), RESULTMATRIX_TEST(use,:),'--','Color',[.1 .4 .1],'LineWidth',3);
%axis([-inf,inf,0,1])
%legend('ERROR TRAIN','ERROR TEST', 2);
%BX=get(gca,'XTick');
%BY=get(gca,'YTick');
%xlabel('Sample Size');
%ylabel('Error');