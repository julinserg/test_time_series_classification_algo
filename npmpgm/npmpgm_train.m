function [Probability, cellNetKox] = npmpgm_train(dataTrainRaw,dataTrainForClass, row_map, col_map, epohs_map, val_dirichlet)
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
parfor i=1:size(dataTrainForClass,1)
   i % вывод текущего номера класса в консоль
  F = dataTrainForClass{i};
  net = newsom(F,[row_map col_map],'hextop','dist');
  net.trainParam.epochs = epohs_map;
  net.trainParam.showWindow = false;
  [net] = train(net,F); 
  cellNetKox{i} = net;
end;
% вычисл€ем распределение веро€тностей переходов между узлами карты дл€ каждого класса
Probability = cell(size(cellNetKox,1),1);
for i=1:size(cellNetKox,1);
    sizeW = size(cellNetKox{i}.iw{1,1},1);
    Probability{i}.A = repmat(0,sizeW,sizeW);
    Probability{i}.At = repmat(0,sizeW,1);
end;
for i=1:size(dataTrainRaw,1)
    for j=1:size(dataTrainRaw,2)
       array = sim(cellNetKox{i},dataTrainRaw{i,j});           
       array = vec2ind(array);
       for k=1:size(array,2)-1
           pp = array(1,k);
           qq = array(1,k+1);
           Probability{i}.A(pp,qq) = Probability{i}.A(pp,qq) + 1;               
           Probability{i}.At(pp)  = Probability{i}.At(pp) + 1;
       end;
    end;
end;
for i=1:size(Probability,1)
   for j =1:size(Probability{i}.A,2)
        if Probability{i}.At(j) ~= 0          
          vecSumDir = repmat(val_dirichlet,1,size(Probability{i}.A,2));
          Probability{i}.A(j,:) = (Probability{i}.A(j,:)+vecSumDir) ./ (Probability{i}.At(j)+(val_dirichlet*size(Probability{i}.A,2)));
        else
          vecSumDir = repmat(val_dirichlet,1,size(Probability{i}.A,2));
          if val_dirichlet ~= 0             
            Probability{i}.A(j,:) = vecSumDir ./ (val_dirichlet*size(Probability{i}.A,2));
          end;
        end;       
    end;
end;