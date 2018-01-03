function [model, cellNetKox] = hmmsom_train(dataTrainRaw,dataTrainForClass, row_map, col_map, epohs_map, nstates)
%% Функция обучения модели 
% Входняе данные:
%       dataTrainRaw - массив ячеек (cell) содежащий обучающие данные,
%       номер строки соответсвует классу, к котормоу принадлежат оубчающие
%       данные: (NxM) - N - количество классов, M - количесвто обучающих
%       примеров для каждого класса; каждая ячейка содержит массив -
%       временную последовательность DxT - D - размерность ветора признаков
%       , T - длина последовательности
%       dataTrainForClass - массив ячеек (cell)содежащий обучающие
%       данные для каого класса,объединеннные в одну матрицу: (Nx1) - N - количество классов  
%       row_map - колличество строк карты Кохонена
%       col_map - колличество столбцов карты Кохонена
%       epohs_map - колличество эпох обучения карты Кохонена
%       val_dirichlet - параметр распределения Дирихле
% Выходные данные: 
%       Probability - массив ячеек((Nx1)- N - количество классов), каждая ячейка это матрица условных распределений веряотностей перехода
%       между узлами карты Кохонена: LxL - где L =row_map*col_map
%       cellNetKox - массив структур соержащая веса узлов карты Кохонена для
%       каждого класса: (Nx1)- N - количество классов
% обучение карты Кохонена для каждого класса 
%%
cellNetKox = cell(size(dataTrainRaw,1),1);
% обучение карт Кохонена
% !!!! обучение карты внутри parfor возможно только наиная с версии R2013a 
for i=1:size(dataTrainForClass,1)
   i % вывод текущего номера класса в консоль
  F = dataTrainForClass{i};
  net = newsom(F,[row_map col_map],'hextop','dist');
  net.trainParam.epochs = epohs_map;
  net.trainParam.showWindow = false;
  [net] = train(net,F); 
  cellNetKox{i} = net;
end
dataTrainForHMM = cell(1,1);
for i=1:size(dataTrainRaw,1)
    for j=1:size(dataTrainRaw,2)
       array = sim(cellNetKox{i},dataTrainRaw{i,j});           
       array = vec2ind(array);
       dataTrainForHMM{i,j} = array;
    end
end

dataTrain = cell(1,1);
k = 1;
for i=1:size(dataTrainForHMM,1)
    for j=1:size(dataTrainForHMM,2)
        dataTrain{k,1} = dataTrainForHMM{i,j};       
        labelTrain(k,1) = i-1; 
        k = k+1;
    end
end

%% train
pi0 = repmat(0,1,nstates);
pi0(1,1) = 1;
nrestarts = 2;
transmat0 = normalize(diag(ones(nstates, 1)) + ...
            diag(ones(nstates-1, 1), 1), 2); 
fitFn   = @(X)hmmFit(X, nstates, 'discrete', ...
    'pi0', pi0, 'trans0', transmat0, 'maxIter', 500, ...
    'convTol', 1e-5, 'verbose', true);
model = generativeClassifierFit(fitFn, dataTrain, labelTrain);

