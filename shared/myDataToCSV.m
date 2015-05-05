clc;
clear;
display('Start');

trainData = getTrainData(1);
testData = getTestDataOnTest(1);



index = 1;
seq = 1;

for i=1:size(trainData,1)
    for j=1:size(trainData,2)
        for k=1:size(trainData{i,j},2)
            trainDataForCSV(index,1) = index;
            trainDataForCSV(index,2) = seq;
            trainDataForCSV(index,3) = i;
            data = trainData{i,j}(:,k)';
          
            trainDataForCSV(index,4:3+size(data,2)) = data;            
            index = index + 1;         
        end;       
        seq = seq + 1;        
    end;
end;

index = 1;
seq = 1;
for i=1:size(testData,1)
    for j=1:size(testData,2)
        for k=1:size(testData{i,j},2)
            testDataForCSV(index,1) = index;
            testDataForCSV(index,2) = seq;
            testDataForCSV(index,3) = i;
            data = testData{i,j}(:,k)'; 
            testDataForCSV(index,4:3+size(data,2)) = data;           
            index = index + 1;
        end;       
        seq = seq + 1;        
    end;
end;
dlmwrite('TrainAccelerometer.csv', trainDataForCSV, 'delimiter', ',', 'precision', 9); 
dlmwrite('TestAccelerometer.csv', testDataForCSV, 'delimiter', ',', 'precision', 9);

display('Stop');
