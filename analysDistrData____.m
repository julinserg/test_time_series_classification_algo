clc;
clear;
UCIDATASET = 11;
TRAINFOLDSIZE = 1;
load dataTrainTelemF.mat
dataTrainUCI = dataTrainTelem;
dataTrainRaw = dataTrainUCI;
%dataTrainRaw = dataTrainUCI(:,1:TRAINFOLDSIZE);
%dataTrainRaw = {dataTrainUCI{1,1} dataTrainUCI{2,1} dataTrainUCI{3,1} dataTrainUCI{4,1} dataTrainUCI{5,1} dataTrainUCI{6,1} dataTrainUCI{8,1} dataTrainUCI{8,1} dataTestUCI{1,1} dataTestUCI{2,1} dataTestUCI{3,1} dataTestUCI{4,1} dataTestUCI{5,1} dataTestUCI{6,1} dataTestUCI{7,1} dataTestUCI{8,1}};
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
patterns = patterns(1:5000,4:7);
patterns_diff = diff(patterns);
i = 1;
while i<=size(patterns_diff,1)
   if patterns_diff(i,1)<0 || patterns_diff(i,2)<0 || patterns_diff(i,1) > 0.001 || patterns_diff(i,2) > 0.001
      patterns_diff(i,:) = [];
      i = 0;
   end
   i = i+1;
end
patterns_diff = patterns_diff(1:726,:);
%Roystest(patterns);
%HZmvntest(patterns);
Mskekur(patterns_diff,1);
x = patterns_diff(:,1);
minX = min(x);
maxX = max(x);
x = (x - minX) / (maxX - minX);
dfittool(x)
%% \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\