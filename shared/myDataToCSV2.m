clc;
clear;
display('Start');
%%
UCIDATASET = 2;
trainData = getTrainData(1,UCIDATASET);
testData = getTestData(1,UCIDATASET);
%%
namefolder = 'TestCharacter';
DataGrid = testData;
%%
mkdir(namefolder);
namefile_s1 = 'cl_';
namefile_s2 = '_i_';
namefile_s3 = '.csv';
for i=1:size(DataGrid,1)
    for j=1:size(DataGrid,2)
        data = DataGrid{i,j}'; 
        nameCl = int2str(i);
        if (size(nameCl) < 3)
            while (size(nameCl) < 3)
                nameCl = ['0' nameCl];
            end;
        end;
        nameI = int2str(j);
        if (size(nameI) < 6)
            while (size(nameI) < 6)
                nameI = ['0' nameI];
            end;
        end;
         
        namefile = [namefile_s1 nameCl namefile_s2 nameI namefile_s3];
        dlmwrite([namefolder '/' namefile], data, 'delimiter', ',', 'precision', 9); 
    end;
end;

display('Stop');


