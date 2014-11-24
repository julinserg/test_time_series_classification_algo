clc;
clear;



load sampleData;
isOpen = matlabpool('size') > 0;
if isOpen
   matlabpool close; 
end;
matlabpool open local 8;
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
% 10*10 - 100 texture
% Average Pricision  = 0.907435
% Average Recall  = 0.889120
% F-measure  = 0.898184
% Average Pricision  = 0.749645
% Average Recall  = 0.644676
% F-measure  = 0.693209
USETRAIN = 0
k = 1;
dataTrainRaw = getTrainData(1);
for i=1:size(dataTrainRaw,1)
    for j=1:size(dataTrainRaw,2)
        dataTrain{k,1} = dataTrainRaw{i,j};
        labelTrain(k,1) = i-1; 
        k = k+1;
    end;
end;

%% обучаем карты Кохонена для каждого класса 
if USETRAIN == 1
k_1 = 1;
k_2 = 1;
row = 32;
col = 32;
epohs = 500;
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
  distArray = calculateDist(net);
  GraphGmodelG{i} = distArray;
  GraphWmodelW{i} = sparse(distArray > 0);
end;
save('modelKohonen.mat', 'cellNetKox');
save('GraphGmodelG.mat','GraphGmodelG');
save('GraphWmodelW.mat','GraphWmodelW');

%% вычисляем матрицу А (матрицу выходов) для каждого класса
Probability = cell(size(cellNetKox,1),1);
DistKohonen = cell(size(cellNetKox,1),1);
for i=1:size(cellNetKox,1);
    sizeW = size(cellNetKox{i}.iw{1,1},1);
    Probability{i}.A = repmat(0,sizeW,sizeW);
    Probability{i}.At = repmat(0,sizeW,1);
end;

index = 1;
numNeurons = size(cellNetKox{i}.iw{1,1},1);
neighborsold = repmat(0,numNeurons,numNeurons);
for i=1:size(dataTrainRaw,1)   
    for j=1:size(dataTrainRaw,2)        
           array = sim(cellNetKox{i},dataTrainRaw{i,j});          
          
           array = vec2ind(array);             
            
           
            index = index + 1;
           for k=1:size(array,2)-1
                pp = array(1,k);
                qq = array(1,k+1);                
                Probability{i}.A(pp,qq) = Probability{i}.A(pp,qq) + 1; %+ neighbors(pp,qq) ;                
                Probability{i}.At(pp)  = Probability{i}.At(pp) + 1;

            end;

    end;
end;
save('ProbabilityTransaction.mat','Probability');
end;
load modelKohonen;
load ProbabilityTransaction;
load GraphGmodelG;
load GraphWmodelW;
val = 0;
for i=1:size(Probability,1)
    for j =1:size(Probability{i}.A,2)
        if Probability{i}.At(j) ~= 0         
          vecSumDir = repmat(val,1,size(Probability{i}.A,2));
          Probability{i}.A(j,:) = (Probability{i}.A(j,:)+vecSumDir) ./ (Probability{i}.At(j)+(val*size(Probability{i}.A,2)));
        else
          vecSumDir = repmat(val,1,size(Probability{i}.A,2));
          if val ~= 0             
         	Probability{i}.A(j,:) = vecSumDir ./ (val*size(Probability{i}.A,2));
          end;
        end;        
    end;
end;

%% тест
arrayLogLikDataSetTest = cell(1,1);
dataTest =  getTrainData(1);

for i=1:size(dataTest,1)
    for j=1:size(dataTest,2)       
        labelTest{i,j}(1,1) = i-1;        
    end;
