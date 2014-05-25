function [arrayLL] = testModel(Probability,cellNetKox,dataTest)
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
       n= z;
       [maxn,rows] = max(n,[],1);
       % normalizeLogspace - функци€ из matlab-пакета Probabilistic Modeling Toolkit for
       % Matlab/Octave https://github.com/probml/pmtk3
       [logB scale] = normalizeLogspace(n');
       B = exp(logB');
       pi = repmat(5,1,size(w',1));
       pi(1,rows(1,1)) = 10;
       pi = normalizeLogspace(pi);
       pi = exp(pi);
       A =  Probability{m}.A;
       % hmmFilter - функци€ из matlab-пакета Probabilistic Modeling Toolkit for
       % Matlab/Octave https://github.com/probml/pmtk3
       logp = hmmFilter(pi, A, B);
       logp = logp + sum(scale);     
       arrayLL(i,m) = logp;          
    end;
end;
arrayLL = arrayLL';