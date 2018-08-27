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
N_STATES = 6;
N_MIX = 0;
use = 6; % HMM - 1  HCRF - 2 NPMPGM - 3 LSTM - 4 KNN - 5 HMMSOM - 6 HMMKMEANS - 7
UCIDATASET = 17;
%TRAINFOLDSIZE = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 660];
%TRAINFOLDSIZE = [ 20, 30, 40, 50, 60, 70, 80];
%TRAINFOLDSIZE = [20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200];
TRAINFOLDSIZE = [80];
%TRAINFOLDSIZE = [20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120,130,140,150,160,170,180,190,200];
dataTrainUCI = getTrainData(1,UCIDATASET);
dataTest = getTestData(1,UCIDATASET);


%%
endD = 0;
index = 0;
RESULTMATRIX_TRAIN = zeros(7, size(TRAINFOLDSIZE,2));
RESULTMATRIX_TEST = zeros(7, size(TRAINFOLDSIZE,2));
for ii = 1: size(TRAINFOLDSIZE,2) 
    endD = TRAINFOLDSIZE(ii);
    dataTrain = dataTrainUCI(:,1:endD);  
    index = index + 1;
    RESULTMATRIX_X(use,index) = endD;
    RESULTMATRIX_X(use,index) = endD;
    RESULTMATRIX_X(use,index) = endD;
    K_FOLD = size(dataTrainUCI,2)/endD;    
    Indices = mycrosvalid( size(dataTrainUCI,2), K_FOLD );
    K_FOLD = 1;
    for cros_iter = 1 : K_FOLD
        dataTrainCross = dataTrainUCI(:,Indices == cros_iter );        
        if (use == 1)
            diag = 0;
            [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = hmm_main(dataTrainCross,dataTest,N_STATES,N_MIX,diag); 
            fprintf('Test HMM Error  = %f\n', errorT);
            fprintf('Train HMM Error  = %f\n', errorTR);   
        end
        if (use == 2)
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
            fprintf('Test HCRF Error  = %f\n', errorT); 
            fprintf('Train HCRF Error  = %f\n', errorTR);     
        end
        if (use == 3)        
            %% Инициализация параметров классификатора    
            row_map = 1; % колличество строк карты Кохонена
            col_map = N_STATES; % колличество столбцов карты Кохонена
            epohs_map = 1000; % колличество эпох обучения карты Кохонена
            val_dirichlet = 0; % параметр распределения Дирихле
            [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = npmpgm_main(dataTrainCross,dataTest,row_map,col_map,epohs_map,val_dirichlet);            
            fprintf('Test NPMPGM Error  = %f\n', errorT);  
            fprintf('Train NPMPGM Error  = %f\n', errorTR);            
        end
        if (use == 4)        
            [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = lstm_main(dataTrainCross,dataTest); 
            fprintf('Test LSTM Error  = %f\n', errorT);
            fprintf('Train LSTM Error  = %f\n', errorTR);   
        end
        if (use == 5)        
            [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = knn_main(dataTrainCross,dataTest); 
            fprintf('Test KNN Error  = %f\n', errorT);
            fprintf('Train KNN Error  = %f\n', errorTR);   
        end
        if (use == 6)        
            %% Инициализация параметров классификатора    
            row_map = 10; % колличество строк карты Кохонена
            col_map = 10; % колличество столбцов карты Кохонена
            epohs_map = 1000; % колличество эпох обучения карты Кохонена           
            [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = hmmsom_main(dataTrainCross,dataTest,row_map,col_map,epohs_map,N_STATES,1);            
            fprintf('Test HMMSOM Error  = %f\n', errorT);  
            fprintf('Train HMMSOM Error  = %f\n', errorTR);
            
        end
        if (use == 7)        
            %% Инициализация параметров классификатора    
            row_map = 1; % колличество строк карты Кохонена
            col_map = N_STATES; % колличество столбцов карты Кохонена
            epohs_map = 1000; % колличество эпох обучения карты Кохонена
            val_dirichlet = 0; % параметр распределения Дирихле
            [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = npmpgm_kmeans_main(dataTrainCross,dataTest,row_map,col_map,epohs_map,val_dirichlet);            
            fprintf('Test HMM_KMEANS Error  = %f\n', errorT);  
            fprintf('Train HMM_KMEANS Error  = %f\n', errorTR);            
        end
        RESULTMATRIX_TRAIN(use,index) = RESULTMATRIX_TRAIN(use,index) + errorTR;   
        RESULTMATRIX_TEST(use,index) =  RESULTMATRIX_TEST(use,index) + errorT;
    end
    RESULTMATRIX_TRAIN(use,index) =  RESULTMATRIX_TRAIN(use,index) / K_FOLD;
    RESULTMATRIX_TEST(use,index) =  RESULTMATRIX_TEST(use,index) / K_FOLD;
    fprintf('Test CrossValidation Error  = %f\n', RESULTMATRIX_TEST(use,index));  
    fprintf('Train CrossValidation Error  = %f\n', RESULTMATRIX_TRAIN(use,index));
    save('RESULTMATRIX_TRAIN.mat', 'RESULTMATRIX_TRAIN');
    save('RESULTMATRIX_TEST.mat', 'RESULTMATRIX_TEST');
end
%%
fprintf('..........STOP EXPERIMENT\n');

%% PLOT
set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');
set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); 
figure('Units', 'normalized', 'OuterPosition', [0 0 1 1]);
hold on;
plot(RESULTMATRIX_X(use,:), RESULTMATRIX_TRAIN(use,:),'r','LineWidth',3);
plot(RESULTMATRIX_X(use,:), RESULTMATRIX_TEST(use,:),'--','Color',[.1 .4 .1],'LineWidth',3);
axis([-inf,inf,0,1])
legend('ERROR TRAIN','ERROR TEST', 2);
BX=get(gca,'XTick');
BY=get(gca,'YTick');
xlabel('Sample Size');
ylabel('Error');