end;
index = 1;
for i = 1:size(dataTest,1)
  for j = 1:size(dataTest,2)    
     p = dataTest{i,j};
    parfor m = 1:size(cellNetKox,1)
       w= cellNetKox{m}.iw{1,1};       
       [S,R11] = size(w);
       [R2,Q] = size(p);
       z = zeros(S,Q);
       w = w';
       copies = zeros(1,Q);
       for ii=1:S
         z(ii,:) = sum((w(:,ii+copies)-p).^2,1); % l2-norm
       % z(ii,:) = sum(abs(w(:,ii+copies)-p),1); % l1 -norm
       end;
       z = -z.^0.5;
      % z = -z;
       n= z;
      [maxn,rows] = max(z,[],1);
       Ar = repmat(0,size(GraphGmodelG{m},1),size(GraphGmodelG{m},2));
       Ar(:,rows) = GraphGmodelG{m}(:,rows);
       GraphG = Ar;
       GraphW = sparse(GraphG > 0);
       neighbors = tril(cellNetKox{m}.layers{1}.distances <= 1.001) - eye(S);
       arrayLLFldVec(index,m) = matchingGraphs(neighbors,GraphGmodelG{m},GraphWmodelW{m},GraphG,GraphW);      
            
               

      [logB scale] = normalizeLogspace(n');      
       B = exp(logB');
       %B = logB';
       pi = repmat(5,1,size(w',1));
       pi(1,rows(1,1)) = 10;
       pi = normalizeLogspace(pi);
       pi = exp(pi);
       A =  Probability{m}.A;
       [alpha, logp] = FilterFwdC(A,B,pi);
       logp = logp + sum(scale);     
       arrayLL(index,m) = logp;
      % arrayLL(index,m) = sumLik + sum(scale);
    end;
    index = index + 1;
  end;
end;
save('arrayLogLikDataSetTest.mat', 'arrayLogLikDataSetTest');
%arrayLL = exp(normalizeLogspace(arrayLL));
arrayLL = arrayLL';
for i=1:size(arrayLL,2)
    [c index] = max(arrayLL(:,i));
     arrayLabelDetect(1,i) = index-1; 
     HHl(1,i) = c;
end;
arrayLLFldVec = arrayLLFldVec';
for i=1:size(arrayLLFldVec,2)
    [c index] = max(arrayLLFldVec(:,i));
     arrayLabelDetectLaplas(1,i) = index-1;   
     HHfg(1,i) = c;
end;
for i =1:size(labelTest,1)
    for j=1:size(labelTest,2)
     arrayLabelTrue(1,(i-1)*size(labelTest,2)+j) = labelTest{i,j}(1,1); 
    end;
end;
[ff,gg, fmear,qual] = calculateQuality(arrayLabelDetect,arrayLabelTrue,size(arrayLL,1));
[ff,gg, fmear,qual] = calculateQuality(arrayLabelDetectLaplas,arrayLabelTrue,size(arrayLL,1));
save('lastTest.dat','-ascii','qual','-double');

%% объединение оубчением нейронной сети
% trainEnsemble = repmat(0,size(arrayLL,1)*2,size(arrayLL,2));
% for i=1:size(arrayLabelDetect,2)
%     %trainEnsemble(1:size(arrayLL,1),i) = -arrayLL(:,i)./sum(arrayLL(:,i));   
%     trainEnsemble(1:size(arrayLL,1),i) = arrayLL(:,i);
%     %trainEnsemble(size(arrayLL,1)+1:size(arrayLL,1)*2,i) = arrayLLFldVec(:,i)./sum(arrayLLFldVec(:,i));
%     trainEnsemble(size(arrayLL,1)+1:size(arrayLL,1)*2,i) = arrayLLFldVec(:,i);
% end;
% label = repmat(0,size(arrayLL,1),size(arrayLL,2));
% for i=1:size(arrayLabelTrue,2)
%     label(arrayLabelTrue(1,i)+1,i) = 1;
% end;
% %tree = classregtree(trainEnsemble',arrayLabelTrue','method','classification');
% %tree1 = TreeBagger(1,trainEnsemble',arrayLabelTrue','Method', 'classification');
% net = patternnet(size(arrayLL,1)*2);
% view(net)
% [net,tr] = train(net,trainEnsemble,label);
% nntraintool
% plotperform(tr)
%% Ensemble Toolbox
CLF_Train_output(1).Abstract_level_output = arrayLabelDetect;
CLF_Train_output(2).Abstract_level_output = arrayLabelDetectLaplas;
DP=mapminmax(arrayLL',0,1);
CLF_Train_output(1).Measurment_level_output = DP;
DP=mapminmax(arrayLLFldVec',0,1);
CLF_Train_output(2).Measurment_level_output = DP;
[temp,Ranked_class]=sort(arrayLL,'descend');
CLF_Train_output(1).Rank_level_output = Ranked_class;
[temp,Ranked_class]=sort(arrayLLFldVec,'descend');
CLF_Train_output(2).Rank_level_output = Ranked_class;
Confusion_Matrix = calculateQualityForEnsemble(arrayLabelDetect,arrayLabelTrue,size(arrayLL,1));
CLF_Train_output(1).ConfusionMatrix = Confusion_Matrix;
Confusion_Matrix = calculateQualityForEnsemble(arrayLabelDetectLaplas,arrayLabelTrue,size(arrayLL,1));
CLF_Train_output(2).ConfusionMatrix = Confusion_Matrix;

N_train = size(arrayLL,2);
TrainTargets = arrayLabelTrue;
clear('labelTest','dataTest','arrayLL','arrayLLFldVec','arrayLabelTrue','arrayLabelDetect','arrayLabelDetectLaplas');
%% тест
arrayLogLikDataSetTest = cell(1,1);
dataTest =  getTestDataOnTest(1);

for i=1:size(dataTest,1)
    for j=1:size(dataTest,2)       
        labelTest{i,j}(1,1) = i-1;        
    end;
end;
index = 1;
for i = 1:size(dataTest,1)
  for j = 1:size(dataTest,2)    
     p = dataTest{i,j};
    parfor m = 1:size(cellNetKox,1)
       w= cellNetKox{m}.iw{1,1};       
       [S,R11] = size(w);
       [R2,Q] = size(p);
       z = zeros(S,Q);
       w = w';
       copies = zeros(1,Q);
       for ii=1:S
         z(ii,:) = sum((w(:,ii+copies)-p).^2,1); % l2-norm
       % z(ii,:) = sum(abs(w(:,ii+copies)-p),1); % l1 -norm
       end;
       z = -z.^0.5;
      % z = -z;
       n= z;
      [maxn,rows] = max(z,[],1);
       Ar = repmat(0,size(GraphGmodelG{m},1),size(GraphGmodelG{m},2));
       Ar(:,rows) = GraphGmodelG{m}(:,rows);
       GraphG = Ar;
       GraphW = sparse(GraphG > 0);
       neighbors = tril(cellNetKox{m}.layers{1}.distances <= 1.001) - eye(S);
       arrayLLFldVec(index,m) = matchingGraphs(neighbors,GraphGmodelG{m},GraphWmodelW{m},GraphG,GraphW);      
            
               

      [logB scale] = normalizeLogspace(n');      
       B = exp(logB');
       %B = logB';
       pi = repmat(5,1,size(w',1));
       pi(1,rows(1,1)) = 10;
       pi = normalizeLogspace(pi);
       pi = exp(pi);
       A =  Probability{m}.A;
       [alpha, logp] = FilterFwdC(A,B,pi);
       logp = logp + sum(scale);     
       arrayLL(index,m) = logp;
      % arrayLL(index,m) = sumLik + sum(scale);
    end;
    index = index + 1;
  end;
end;
save('arrayLogLikDataSetTest.mat', 'arrayLogLikDataSetTest');
%arrayLL = exp(normalizeLogspace(arrayLL));
arrayLL = arrayLL';
for i=1:size(arrayLL,2)
    [c index] = max(arrayLL(:,i));
     arrayLabelDetect(1,i) = index-1;    
end;
arrayLLFldVec = arrayLLFldVec';
for i=1:size(arrayLLFldVec,2)
    [c index] = max(arrayLLFldVec(:,i));
     arrayLabelDetectLaplas(1,i) = index-1;    
end;
for i =1:size(labelTest,1)
    for j=1:size(labelTest,2)
     arrayLabelTrue(1,(i-1)*size(labelTest,2)+j) = labelTest{i,j}(1,1); 
    end;
end;
[ff,gg, fmear,qual] = calculateQuality(arrayLabelDetect,arrayLabelTrue,size(arrayLL,1));
[ff,gg, fmear,qual] = calculateQuality(arrayLabelDetectLaplas,arrayLabelTrue,size(arrayLL,1));
%% объединение оубчением нейронной сети
% testEnsemble = repmat(0,size(arrayLL,1)*2,size(arrayLL,2));
% for i=1:size(arrayLabelDetect,2)
%     testEnsemble(1:size(arrayLL,1),i) = -arrayLL(:,i)./sum(arrayLL(:,i));
%     testEnsemble(size(arrayLL,1)+1:size(arrayLL,1)*2,i) = arrayLLFldVec(:,i)./sum(arrayLLFldVec(:,i));
% end;
% %yPredicted = eval(tree, testEnsemble');
% %yPredicted1 = tree1.predict(testEnsemble');
% %yP = str2double(yPredicted);
% testY  = sim(net,testEnsemble);
% testIndices = vec2ind(testY);
% testIndicesL = testIndices-ones(1,size(testIndices,2));
% [ff,gg, fmear,qual] = calculateQuality(testIndicesL,arrayLabelTrue,size(arrayLL,1));
%% Ensemble Toolbox
CLF_Test_output(1).Abstract_level_output = arrayLabelDetect;
CLF_Test_output(2).Abstract_level_output = arrayLabelDetectLaplas;
DP=mapminmax(arrayLL',0,1);
CLF_Test_output(1).Measurment_level_output = DP;
DP=mapminmax(arrayLLFldVec',0,1);
CLF_Test_output(2).Measurment_level_output = DP;
[temp,Ranked_class]=sort(arrayLL,'descend');
CLF_Test_output(1).Rank_level_output = Ranked_class;
[temp,Ranked_class]=sort(arrayLLFldVec,'descend');
CLF_Test_output(2).Rank_level_output = Ranked_class;

CombinitionMethods=[1,2,3,4,5,6,7,8,9]; 
N_classifiers = 2;
N_test = size(arrayLL,2);
N_class = size(arrayLL,1);
TestTargets = arrayLabelTrue;
 for C=1:length(CombinitionMethods);
      CombinitionMethod=CombinitionMethods(C);
      Ensemble_decisions=CombineCLFs(CombinitionMethod,...
        CLF_Train_output,CLF_Test_output,N_classifiers,N_test,N_train,N_class,TrainTargets);
      Accuracy_fold_Ensemble(C)=sum(Ensemble_decisions'==TestTargets)/N_test;
 end
Accuracy_Ensemble= mean(Accuracy_fold_Ensemble,1);      %N_runs * N_combinationMethods 