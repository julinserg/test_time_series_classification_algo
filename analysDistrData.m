clc;
clear;
UCIDATASET = 1;
TRAINFOLDSIZE = 660;

dataTrainUCI = getTrainData(1,UCIDATASET);
dataTrainRaw = dataTrainUCI(:,1:TRAINFOLDSIZE);

k = 1;
for i=1:size(dataTrainRaw,1)
    for j=1:size(dataTrainRaw,2)
        dataTrain{k,1} = dataTrainRaw{i,j};
        labelTrain(k,1) = i-1; 
        k = k+1;
    end;
end;

k_1 = 1;
dataTrainForClass = cell(size(dataTrainRaw,1),1);
for i=1:size(dataTrain,1)  
    u = size(dataTrain{i},2);
    a = dataTrain{i};
    t = size(dataTrainForClass{labelTrain(i)+1},2) +1;        
    dataTrainForClass{labelTrain(i)+1}(:,t:t+u-1) = a;       
    k_1 = k_1+size(a,2);  
end;

%% /////////////////////////////////
A = dataTrainForClass{1,1};
patterns = A(:,:)';
for i=1:size(patterns,2)
   minV = min(patterns(:,i));
   maxV = max(patterns(:,i));
   patterns(:,i) = (patterns(:,i) - minV) / (maxV - minV); 
end;
save('saveDataGMM','patterns');
patterns = patterns(1:2000,:);
%Roystest(patterns);
%HZmvntest(patterns);
Mskekur(patterns,1);
x = A(1,:);
minX = min(x);
maxX = max(x);
x = (x - minX) / (maxX - minX);
dfittool(x)
%% \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\