
clc;
clear;
NUM = 2;
% clear('arrayLabelDetect','arrayLabelTrue','fileLable','R{2}.model', 'R{2}.stats','post','arrayLL','arrayLabel','arrayLL_old','ll', 'label','net','net2','tr','distanseKox','newLableMapKohonen','newLableMapKohonenNormal','distanseKoxNew','lableMinDistanse','res');   

%% about
%   классификация арабских цифр с помощью HCRF library
%% init
load sampleData;
%load initDataTransHMMtoHCRF
%paramsData.weightsPerSequence = ones(1,512);
%paramsData.factorSeqWeights = 1;
R{2}.params = paramsNodHCRF;
R{2}.params.nbHiddenStates = 5;
R{2}.params.modelType = 'hcrf';
R{2}.params.GaussianHCRF = 0;
R{2}.params.windowRecSize = 0;
R{2}.params.windowSize = 0;
R{2}.params.optimizer = 'bfgs';
R{2}.params.regFactorL2 = 1;
R{2}.params.regFactorL1 = 0;
%R{2}.params.initWeights = initDataTransHMMtoHCRF;
%% train
%net2 = arabic_digit_hcrf_train_koh(R);
%load dataTrainArabicDigitModul;
dataTrainArabicDigit = getTestDataOnTest(NUM);


%clustering(dataTrainArabicDigit);
R = arabic_digit_hcrf_gibrid_train(R,dataTrainArabicDigit,NUM);
matHCRF('saveModel','fileModel_hcrf','fileFeatureDefinition_hcrf');
%% test prepare
% modelHCRF = R{2};
% assert (strcmp(modelHCRF.params.modelType, 'hcrf') || strcmp(modelHCRF.params.modelType, 'ghcrf')); %{+KGB}
% matHCRF('createToolbox',modelHCRF.params.modelType,modelHCRF.params.optimizer, modelHCRF.params.nbHiddenStates, modelHCRF.params.windowSize); %{+KGB}
% if isfield(modelHCRF.params,'debugLevel')
%     matHCRF('set','debugLevel',modelHCRF.params.debugLevel);
% end
% matHCRF('set','nbThreads',128);
% matHCRF('loadModel','fileModel_hcrf','fileFeatureDefinition_hcrf');
% [model, featureDefinition]=matHCRF('getModel'); 
% modelHCRF.model = model;
% modelHCRF.features = featureDefinition;
% matHCRF('setModel',modelHCRF.model, modelHCRF.features);
% 
% %Normalise data {%+KGB}
% if isfield(modelHCRF.params,'normalise') && modelHCRF.params.normalise == 1
%     dataTestArabicDigit = normaliseCellArray(dataTestArabicDigit);
%     dataTestArabicDigit = removeOutliers(dataTest, modelHCRF.outlierTresh(2), modelHCRF.outlierTresh(1));     
% end

%hF1 = figure;
%hF2 = figure;
%% test on train data
% %figure(hF1);
% dataTestArabicDigit = getTestDataOnTrain(NUM);
% %load dataTrainArabicDigitModul;
% %dataTestArabicDigit = dataTrainArabicDigit;
% clear('ll','label','arrayLL','arrayLL_old');
% [ll label] = arabic_digit_hcrf_test(dataTestArabicDigit,NUM);
% 
% % prepare test result
% k = 0;
% for i=1: size(ll,1)
%     for j=1:size(ll,2)
%         k = (i-1)*size(ll,2)+ j;
%         arrayLL(:,k) = ll{i,j}(:,1);  
%     end;
% end;
% arrayLL_old = arrayLL';
% post = exp(normalizeLogspace(arrayLL_old));
% arrayLL = post';
% 
% for i=1: size(label,1)
%     for j=1:size(label,2)
%         k = (i-1)*size(label,2)+ j;
%         arrayLabel(1,k) = label{i,j}(1,1);
%         for c = 1:size(arrayLL,1)
%             if (c == i)
%                 arrayLabel(c,k) = 1;
%             else
%                 arrayLabel(c,k) = 0;
%             end;
%         end;
%     end;
% end;
% % create ROC-curve and AUC for train data
% [auc, tpr,fpr,thresholds] = curveROCandAUC(arrayLabel,arrayLL);
% % рисуем ROC кривые для обучающей выборки
% % for i=1:size(fpr,2) 
% %     subplot(2,2,1);
% %     plot(fpr{i},tpr{i});    
% %     hold on;    
% % end;
% %fprintf('Average AUC = %f\n',sum(auc)/size(auc,2) );
% % plot(fpr{1},tpr{1},'r',fpr{2},tpr{2},'g',fpr{3},tpr{3},'b',fpr{4},tpr{4},'c',fpr{5},tpr{5},'m',[0,1],[0,1],'-.k');
% % h = legend('class 0 ','class 1 ','class 2 ','class 3 ','class 4 ',5);
% % set(h,'Interpreter','none');
% % title('ROC-curve for train data');
% % xlabel('false positiv rate');
% % ylabel('true positiv rate');
% % выводим значения AUC для обучающей выборки
% % for i = 1:size(auc,2)
% % fprintf('AUC for train data class %d = %f\n',i-1, auc(i));
% % end;
% % считаем основной показатель качества
% 
% for i=1:size(arrayLL,2)
%     [c index] = max(arrayLL(:,i));
%      arrayLabelDetect(1,i) = index-1;    
% end;
% for i =1:size(label,1)
%     for j=1:size(label,2)
%      arrayLabelTrue(1,(i-1)*size(label,2)+j) = label{i,j}(1,1); 
%     end;
% end;
% [AveragePricision, AverageRecall, F_measure] =calculateQuality(arrayLabelDetect,arrayLabelTrue,size(label,2));

