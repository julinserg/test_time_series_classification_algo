function [arrayLL] = npmpgm_kmeans_test(Probability,cellNetKox,model,dataTest)
%% ‘ункци€ классификации
% ¬ходные данные:
%       Probability - массив €чеек((Nx1)- N - количество классов), кажда€ €чейка это матрица условных распределений вер€отностей перехода
%       между узлами карты  охонена: LxL - где L =row_map*col_map
%       cellNetKox - массив структур соержаща€ веса узлов карты  охонена дл€
%       каждого класса: (Nx1)- N - количество классов
%       dataTest -массив €чеек (cell) содежащий данные дл€ классифкации, - 1xM,
%       где M - количесвто тестовых примеров,кажда€ €чейка содержит 
%       временную последовательностей DxT - D - размерность ветора признаков
%       , T - длина последовательности
% ¬ыходные данные:
%       arrayLL - массив значений правдоподобий (NxM) - N - количество
%       классов, M - количесвто тестовых примеров
%%
if model.isNewModel == 0
for i = 1:size(dataTest,1)
    p = dataTest{i};
    for m = 1:size(cellNetKox,1)
       w= cellNetKox{m};       
        [S,R11] = size(w);
        [R2,Q] = size(p);
        z = zeros(S,Q);
        w = w';
        copies = zeros(1,Q);
        for ii=1:S
          z(ii,:) = sum((w(:,ii+copies)-p).^2,1);
        end;
       n = -z.^0.5;
       B = exp(n);    
      
       [maxn,rows] = max(n,[],1);
       pih = repmat(5,1,size(w',1));
       pih(1,rows(1,1)) = 10;
       pih = normalizeLogspace(pih);
       pih = exp(pih);
      % pih = zeros(1, size(Probability{m}.A,2));
      % pih(1,1) = 1;
       A =  Probability{m}.A;
       % hmmFilter - функци€ из matlab-пакета Probabilistic Modeling Toolkit for
       % Matlab/Octave https://github.com/probml/pmtk3
       %logp = hmmFilter(pih, A, B);
       [K T] = size(B);   
       scale = zeros(T,1);
       alpha = zeros(K,T); 
       AT = A';
       [alpha, scale(1)] = normalize(pih(:) .* B(:,1));
       for t=2:T
           [alpha, scale(t)] = normalize((AT * alpha) .* B(:,t));
       end
       logp = sum(log(scale+eps));
       %logp2 = log(prob_all);
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       arrayLL(i,m) = logp;          
    end
end
else
    Xtest = dataTest;
    nclasses = model.nclasses;
    n = size(Xtest, 1);
    classConditionals = model.classConditionals;
    L = zeros(n, nclasses);
    logpy = log(model.prior.T + eps);
    for c=1:nclasses
        L(:, c) = hmmLogprob(classConditionals{c}, Xtest) + logpy(c);
    end
    arrayLL = L;
end
arrayLL = arrayLL';