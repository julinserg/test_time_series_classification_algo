function [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = hmmsom_main(dataTrainRaw,dataTest,row_map,col_map,epohs_map,nstates, use_k_means)

% чтение обучающих данных
% подготовка обучающих данных для карты Кохонена
USETRAIN = 1;
% загрузить обучающие данные 
%       dataTrainRaw - массив ячеек (cell) содежащий обучающие данные,
%       номер строки соответсвует классу, к котормоу принадлежат оубчающие
%       данные: (NxM) - N - количество классов, M - количесвто обучающих
%       примеров для каждого класса; каждая ячейка содержит массив -
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

%% Обучение модели
if USETRAIN == 1    
   [model, cellNetKox] = hmmsom_train(dataTrainRaw,dataTrainForClass, ...
   row_map,col_map,epohs_map,nstates,use_k_means);
   % Сохранение карт Кхонена в файл
   save('model.mat', 'model');
   save('cellNetKox.mat', 'cellNetKox');
end;
%% Классификация
% Загрузка ранее сохраненной модели
load model;
load cellNetKox;
%% test on test data
[PrecisionT, RecallT, F_mT, errorT] = hmmsom_test_l(dataTest,model,cellNetKox,use_k_means);
%% test on train data
[PrecisionTR, RecallTR, F_mTR, errorTR] = hmmsom_test_l(dataTrainRaw,model,cellNetKox,use_k_means);

function [AveragePrecision, AverageRecall, F_measure, error] = hmmsom_test_l(dataTest,model,cellNetKox,use_k_means)
[ll] = hmmsom_test(dataTest,model,cellNetKox,use_k_means);
arrayLL = ll';
label = cell(1,1);
k = 1;
for i=1:size(dataTest,1)
    for j=1:size(dataTest,2)       
        label{i,j}(1,1) = i-1; 
        k = k+1;
    end
end

for i=1:size(arrayLL,2)
    [c index] = max(arrayLL(:,i));
     arrayLabelDetect(1,i) = index-1;    
end
for i =1:size(label,1)
    for j=1:size(label,2)
     arrayLabelTrue(1,(i-1)*size(label,2)+j) = label{i,j}(1,1); 
    end
end
[AveragePrecision, AverageRecall, F_measure, error] =calculateQuality(arrayLabelDetect,arrayLabelTrue,size(label,1));


