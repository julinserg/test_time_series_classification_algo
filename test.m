clc;
clear;
% HCRF Average Pricision  = 0.605227
% HCRF Average Recall  = 0.560000
% HCRF F-measure  = 0.581736
% HCRF Error  = 0.440000
% HMM Average Pricision  = 0.633036
% HMM Average Recall  = 0.590000
% HMM F-measure  = 0.610761
% HMM Error  = 0.410000
% HCRF Average Pricision  = 0.600370
% HCRF Average Recall  = 0.575000
% HCRF F-measure  = 0.587411
% HCRF Error  = 0.425000
% HMM Average Pricision  = 0.662374
% HMM Average Recall  = 0.645000
% HMM F-measure  = 0.653572
% HMM Error  = 0.355000
% HCRF Average Pricision  = 0.632212
% HCRF Average Recall  = 0.616667
% HCRF F-measure  = 0.624343
% HCRF Error  = 0.383333
% HMM Average Pricision  = 0.685347
% HMM Average Recall  = 0.563333
% HMM F-measure  = 0.618379
% HMM Error  = 0.436667
useHMM = 0;
useHCRF = 0;
useNPMPGM = 1;
dataTrain = getTrainData(1,2);
dataTest = getTestData(1,2);
dataTrain = dataTrain(1:20,1:15);
dataTest = dataTest(1:20,1:25);
if (useHMM == 1)
    nstates = 7;
    nmix = 0;
    [AveragePricision, AverageRecall, F_measure, error] = hmm_main(dataTrain,dataTest,nstates,nmix);
    fprintf('HMM Average Pricision  = %f\n', AveragePricision);
    fprintf('HMM Average Recall  = %f\n', AverageRecall);
    fprintf('HMM F-measure  = %f\n', F_measure);
    fprintf('HMM Error  = %f\n', error);
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
    [AveragePricisionD, AverageRecallD, F_measureD, errorD] = hcrf_main(dataTrain,dataTest,R);
    fprintf('HCRF Average Pricision  = %f\n', AveragePricisionD);
    fprintf('HCRF Average Recall  = %f\n', AverageRecallD);
    fprintf('HCRF F-measure  = %f\n', F_measureD);
    fprintf('HCRF Error  = %f\n', errorD);
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
    [AveragePricisionN, AverageRecallN, F_measureN, errorN] = npmpgm_main(dataTrain,dataTest,row_map,col_map,epohs_map,val_dirichlet);
    fprintf('NPMPGM Average Pricision  = %f\n', AveragePricisionN);
    fprintf('NPMPGM Average Recall  = %f\n', AverageRecallN);
    fprintf('NPMPGM F-measure  = %f\n', F_measureN);
    fprintf('NPMPGM Error  = %f\n', errorN);
 end;