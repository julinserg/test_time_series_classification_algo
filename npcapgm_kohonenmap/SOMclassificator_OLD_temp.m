clc;
clear;
load sampleData;
isOpen = matlabpool('size') > 0;
if isOpen
   matlabpool close; 
end;
matlabpool open local 12;
%load initDataTransHMMtoHCRF
%paramsData.weightsPerSequence = ones(1,128) ;
%paramsData.factorSeqWeights = 1;
%%
% 9*9 speech
%Average Pricision  = 0.922588
%Average Recall  = 0.915909
%F-measure  = 0.919237
%%
% 32*32 speech
% Average Pricision  = 0.939600
% Average Recall  = 0.936364
% F-measure  = 0.937979
%%
USETRAIN = 1
k = 1;
dataTrainRaw = getTrainData(1);
for i=1:size(dataTrainRaw,1)
    for j=1:size(dataTrainRaw,2)
        dataTrain{k,1} = dataTrainRaw{i,j};       
        labelTrain(k,1) = i-1; 
        k = k+1;
    end;
end;
% sizeTrain = 10;
% DATAT = dataTrainRaw;
% clear('dataTrainRaw');
% countTrainIter = 0;
%while sizeTrain <= 90
%     dataTrainRaw = DATAT(:,1:sizeTrain);
%     countTrainIter = countTrainIter + 1;
%     sizeTrain = sizeTrain + 10;
%     clear('Probability','arrayLL','arrayLabelDetect','arrayLabelTrue');
%% обучаем карты  охонена дл€ каждого класса 
if USETRAIN == 1
k_1 = 1;
k_2 = 1;
row = 10;
col = 10;
epohs = 600;
dataTrainForClass = cell(size(dataTrainRaw,1),1);
for i=1:size(dataTrain,1)  
    u = size(dataTrain{i},2);
    a = dataTrain{i};
    t = size(dataTrainForClass{labelTrain(i)+1},2) +1;        
    dataTrainForClass{labelTrain(i)+1}(:,t:t+u-1) = a;       
    k_1 = k_1+size(a,2);  
end; 
cellNetKox = cell(size(dataTrainRaw,1),1);
parfor i=1:size(dataTrainForClass,1)
  i
  net = newsom(dataTrainForClass{i},[row col],'hextop','dist');
  net.trainParam.epochs = epohs;
  [net,tr] = train(net,dataTrainForClass{i}); 
  cellNetKox{i} = net;
end;
save('modelKohonen.mat', 'cellNetKox');

%%

