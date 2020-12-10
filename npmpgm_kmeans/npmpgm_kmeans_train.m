function [Probability, cellNetKox, model] = npmpgm_kmeans_train(dataTrainRaw,dataTrainForClass, row_map, col_map, epohs_map, val_dirichlet, isNewModel)
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
Sigma = cell(size(dataTrainRaw,1),1);

% обучение карт  охонена
% !!!! обучение карты внутри parfor возможно только наина€ с версии R2013a 
for i=1:size(dataTrainForClass,1)
   i % вывод текущего номера класса в консоль
  F = dataTrainForClass{i};
  options = statset('UseParallel',1);
  [idx, net] = kmeans(F',row_map * col_map, ...
  'MaxIter',epohs_map,'Replicates',10,'Options',options);
  %[idx,net,sumd,D] = kmeans(F',row_map * col_map,'MaxIter',10000,...
   % 'Display','final','Replicates',10);
  cellNetKox{i} = net;
  
    for k=1:row_map * col_map
       %s = std(F');
       s = ones(1, size(F,1));
        D = diag(s);
        DD(:,:,k) = D;
    end
    Sigma{i} = DD;
  
end;
% вычисл€ем распределение веро€тностей переходов между узлами карты дл€ каждого класса
Probability = cell(size(cellNetKox,1),1);
for i=1:size(cellNetKox,1);
    sizeW = size(cellNetKox{i},1);
    Probability{i}.A = repmat(0,sizeW,sizeW);
    Probability{i}.At = repmat(0,sizeW,1);
end
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
       % if isCalcSigma == 1
       %     n = n ./Sigma{i};
       % end
        [maxn,array] = max(n,[],1);
       for k=1:size(array,2)-1
           pp = array(1,k);
           qq = array(1,k+1);
           Probability{i}.A(pp,qq) = Probability{i}.A(pp,qq) + 1;               
           Probability{i}.At(pp)  = Probability{i}.At(pp) + 1;
       end
    end
end
for i=1:size(Probability,1)
   for j =1:size(Probability{i}.A,2)
        if Probability{i}.At(j) ~= 0          
          vecSumDir = repmat(val_dirichlet,1,size(Probability{i}.A,2));
          Probability{i}.A(j,:) = (Probability{i}.A(j,:)+vecSumDir) ./ (Probability{i}.At(j)+(val_dirichlet*size(Probability{i}.A,2)));
        else
          vecSumDir = repmat(val_dirichlet,1,size(Probability{i}.A,2));
          if val_dirichlet ~= 0             
            Probability{i}.A(j,:) = vecSumDir ./ (val_dirichlet*size(Probability{i}.A,2));
          end
        end  
   end
end

model.isNewModel = isNewModel;
model.modelType = 'generativeClassifier';
model.nclasses = size(cellNetKox, 1);
nclasses = model.nclasses;
classConditionals = cell(nclasses, 1);
for c=1:nclasses
    modelP.nstates = size(cellNetKox{c},1);
    modelP.type = 'gauss';

    modelP.pi = repmat(5, 1, size(Probability{c}.A,2));
    modelP.pi(1,1) = 10;
    modelP.pi = normalizeLogspace(modelP.pi);
    modelP.pi = exp(modelP.pi);
    modelP.A = Probability{c}.A;
    modelPP.nstates = size(cellNetKox{c},1);
    modelPP.d = size(dataTrainRaw{1,1},1);
    modelPP.N = size(dataTrainRaw{1,1},2);
    modelPP.mu = cellNetKox{c}';
    modelPP.Sigma = Sigma{c};
    d = modelPP.d;
    prior.mu    = zeros(1, d);
    prior.Sigma = 0.1*eye(d);
    prior.k     = 0.01;  
    prior.dof   = d + 1; 
    %modelPP = addPrior(modelPP, prior);    
    modelPP.cpdType = 'condgauss';
    modelP.emission = modelPP;
    classConditionals{c} = modelP;
end
model.classConditionals = classConditionals;

k = 1;
for i=1:size(dataTrainRaw,1)
    for j=1:size(dataTrainRaw,2)
        dataTrain{k,1} = dataTrainRaw{i,j};
        labelTrain(k,1) = i-1; 
        k = k+1;
    end
end

SetDefaultValue(4, 'pseudoCount', ones(1, model.nclasses)); 
prior = discreteFit(labelTrain, pseudoCount);
model.prior = prior;
end

function model = addPrior(model, prior)
N    = model.N;
XX      = model.Sigma;
xbar    = model.mu;
d       = model.d;
nstates = model.nstates;

kappa0 = prior.k;
m0     = prior.mu(:);
nu0    = prior.dof;
S0     = prior.Sigma;
mu     = zeros(d, nstates);
SigmaL  = zeros(d, d, nstates);
for k = 1:nstates
    xbark          = xbar(:, k);
    XXk            = XX(:, :, k);
    wk             = N;
    mn             = (wk*xbark + kappa0*m0)./(wk + kappa0);
    a              = (kappa0*wk)./(kappa0 + wk);
    b              = nu0 + wk + d + 2;
    Sprior         = (xbark-m0)*(xbark-m0)';
    SigmaL(:, :, k) = (S0 + XXk + a*Sprior)./b;
    mu(:, k)       = mn;
end
model.mu    = mu;
model.Sigma = SigmaL;
end
