function data=getRawData(dataTrainUCI, class, sizeData)
k = 1;
for i=1:size(dataTrainUCI,1)
    for j=1:size(dataTrainUCI,2)
        dataTrain{k,1} = dataTrainUCI{i,j};
        labelTrain(k,1) = i-1; 
        k = k+1;
    end
end
k_1 = 1;
dataTrainForClass = cell(size(dataTrainUCI,1),1);
for i=1:size(dataTrain,1)  
    u = size(dataTrain{i},2);
    a = dataTrain{i};
    t = size(dataTrainForClass{labelTrain(i)+1},2) +1;        
    dataTrainForClass{labelTrain(i)+1}(:,t:t+u-1) = a;       
    k_1 = k_1+size(a,2);  
end
%A = cell2mat( dataTrainForClass' );
A = dataTrainForClass{class, 1};
A = A';
data = A(randperm(size(A, 1)), :);
%for i=1:size(data,2)
%   minV = min(data(:,i));
%   maxV = max(data(:,i));
%   data(:,i) = (data(:,i) - minV) / (maxV - minV); 
%end

if size(data,1) > sizeData
    data = data(1:sizeData,:);
end