% %% вычисл€ем матрицу B (матрицу выходов) дл€ каждого класса
% outputs = sim(net_class1,dataTrain_class1);
% hits = sum(outputs,2);
% numNeurons = net_class1.layers{1}.size;
% for i=1:numNeurons
%   Probab_class1(i) = hits(i);
% end
% sumN = sum(Probab_class1);
% Probab_class1 = Probab_class1/sumN;
% 
% outputs = sim(net_class2,dataTrain_class2);
% hits = sum(outputs,2);
% numNeurons = net_class2.layers{1}.size;
% for i=1:numNeurons
%   Probab_class2(i) = hits(i);
% end
% sumN = sum(Probab_class2);
% Probab_class2 = Probab_class2/sumN;
% Probab_class1 = normalizeLogspace(Probab_class1);
% Probab_class1 = exp(Probab_class1);
% Probab_class2 = normalizeLogspace(Probab_class2');
% Probab_class2 = exp(Probab_class2');
%% вычисл€ем матрицу ј (матрицу выходов) дл€ каждого класса
% weights_class1 = net_class1.iw{1,1};
% weights_class2 = net_class2.iw{1,1};
Probability = cell(size(cellNetKox,1),1);
for i=1:size(cellNetKox,1);
    sizeW = size(cellNetKox{i}.iw{1,1},1);
    Probability{i}.A = repmat(0,sizeW,sizeW);
    Probability{i}.At = repmat(0,sizeW,1);
end;
%A_1 = repmat(0,size(weights_class1,1),size(weights_class1,1));
%A_2 = repmat(0,size(weights_class1,1),size(weights_class1,1));
%countTrans_1 = 0;
%countTrans_2 = 0;
for i=1:size(dataTrainRaw,1)
    for j=1:size(dataTrainRaw,2)
        %for k=1:size(dataTrainRaw{i,j},2)-1            
            array = sim(cellNetKox{i},dataTrainRaw{i,j});
            distArray = calculateDist(cellNetKox{i});
            numNeurons = size(cellNetKox{i}.iw{1,1},1);
            neighbors = sparse(tril(cellNetKox{i}.layers{1}.distances <= 1.001) - eye(numNeurons));
            array = vec2ind(array);
            for k=1:size(array,2)-1
                pp = array(1,k);
                qq = array(1,k+1);
%                 if 1 == 1
%                     Probability{i}.A(pp,qq) = 1; 
%                 end;
                Probability{i}.A(pp,qq) = Probability{i}.A(pp,qq) + 1; %+ neighbors(pp,qq) ;                
                Probability{i}.At(pp)  = Probability{i}.At(pp) + 1;
%                 for ff=find(neighbors(pp,:))                   
%                     Probability{i}.A(ff,qq) = Probability{i}.A(ff,qq) + 1;
%                     Probability{i}.At(ff)  = Probability{i}.At(ff) + 1;
%                 end
            end;
%             pp = vec2ind(pr);              
%             pr = sim(cellNetKox{i},dataTrainRaw{i,j}(:,k+1));
%             qq = vec2ind(pr);
%             Probability{i}.A(pp,qq) = Probability{i}.A(pp,qq) + 1;       
       % end;
    end;
end;
%A_1 = A_1./countTrans_1;
%A_2 = A_2./countTrans_2;
save('ProbabilityTransaction.mat','Probability');
end;
load modelKohonen;
load ProbabilityTransaction;
val = 0;
for i=1:size(Probability,1)
    for j =1:size(Probability{i}.A,2)
        if Probability{i}.At(j) ~= 0
          %Probability{i}.A(j,:) = Probability{i}.A(j,:) ./Probability{i}.At(j);
          vecSumDir = repmat(val,1,size(Probability{i}.A,2));
          Probability{i}.A(j,:) = (Probability{i}.A(j,:)+vecSumDir) ./ (Probability{i}.At(j)+(val*size(Probability{i}.A,2)));
        else
          vecSumDir = repmat(val,1,size(Probability{i}.A,2));
          if val ~= 0             
         	Probability{i}.A(j,:) = vecSumDir ./ (val*size(Probability{i}.A,2));
          end;
        end;
%         sumRow = sum(Probability{i}.A(:,j));
%         if sumRow ~= 0
%             devide = Probability{i}.A(:,j) ./ sumRow;
%         end;
%         %devide(~devide) = 0.001;
%         Probability{i}.A(:,j) = devide;
        
    end;
%     minVal = 1;
%     for m=1:size(Probability{i}.A,1)
%         for n = 1:size(Probability{i}.A,2)
%             if Probability{i}.A(m,n) < minVal && Probability{i}.A(m,n) ~= 0
%                minVal = Probability{i}.A(m,n);  
%             end;
%         end;
%     end;
   % Probability{i}.A(~Probability{i}.A) = 0.0000001;
     %Probability{i}.A = ones(size(Probability{i}.A,2),size(Probability{i}.A,2));
    %logA = normalizeLogspace(Probability{i}.A);
    %Probability{i}.A = exp(logA);
end;
% logA1 = normalizeLogspace(A_1);
% A_1 = exp(logA1);
% logA2 = normalizeLogspace(A_2);
% A_2 = exp(logA2);
%A_1(~A_1) = 0.000001;
%A_2(~A_2) = 0.000001;

%% тест
arrayLogLikDataSetTest = cell(1,1);
%dataTest =  getTestDataOnTest(1);
dataTest = getTestDataOnTrain(1);
%dataTest = getTestDataOnTest(4);
for i=1:size(dataTest,1)
    for j=1:size(dataTest,2)       
        labelTest{i,j}(1,1) = i-1; 
        k = k+1;
    end;
end;
index = 1;
for i = 1:size(dataTest,1)
  for j = 1:size(dataTest,2)
    for m = 1:size(cellNetKox,1)
       w= cellNetKox{m}.iw{1,1};
       p = dataTest{i,j};
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
%         for tt =1:size(n,2)
%             summaRow = sum(n(tt,:));
%             if summaRow ~= 0
%                 devide = n(tt,:) ./ summaRow;
%             end;
%             devide(~devide) = 0.00001;
%             n(tt,:) = devide;
%         end;
%         B = n;
       [logB scale] = normalizeLogspace(n');
       %Index = find(n(:,1));
       %[logB scale] = normalizeTraps(n',Index');
       B = exp(logB');
       %B = logB';
       pi = repmat(5,1,size(w',1));
       pi(1,rows(1,1)) = 10;
       pi = normalizeLogspace(pi);
       pi = exp(pi);
       A =  Probability{m}.A;
%        resP = log(B(rows(1,1),1));
%        for li=2:size(rows,2)
%          t_cur = rows(1,li);
%          t_prev = rows(1,li-1);
%          resP = resP + log(A(t_prev,t_cur)) + log(B(t_cur,li));
%        end;
%        logp =resP;
       logp = hmmFilter(pi, A, B);
       %logp = 0;
       %L = logsumexp(scale', 2);
       logp = logp + sum(scale);     
       arrayLL(index,m) = logp;          
    end;   

    index = index + 1;
  end;
end;
save('arrayLogLikDataSetTest.mat', 'arrayLogLikDataSetTest');
%arrayLL = exp(normalizeLogspace(arrayLL));
arrayLL = arrayLL'
for i=1:size(arrayLL,2)
    [c index] = max(arrayLL(:,i));
     arrayLabelDetect(1,i) = index-1;    
end;
for i =1:size(labelTest,1)
    for j=1:size(labelTest,2)
     arrayLabelTrue(1,(i-1)*size(labelTest,2)+j) = labelTest{i,j}(1,1); 
    end;
end;
[ff,gg, fmear] = calculateQuality(arrayLabelDetect,arrayLabelTrue,size(arrayLL,1));

ListFmera(1,countTrainIter) =  fmear;

%end;
 index1 = 1;
 index2 = 1;
 count1_1 = 0;
  count1_2 = 0;
   count2_1 = 0;
    count2_2 = 0;
 for i=1:size(rows_1,2)     
%      if testLabels{1}(1,i) == 0
%          if rows(1,i) > size(weights_class1,1)
%             mas0(1,index1) = 2;
%             count1_2 = count1_2 + 1;
%            % testSeqs{1}(4,i) = 1;
%          else
%             mas0(1,index1) = 1; 
%             count1_1 = count1_1 + 1;
%            % testSeqs{1}(4,i) = 0;
%          end;
%          
%          testSeqs{1}(4,i) = 1;
%          index1 = index1+ 1;
%      end;
%       if testLabels{1}(1,i) == 1
%           if rows(1,i) > size(weights_class1,1)
%             mas1(1,index2) = 2;
%             count2_2 = count2_2 + 1;
%             %testSeqs{1}(4,i) = 1;
%           else
%              count2_1 = count2_1 + 1;
%             mas1(1,index2) = 1; 
%             %testSeqs{1}(4,i) = 0;
%          end;
%          testSeqs{1}(4,i) = 2;
%          index2 = index2+ 1;
%      end;
     masProbab(1,i)= Probab_class1(rows_1(1,i));
     masProbab(2,i)= Probab_class2(rows_2(1,i));
 end;
 fprintf('Count 1 for 1 class  = %f\n', count1_1/size(mas0,2));
 fprintf('Count 2 for 1 class  = %f\n', count1_2/size(mas0,2));
  fprintf('Count 1 for 2 class  = %f\n', count2_1/size(mas1,2));
 fprintf('Count 2 for 2 class  = %f\n', count2_2/size(mas1,2));
%  testSeqs{1,1}(15,:) = [];
% testSeqs{1,1}(4:14,:) = []; 
% for i=1:size(d,2)
%     for k=1:size(w,1)
%         for l =1:size(w,2)
%             dist(k,l) = w()
%         end;
%     end;    
%     dist = weights - (cop+);
% end;







paramsNodHCRF.normalizeWeights = 1;
R{2}.params = paramsNodHCRF;
R{2}.params.nbHiddenStates = 3;
R{2}.params.modelType = 'hcrf';
R{2}.params.GaussianHCRF = 0;
%R{2}.params.windowRecSize = 0;
R{2}.params.windowSize = 0;
R{2}.params.optimizer = 'bfgs';
R{2}.params.regFactorL2 = 1;
R{2}.params.regFactorL1 = 0;
%R{2}.params.weightsInitType = 'TRANS_HMM';
%R{2}.params.initWeights = initDataTransHMMtoHCRF;
for i =1:10
    i
[R{2}.model R{2}.stats] = train(trainCompleteSeqs, trainCompleteLabels, R{2}.params);
[R{2}.ll R{2}.labels] = test(R{2}.model, testSeqs, testLabels);

% paramsNodLDCRF.normalizeWeights = 1;
% R{3}.params = paramsNodLDCRF;
% [R{3}.model R{3}.stats] = train(trainSeqs, trainLabels, R{3}.params);
% [R{3}.ll R{3}.labels] = test(R{3}.model, testSeqs, testLabels);


%% оценка результата
ll = R{2}.ll{1,1};
label = R{2}.labels{1,1};
% for i=1:size(label,2)
%     if label(1,i) == 0
%         arrayLabel(1,i) = 1;
%         arrayLabel(2,i) = 0;
%     else
%         arrayLabel(1,i) = 0;
%         arrayLabel(2,i) = 1;
%     end;   
% end;
 arrayLL = ll;
% arrayLL_old = arrayLL';
% post = exp(normalizeLogspace(arrayLL_old));
% arrayLL = post';

for i=1:size(arrayLL,2)
    [c index] = max(arrayLL(:,i));
     arrayLabelDetect(1,i) = index-1;    
end;

D = now();
strTime = datestr(D,30);
[AveragePricision, AverageRecall, F_measure] =calculateQuality(arrayLabelDetect,label,2);
end;
%plotResults(R);
