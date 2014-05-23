clc;
clear all;
NUMBERPROPUSK =15;
USETRAIN = 1
SAVELOGLIKEFORGIBRID = 0
isOpen = matlabpool('size') > 0;
if isOpen
   matlabpool close; 
end;
matlabpool open local 4;
load sampleData;

%load initDataTransHMMtoHCRF
%paramsData.weightsPerSequence = ones(1,128) ;
%paramsData.factorSeqWeights = 1;

k = 1;
dataTrainRaw = getTrainData(1);
for i=1:size(dataTrainRaw,1)
    for j=1:size(dataTrainRaw,2)
        dataTrain{k,1} = dataTrainRaw{i,j};       
        labelTrain(k,1) = i-1; 
        k = k+1;
    end;
end;
dataTest =  getTestDataOnTest(1);
if 1 == 1
CountNet = [10 12];
%% ������� ����� �������� ��� ������� ������ 
if USETRAIN == 1
k_1 = 1;
k_2 = 1;
countNeuron = 999999999999;
epohs = 500;
dataTrainForClass = cell(size(dataTrainRaw,1),1);
for i=1:size(dataTrain,1)  
    u = size(dataTrain{i},2);
    a = dataTrain{i};
    t = size(dataTrainForClass{labelTrain(i)+1},2) +1;        
    dataTrainForClass{labelTrain(i)+1}(:,t:t+u-1) = a;       
    k_1 = k_1+size(a,2);  
end; 
cellNetGas = cell(size(dataTrainRaw,1),1);
errorNeuralGas = cell(size(dataTrainRaw,1),1);

parfor i=1:size(dataTrainForClass,1)
  D = dataTrainForClass{i};
  netGas = gngExt(D',countNeuron,epohs);
 
  cellNetGas{i} = netGas;
end;
save('modelNeuronGas.mat', 'cellNetGas','-v7.3');
end;
%%
load modelNeuronGas;

clear('Probability','arrayLL','arrayLabelDetect','arrayLabelTrue');

Probability = cell(size(cellNetGas,1),1);
parfor i=1:size(cellNetGas,1);
    w = cellNetGas{i}.codeBook;
    sizeW = size(w,1);
    Probability{i}.A = repmat(0,sizeW,sizeW);
    Probability{i}.At = repmat(0,sizeW,1);
end;

for i=1:size(dataTrainRaw,1)
    for j=1:size(dataTrainRaw,2)          
            w= cellNetGas{i}.codeBook;
            p = dataTrainRaw{i,j};
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
            array = rows;
            for k=1:size(array,2)-1
                pp = array(1,k);
                qq = array(1,k+1);
                Probability{i}.A(pp,qq) = Probability{i}.A(pp,qq) + 1;
                Probability{i}.At(pp) =  Probability{i}.At(pp) + 1;
            end;     
    end;
end;

for i=1:size(Probability,1)
     for j=1:size(Probability{i}.A,2)
         if Probability{i}.At(j) ~= 0
            Probability{i}.A(j,:) = Probability{i}.A(j,:) ./  Probability{i}.At(j);
         end;
     end;     
     Probability{i}.A(~Probability{i}.A) = 0.0000001;    
end;

%% ����

%dataTest = getTrainData(1);
for i=1:size(dataTest,1)
    for j=1:size(dataTest,2)       
        labelTest{i,j}(1,1) = i-1; 
        k = k+1;
    end;
end;

index = 1;
for i = 1:size(dataTest,1)
  for j = 1:size(dataTest,2)
        for m = 1:size(cellNetGas,1)
           w= cellNetGas{m}.codeBook;            
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
           [logB scale] = normalizeLogspace(n');
           B = exp(logB');
           pi = repmat(5,1,size(w',1));
           pi(1,rows(1,1)) = 10;
           pi = normalizeLogspace(pi);
           pi = exp(pi);
           A =  Probability{m}.A;
           logp = hmmFilter(pi, A, B);
           logp = logp + sum(scale);     
           arrayLL(index,m) = logp;       
        end;
        index = index + 1;   
  end;
end;



index = 1;




%arrayLL = exp(normalizeLogspace(arrayLL));
arrayLL = arrayLL';
for i=1:size(arrayLL,2)
    [c index] = max(arrayLL(:,i));
     arrayLabelDetect(1,i) = index-1;    
end;
for i =1:size(labelTest,1)
    for j=1:size(labelTest,2)
     arrayLabelTrue(1,(i-1)*size(labelTest,2)+j) = labelTest{i,j}(1,1); 
    end;
end;
[aver prec fmera]= calculateQuality(arrayLabelDetect,arrayLabelTrue,size(arrayLL,1));


end;

CountSeq = size(dataTest,2);
NclassI = size(loglist{1},1);
NmodelI = length(loglist);
globDifAllSeq = repmat(0,NclassI,length(loglist));
b = 0;
e = 0;
for modelI=1:NmodelI   
    
      for classI=1:NclassI  
          b = e + 1;
          e = CountSeq*classI;
        for dataSeqI=b:e        
            sumAllLogLike = 0;

            for i =1:NclassI           
               sumAllLogLike = sumAllLogLike +  exp(loglist{modelI}(i,dataSeqI));          
            end;

            val = exp(loglist{modelI}(classI,dataSeqI));
            logSum = log(sumAllLogLike);
            difAllLogLike = log(val/ sumAllLogLike);
         globDifAllSeq(classI,modelI) =difAllLogLike; %globDifAllSeq(classI,modelI) + difAllLogLike; 
        end;
      end;   
end;
mmi = mean(globDifAllSeq,1);
for i=1:size(mmi,2)-1
    dmmi(i) = mmi(i+1)-mmi(i);
end;
[vaM in] = max(mmi);
plot(mmi);
fprintf('Stop');

