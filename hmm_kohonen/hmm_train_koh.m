function [model] = hmm_train_koh(nstates,dataTrainArabicDigit)
%% about
%   классификация  с помощью HMM pmtk library - обучение модели

%% load train data
fprintf('..........Start train\n');


%%
dataTrainArabicDigitKox = cell(1,1);
dataTrainArabicDigitKox =  dataTrainArabicDigit;
%% 14-ой размерность вставляем принадлежность к кластеру
load net2;
% вывод номеров кластеров, которым принадлежат обучающие отчеты в файл
for i=1:size(dataTrainArabicDigit,1)
    for j=1:size(dataTrainArabicDigit,2)
       % for k=1:size(dataTrainArabicDigit{i,j},2)            
          %  p = sim(net2,dataTrainArabicDigit{i,j}(:,k));
            p = sim(net2,dataTrainArabicDigit{i,j});
            pp = vec2ind(p);      
            dataTrainArabicDigitKox{i,j}(14,:) = pp;   
       % end;
    end;
end;
weights = net2.iw{1,1};
%% 15-ой размерность вставляем расстояние между кластерами
% load distanseKox;
% load Probab;
% maxVs = size(distanseKox,2);
% for i=1:size(dataTrainArabicDigitKox,1)
%     for j=1:size(dataTrainArabicDigitKox,2)
%         %dataTrainArabicDigitKox{i,j}(15,1) = 0;
%         for k=1:size(dataTrainArabicDigitKox{i,j},2)           
%             p = dataTrainArabicDigitKox{i,j}(14,k);
%             q = dataTrainArabicDigitKox{i,j}(14,k);
%             
%             if p == q
%                 temp = 1;
%             else
%                 if p == maxVs
%                     temp = distanseKox(p,q);
%                      if temp == 0
%                         temp = distanseKox(q,p);
%                     end;
%                 end;
%                 if q == maxVs
%                     temp = distanseKox(q,p);
%                      if temp == 0
%                         temp = distanseKox(p,q);
%                     end;
%                 end;
%                 if p ~= maxVs && q ~=maxVs
%                     temp =  distanseKox(p,q);
%                     if temp == 0
%                         temp = distanseKox(q,p);
%                     end;
%                 end;
%             end;           
%             % sumProb = Probab(1,p) + Probab(1,q);
%             dataTrainArabicDigitKox{i,j}(15,k) =Probab(1,p); %temp; %log(sumProb)/temp;
%             
%         end;
%         
%     end;
% end;
for i=1:size(dataTrainArabicDigitKox,1)
    for j=1:size(dataTrainArabicDigitKox,2)
        % p = dataTrainArabicDigitKox{i,j}(14,1);
        % hhh = weights(p,:)';
        %dataTrainArabicDigitKox{i,j}(16:18,1) = hhh;          
       %for k=1:size(dataTrainArabicDigitKox{i,j},2)
            p = dataTrainArabicDigitKox{i,j}(14,:);
          %  q = dataTrainArabicDigitKox{i,j}(14,k+1);
            hhh = weights(p,:)';
          %  ggg = weights(q,:)';            
            dataTrainArabicDigitKox{i,j}(16:18,:) =hhh; %(hhh -ggg).^2;
          % dataTrainArabicDigitKox{i,j}(16:18,k) =sign(dataTrainArabicDigitKox{i,j}(1:3,k)).*sqrt(abs(dataTrainArabicDigitKox{i,j}(1:3,k))); %(hhh -ggg).^2;
       % end;        
    end;
end;
for i=1:size(dataTrainArabicDigitKox,1)
    for j=1:size(dataTrainArabicDigitKox,2)  
      dataTrainArabicDigitKox{i,j}(15,:) = [];
      dataTrainArabicDigitKox{i,j}(4:14,:) = [];   
    end;        
end;
%%
dataTrain = cell(1,1);
k = 1;
for i=1:size(dataTrainArabicDigit,1)
    for j=1:size(dataTrainArabicDigit,2)
        dataTrain{k,1} = dataTrainArabicDigitKox{i,j};       
        labelTrain(k,1) = i-1;              
        k = k+1;
    end;
end;

%% train
pi0 = [1, 0, 0, 0, 0, 0, 0];
transmat0 = normalize(diag(ones(nstates, 1)) + ...
            diag(ones(nstates-1, 1), 1), 2);
%fitArgs = {'pi0', pi0, 'trans0', transmat0, 'maxIter', 100, 'verbose', true};
 %nmix    = 3; 
 %fitArgs = [fitArgs, {'nmix', nmix}];
 %fitFn   = @(X)hmmFit(X, nstates, 'mixGaussTied', fitArgs{:}); 
  fitArgs = {'pi0', pi0, 'trans0', transmat0, 'maxIter', 100, 'verbose', true};
 fitFn   = @(X)hmmFit(X, nstates, 'gauss', fitArgs{:}); 
model = generativeClassifierFit(fitFn, dataTrain, labelTrain);



fprintf('..........Stop train\n');
