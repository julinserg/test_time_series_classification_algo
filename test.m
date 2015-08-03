clc;
clear;
fprintf('..........START TEST\n');
%%
useHMM = 1;
useHCRF = 0;
useNPMPGM = 0;
UCIDATASET = 2;
TRAINFOLDSIZE = 20;
dataTrainUCI = getTrainData(1,UCIDATASET);
dataTest = getTestData(1,UCIDATASET);
%%
endD = 0;
index = 0;
while (endD + TRAINFOLDSIZE) <= size(dataTrainUCI,2)    
    endD = endD + TRAINFOLDSIZE;
    dataTrain = dataTrainUCI(:,1:endD);  
    index = index + 1;
    RESULTMATRIX_X(1,index) = size(dataTrain,2);
    if (useHMM == 1)
        nstates = 18;
        nmix = 5;
        [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = hmm_main(dataTrain,dataTest,nstates,nmix);
        RESULTMATRIX_TRAIN(1,index) = errorTR;   
        RESULTMATRIX_TEST(1,index) = errorT;
        fprintf('T HMM Average Precision  = %f\n', PrecisionT);
        fprintf('T HMM Average Recall  = %f\n', RecallT);
        fprintf('T HMM F-measure  = %f\n', F_mT);
        fprintf('T HMM Error  = %f\n', errorT);
        fprintf('TR HMM Average Precision  = %f\n', PrecisionTR);
        fprintf('TR HMM Average Recall  = %f\n', RecallTR);
        fprintf('TR HMM F-measure  = %f\n', F_mTR);
        fprintf('TR HMM Error  = %f\n', errorTR);
        save('RESULTMATRIX_TRAIN.mat', 'RESULTMATRIX_TRAIN');
        save('RESULTMATRIX_TEST.mat', 'RESULTMATRIX_TEST');
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
        RESULTMATRIX_TRAIN(2,index) = errorTR;  
        RESULTMATRIX_TEST(2,index) = errorT;
        fprintf('T HCRF Average Precision  = %f\n', PrecisionT);
        fprintf('T HCRF Average Recall  = %f\n', RecallT);
        fprintf('T HCRF F-measure  = %f\n', F_mT);
        fprintf('T HCRF Error  = %f\n', errorT);
        fprintf('TR HCRF Average Precision  = %f\n', PrecisionTR);
        fprintf('TR HCRF Average Recall  = %f\n', RecallTR);
        fprintf('TR HCRF F-measure  = %f\n', F_mTR);
        fprintf('TR HCRF Error  = %f\n', errorTR);
        save('RESULTMATRIX_TRAIN.mat', 'RESULTMATRIX_TRAIN');
        save('RESULTMATRIX_TEST.mat', 'RESULTMATRIX_TEST');
     end;
     if (useNPMPGM == 1)
        %% ������������� ���� ������� (������� ���������� �������)
        % ������ ���������� ������� = ���������� ���� ����������
        isOpen = matlabpool('size') > 0;
        if isOpen
           matlabpool close; 
        end;
        matlabpool open local 8;
        %% ������������� ���������� ��������������    
        row_map = 10; % ����������� ����� ����� ��������
        col_map = 10; % ����������� �������� ����� ��������
        epohs_map = 100; % ����������� ���� �������� ����� ��������
        val_dirichlet = 0; % �������� ������������� �������
        [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = npmpgm_main(dataTrain,dataTest,row_map,col_map,epohs_map,val_dirichlet);
        RESULTMATRIX_TRAIN(3,index) = errorTR;   
        RESULTMATRIX_TEST(3,index) = errorT;
        fprintf('T NPMPGM Average Precision  = %f\n', PrecisionT);
        fprintf('T NPMPGM Average Recall  = %f\n', RecallT);
        fprintf('T NPMPGM F-measure  = %f\n', F_mT);
        fprintf('T NPMPGM Error  = %f\n', errorT);
        fprintf('TR NPMPGM Average Precision  = %f\n', PrecisionTR);
        fprintf('TR NPMPGM Average Recall  = %f\n', RecallTR);
        fprintf('TR NPMPGM F-measure  = %f\n', F_mTR);
        fprintf('TR NPMPGM Error  = %f\n', errorTR);
        save('RESULTMATRIX_TRAIN.mat', 'RESULTMATRIX_TRAIN');
        save('RESULTMATRIX_TEST.mat', 'RESULTMATRIX_TEST');
     end;    
end;
%%
fprintf('..........STOP TEST\n');

%% PLOT
set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');
set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); 
figure('Units', 'normalized', 'OuterPosition', [0 0 1 1]);
hold on;
plot(RESULTMATRIX_X, RESULTMATRIX_TRAIN,'r','LineWidth',3);
plot(RESULTMATRIX_X, RESULTMATRIX_TEST,'--','Color',[.1 .4 .1],'LineWidth',3);
axis([-inf,inf,0,1])
legend('ERROR TRAIN','ERROR TEST', 2);
BX=get(gca,'XTick');
BY=get(gca,'YTick');
xlabel('Sample Size');
ylabel('Error');