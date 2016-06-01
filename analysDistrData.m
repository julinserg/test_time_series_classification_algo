clc;
clear;
UCIDATASET = 13;
TRAINFOLDSIZE = 80;

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
A = dataTrainRaw{1,1};
patterns = A(3:4,:)';
minV1 = min(patterns(:,1));
maxV1 = max(patterns(:,1));
patterns(:,1) = (patterns(:,1) - minV1) / (maxV1 - minV1);
minV2 = min(patterns(:,2));
maxV2 = max(patterns(:,2));
patterns(:,2) = (patterns(:,2) - minV2) / (maxV2 - minV2);
save('saveDataGMM','patterns');
X = A(5,:);
minX = min(X);
maxX = max(X);
X = (X - minX) / (maxX - minX);
dfittool(X)
%% \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\