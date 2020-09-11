function [model, cellNetKox] = hmmsom_train(dataTrainRaw,dataTrainForClass, row_map, col_map, epohs_map, nstates,use_k_means)
%% ‘ункци€ обучени€ модели 
% ¬ходн€е данные:
%       dataTrainRaw - массив €чеек (cell) содежащий обучающие данные,
%       номер строки соответсвует классу, к котормоу принадлежат оубчающие
%       данные: (NxM) - N - количество классов, M - количесвто обучающих
%       примеров дл€ каждого класса; кажда€ €чейка содержит массив -
%       временную последовательность DxT - D - размерность ветора признаков
%       , T - длина последовательности
%       dataTrainForClass - массив €чеек (cell)содежащий обучающие
%       данные дл€ каого класса,объединеннные в одну матрицу: (Nx1) - N - количество классов  
%       row_map - колличество строк карты  охонена
%       col_map - колличество столбцов карты  охонена
%       epohs_map - колличество эпох обучени€ карты  охонена
%       val_dirichlet - параметр распределени€ ƒирихле
% ¬ыходные данные: 
%       Probability - массив €чеек((Nx1)- N - количество классов), кажда€ €чейка это матрица условных распределений вер€отностей перехода
%       между узлами карты  охонена: LxL - где L =row_map*col_map
%       cellNetKox - массив структур соержаща€ веса узлов карты  охонена дл€
%       каждого класса: (Nx1)- N - количество классов
% обучение карты  охонена дл€ каждого класса 
%%
cellNetKox = cell(size(dataTrainRaw,1),1);
% обучение карт  охонена
% !!!! обучение карты внутри parfor возможно только наина€ с версии R2013a 
if use_k_means == 0
    parfor i=1:size(dataTrainForClass,1)
       i % вывод текущего номера класса в консоль
      F = dataTrainForClass{i};
      net = newsom(F,[row_map col_map],'hextop','dist');
      net.trainParam.epochs = epohs_map;
      net.trainParam.showWindow = false;
      [net] = train(net,F); 
      cellNetKox{i} = net;
    end
else
    parfor i=1:size(dataTrainForClass,1)
       i % вывод текущего номера класса в консоль
      F = dataTrainForClass{i};
      [idx, net] = kmeans(F',row_map * col_map, 'MaxIter',epohs_map);
      %[idx,net,sumd,D] = kmeans(F',row_map * col_map,'MaxIter',10000,...
       % 'Display','final','Replicates',10);
      cellNetKox{i} = net;
    end
end
dataTrainForHMM = cell(1,1);
if use_k_means == 0
    for i=1:size(dataTrainRaw,1)
        for j=1:size(dataTrainRaw,2)
           array = sim(cellNetKox{i},dataTrainRaw{i,j});           
           array = vec2ind(array);
           dataTrainForHMM{i,j} = array;
        end
    end
else
    for i=1:size(dataTrainRaw,1)
        for j=1:size(dataTrainRaw,2)
          % array = sim(cellNetKox{i},dataTrainRaw{i,j});           
          % array = vec2ind(array);
            p = dataTrainRaw{i,j};
            w= cellNetKox{i};       
            [S,R11] = size(w);
            [R2,Q] = size(p);
            z = zeros(S,Q);
            w = w';
            copies = zeros(1,Q);
            for ii=1:S
              z(ii,:) = sum((w(:,ii+copies)-p).^2,1);
            end
            n = -z.^0.5;
            [maxn,array] = max(n,[],1);
           dataTrainForHMM{i,j} = array;
        end
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
    'convTol', 1e-5, 'verbose', false);
model = generativeClassifierFit(fitFn, dataTrain, labelTrain);

