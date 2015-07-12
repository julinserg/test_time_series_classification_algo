clc;
clear;
fprintf('..........START TEST\n');
%%
useHMM = 1;
useHCRF = 0;
useNPMPGM = 0;
UCIDATASET = 1;
TRAINFOLDSIZE = 10;
dataTrainUCI = getTrainData(1,UCIDATASET);
dataTest = getTestData(1,UCIDATASET);
%%
endD = 0;
index = 0;
while (endD + TRAINFOLDSIZE) <= size(dataTrainUCI,2)    
    endD = endD + TRAINFOLDSIZE;
    dataTrain = dataTrainUCI(:,1:endD);  
    index = index + 1;
    if (useHMM == 1)
        nstates = 5;
        nmix = 3;
        [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = hmm_main(dataTrain,dataTest,nstates,nmix);
        RESULTMARIX_TRAIN(1,index) = errorTR;   
        RESULTMARIX_TEST(1,index) = errorT;
        fprintf('T HMM Average Precision  = %f\n', PrecisionT);
        fprintf('T HMM Average Recall  = %f\n', RecallT);
        fprintf('T HMM F-measure  = %f\n', F_mT);
        fprintf('T HMM Error  = %f\n', errorT);
        fprintf('TR HMM Average Precision  = %f\n', PrecisionTR);
        fprintf('TR HMM Average Recall  = %f\n', RecallTR);
        fprintf('TR HMM F-measure  = %f\n', F_mTR);
        fprintf('TR HMM Error  = %f\n', errorTR);
        save('RESULTMARIX_TRAIN.mat', 'RESULTMARIX_TRAIN');
        save('RESULTMARIX_TEST.mat', 'RESULTMARIX_TEST');
    end;
    if (useHCRF == 1)
        load sampleData;
        %load initDataTransHMMtoHCRF
        %paramsData.weightsPerSequence = ones(1,512);
        %paramsData.factorSeqWeights = 1;
        R{2}.params = paramsNodHCRF;
        %R{2}.params.rangeWeights = [-1,1];
        R{2}.params.nbHiddenStates = 7;
        R{2}.params.modelType = 'hcrf';
        R{2}.params.GaussianHCRF = 0;
        R{2}.params.windowRecSize = 0;
        R{2}.params.windowSize = 0;
        R{2}.params.optimizer = 'bfgs';
        R{2}.params.regFactorL2 = 1;
        R{2}.params.regFactorL1 = 0;
        % R{2}.params.initWeights = initDataTransHMMtoHCRF;
        [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = hcrf_main(dataTrain,dataTest,R);
        RESULTMARIX_TRAIN(2,index) = errorTR;  
        RESULTMARIX_TEST(2,index) = errorT;
        fprintf('T HCRF Average Precision  = %f\n', PrecisionT);
        fprintf('T HCRF Average Recall  = %f\n', RecallT);
        fprintf('T HCRF F-measure  = %f\n', F_mT);
        fprintf('T HCRF Error  = %f\n', errorT);
        fprintf('TR HCRF Average Precision  = %f\n', PrecisionTR);
        fprintf('TR HCRF Average Recall  = %f\n', RecallTR);
        fprintf('TR HCRF F-measure  = %f\n', F_mTR);
        fprintf('TR HCRF Error  = %f\n', errorTR);
        save('RESULTMARIX_TRAIN.mat', 'RESULTMARIX_TRAIN');
        save('RESULTMARIX_TEST.mat', 'RESULTMARIX_TEST');
     end;
     if (useNPMPGM == 1)
        %% Инициализация пула потоков (задание количества потоков)
        % обычно количества потоков = количеству ядер процессора
        isOpen = matlabpool('size') > 0;
        if isOpen
           matlabpool close; 
        end;
        matlabpool open local 8;
        %% Инициализация параметров классификатора    
        row_map = 10; % колличество строк карты Кохонена
        col_map = 10; % колличество столбцов карты Кохонена
        epohs_map = 100; % колличество эпох обучения карты Кохонена
        val_dirichlet = 0; % параметр распределения Дирихле
        [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = npmpgm_main(dataTrain,dataTest,row_map,col_map,epohs_map,val_dirichlet);
        RESULTMARIX_TRAIN(3,index) = errorTR;   
        RESULTMARIX_TEST(3,index) = errorT;
        fprintf('T NPMPGM Average Precision  = %f\n', PrecisionT);
        fprintf('T NPMPGM Average Recall  = %f\n', RecallT);
        fprintf('T NPMPGM F-measure  = %f\n', F_mT);
        fprintf('T NPMPGM Error  = %f\n', errorT);
        fprintf('TR NPMPGM Average Precision  = %f\n', PrecisionTR);
        fprintf('TR NPMPGM Average Recall  = %f\n', RecallTR);
        fprintf('TR NPMPGM F-measure  = %f\n', F_mTR);
        fprintf('TR NPMPGM Error  = %f\n', errorTR);
        save('RESULTMARIX_TRAIN.mat', 'RESULTMARIX_TRAIN');
        save('RESULTMARIX_TEST.mat', 'RESULTMARIX_TEST');
     end;    
end;
%%
fprintf('..........STOP TEST\n');