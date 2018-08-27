function [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = npmpgm_kmeans_main(dataTrainRaw,dataTest,row_map,col_map,epohs_map,val_dirichlet)

% чтение обучающих данных
% подготовка обучающих данных дл€ карты  охонена
USETRAIN = 1;
% загрузить обучающие данные 
%       dataTrainRaw - массив €чеек (cell) содежащий обучающие данные,
%       номер строки соответсвует классу, к котормоу принадлежат оубчающие
%       данные: (NxM) - N - количество классов, M - количесвто обучающих
%       примеров дл€ каждого класса; кажда€ €чейка содержит массив -
%       временную последовательность DxT - D - размерность ветора признаков
%       , T - длина последовательности
%load dataTrainRaw;
k = 1;
for i=1:size(dataTrainRaw,1)
    for j=1:size(dataTrainRaw,2)
        dataTrain{k,1} = dataTrainRaw{i,j};
        labelTrain(k,1) = i-1; 
        k = k+1;
    end;
end;
k_1 = 1;
dataTrainForClass = cell(size(dataTrainRaw,1),1);
for i=1:size(dataTrain,1)  
    u = size(dataTrain{i},2);
    a = dataTrain{i};
    t = size(dataTrainForClass{labelTrain(i)+1},2) +1;        
    dataTrainForClass{labelTrain(i)+1}(:,t:t+u-1) = a;       
    k_1 = k_1+size(a,2);  
end;

%% ќбучение модели
if USETRAIN == 1    
   [Probability, cellNetKox] = npmpgm_kmeans_train(dataTrainRaw,dataTrainForClass, ...
   row_map,col_map,epohs_map,val_dirichlet);
   % —охранение матриц условных веро€тностей в файл
   save('ProbabilityTransaction.mat','Probability');
   % —охранение карт  хонена в файл
   save('modelKohonen.mat', 'cellNetKox');
end;
%%  лассификаци€
% «агрузка ранее сохраненной модели
load modelKohonen;
load ProbabilityTransaction;
% загрузить тестовые данные
%       dataTest - массив €чеек (cell) содежащий тестовые размечанные данные,
%       номер строки соответсвует классу, к котормоу принадлежат тестовые
%       размечанны  данные: (NxM) - N - количество классов, M - количесвто обучающих
%       примеров дл€ каждого класса; кажда€ €чейка содержит массив -
%       временную последовательность DxT - D - размерность ветора признаков
%       , T - длина последовательности

%% test on test data
[PrecisionT, RecallT, F_mT, errorT] = npmpgm_kmeans_test_l(dataTest,Probability,cellNetKox);
%% test on train data
[PrecisionTR, RecallTR, F_mTR, errorTR] = npmpgm_kmeans_test_l(dataTrainRaw,Probability,cellNetKox);

function [AveragePrecision, AverageRecall, F_measure, error] = npmpgm_kmeans_test_l(dataTest,Probability,cellNetKox)
k = 1;
for i=1:size(dataTest,1)
    for j=1:size(dataTest,2)       
        labelTest{i,j}(1,1) = i-1; 
        k = k+1;
    end;
end;
dataTest = dataTest(:);
[arrayLL] = npmpgm_kmeans_test(Probability,cellNetKox,dataTest);
% arrayLabelDetect - массив меток классов выданных классификатором  
for i=1:size(arrayLL,2)
    [c index] = max(arrayLL(:,i));
     arrayLabelDetect(1,i) = index-1;  
end;
% arrayLabelTrue - массив меток классов выданных экспертом
arrayLabelTrue = cell2mat(labelTest(:));
arrayLabelTrue = arrayLabelTrue';

%% ќценка качества классификации
[AveragePrecision, AverageRecall, F_measure, error] = calculateQuality(arrayLabelDetect,arrayLabelTrue,size(arrayLL,1));


