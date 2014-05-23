clc;
clear;
%% Инициализация пула потоков (задание количества потоков)
isOpen = matlabpool('size') > 0;
if isOpen
   matlabpool close; 
end;
matlabpool open local 1;
%% Инициализация параметров классификатора
USETRAIN = 1 % 1-обучать модель заново 0-использовать сохраненную модель 
row_map = 10; % колличество строк карты Кохонена
col_map = 10; % колличество столбцов карты Кохонена
epohs_map = 100; % колличество эпох обучения карты Кохонена
val_dirichlet = 0; % параметр распределения Дирихле
% чтение обучающих данных
% подготовка обучающих данных для карты Кохонена
k = 1;
dataTrainRaw = getTrainData(1);
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
   [Probability, cellNetKox] = trainModel(dataTrainRaw,dataTrainForClass, ...
   row_map,col_map,epohs_map,val_dirichlet);
   % Сохранение матриц условных вероятностей в файл
   save('ProbabilityTransaction.mat','Probability');
   % Сохранение карт Кхонена в файл
   save('modelKohonen.mat', 'cellNetKox');
end;
%% Классификация
% Загрузка ранее сохраненной модели
load modelKohonen;
load ProbabilityTransaction;
% чтение тестовых данных
dataTest =  getTestDataOnTest(1);
for i=1:size(dataTest,1)
    for j=1:size(dataTest,2)       
        labelTest{i,j}(1,1) = i-1; 
        k = k+1;
    end;
end;

[arrayLL] = testModel(Probability,cellNetKox,dataTest);

for i=1:size(arrayLL,2)
    [c index] = max(arrayLL(:,i));
     arrayLabelDetect(1,i) = index-1;    
end;
for i =1:size(labelTest,1)
    for j=1:size(labelTest,2)
     arrayLabelTrue(1,(i-1)*size(labelTest,2)+j) = labelTest{i,j}(1,1); 
    end;
end;
%% Оценка качества классификации
[ff,gg, fmear,qual] = calculateQuality(arrayLabelDetect,arrayLabelTrue,size(arrayLL,1));
save('lastTest.dat','-ascii','qual','-double');


