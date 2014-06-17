function [arrayLL] = testModel(Probability,cellNetKox,dataTest)
%% Функция классификации
% Входные данные:
%       Probability - массив ячеек((Nx1)- N - количество классов), каждая ячейка это матрица условных распределений веряотностей перехода
%       между узлами карты Кохонена: LxL - где L =row_map*col_map
%       cellNetKox - массив структур соержащая веса узлов карты Кохонена для
%       каждого класса: (Nx1)- N - количество классов
%       dataTest -массив ячеек (cell) содежащий данные для классифкации, - 1xM,
%       где M - количесвто тестовых примеров,каждая ячейка содержит 
%       временную последовательностей DxT - D - размерность ветора признаков
%       , T - длина последовательности
% Выходные данные:
%       arrayLL - массив значений правдоподобий (NxM) - N - количество
%       классов, M - количесвто тестовых примеров
%%
for i = 1:size(dataTest,1)
    p = dataTest{i};
    parfor m = 1:size(cellNetKox,1)
       w= cellNetKox{m}.iw{1,1};       
       [S,R11] = size(w);
       [R2,Q] = size(p);
       z = zeros(S,Q);
       w = w';
       copies = zeros(1,Q);
       for ii=1:S
         z(ii,:) = sum((w(:,ii+copies)-p).^2,1);
       end;
       z = -z.^0.5;      
       prob = exp(z);
       loglik = sum(log(prob+eps));   
       arrayLL(i,m) = loglik;          
    end;
end;
arrayLL = arrayLL';