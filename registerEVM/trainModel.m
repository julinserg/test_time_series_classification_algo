function [Probability, cellNetKox] = trainModel(dataTrainRaw,dataTrainForClass, row_map, col_map, epohs_map, val_dirichlet)

% обучение карты Кохонена для каждого класса 
cellNetKox = cell(size(dataTrainRaw,1),1);
% обучение карт Кохонена
parfor i=1:size(dataTrainForClass,1)
  i % вывод текущего номера класса в консоль
  net = newsom(dataTrainForClass{i},[row_map col_map],'hextop','dist');
  net.trainParam.epochs = epohs_map;
  [net,tr] = train(net,dataTrainForClass{i}); 
  cellNetKox{i} = net;
end;
% вычисляем распределение вероятностей переходов между узлами карты для каждого класса
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
          vecSumDir = repmat(val,1,size(Probability{i}.A,2));
          Probability{i}.A(j,:) = (Probability{i}.A(j,:)+vecSumDir) ./ (Probability{i}.At(j)+(val_dirichlet*size(Probability{i}.A,2)));
        else
          vecSumDir = repmat(val,1,size(Probability{i}.A,2));
          if val_dirichlet ~= 0             
            Probability{i}.A(j,:) = vecSumDir ./ (val*size(Probability{i}.A,2));
          end;
        end;       
    end;
end;