%% test on test data
%figure(hF2);

%[ll label] = arabic_digit_hcrf_test_koh(dataTestArabicDigit,net2);
clear('ll','label','arrayLL','arrayLL_old');
%load dataTestArabicDigitModul;
% for i=1:size(dataTestArabicDigit,1)
%       for j=1:size(dataTestArabicDigit,2)
%          dataTestArabicDigit{i,j} = abs(dataTestArabicDigit{i,j}); 
%       end;
%  end;
dataTestArabicDigit = getTrainData(NUM);


[ll label] = arabic_digit_hcrf_gibrid_test(dataTestArabicDigit,NUM);
% prepare test result
k = 0;
for i=1: size(ll,1)
    for j=1:size(ll,2)
        k = (i-1)*size(ll,2)+ j;       
        arrayLL(:,k) = ll{i,j}(:,1);      
    end;
end;
% arrayLL_old = arrayLL';
% post = exp(normalizeLogspace(arrayLL_old));
% arrayLL = post';

for i=1: size(label,1)
    for j=1:size(label,2)
        k = (i-1)*size(label,2)+ j;
        arrayLabel(1,k) = label{i,j}(1,1);
        for c = 1:size(arrayLL,1)
            if (c == i)
                arrayLabel(c,k) = 1;
            else
                arrayLabel(c,k) = 0;
            end;
        end;
    end;
end;
% create ROC-curve and AUC for train data
%[auc, tpr,fpr,thresholds] = curveROCandAUC(arrayLabel,arrayLL);
% рисуем ROC кривые для обучающей выборки
% hold off
% for i=1:size(fpr,2)
%     subplot(2,2,2);
%     plot(fpr{i},tpr{i});
%     hold on
% end;
%fprintf('Average AUC = %f\n',sum(auc)/size(auc,2) );
% plot(fpr{1},tpr{1},'r',fpr{2},tpr{2},'g',fpr{3},tpr{3},'b',fpr{4},tpr{4},'c',fpr{5},tpr{5},'m',[0,1],[0,1],'-.k');
% h = legend('class 0 ','class 1 ','class 2 ','class 3 ','class 4 ',5);
% set(h,'Interpreter','none');
% title('ROC-curve for test data');
% xlabel('false positiv rate');
% ylabel('true positiv rate');
% % выводим значения AUC для обучающей выборки
% for i = 1:size(auc,2)
% fprintf('AUC for train data class %d = %f\n',i-1, auc(i));
% end;
% считаем основной показатель качества

for i=1:size(arrayLL,2)
    [c index] = max(arrayLL(:,i));
     arrayLabelDetect(1,i) = index-1;    
end;
for i =1:size(label,1)
    for j=1:size(label,2)
     arrayLabelTrue(1,(i-1)*size(label,2)+j) = label{i,j}(1,1); 
    end;
end;

D = now();
strTime = datestr(D,30);
[AveragePricision, AverageRecall, F_measure] =calculateQuality(arrayLabelDetect,arrayLabelTrue,size(label,1));
saveStr = [AveragePricision, AverageRecall, F_measure];
csvwrite(strcat('res_',strTime,'.csv'),saveStr);
