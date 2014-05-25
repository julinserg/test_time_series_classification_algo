clc;
clear;
% isOpen = matlabpool('size') > 0;
% if isOpen
%    matlabpool close; 
% end;
% matlabpool open local 12;
fprintf('Start form data');
WAVELETLEVEL = 5;
SIZE_N = 128;
rootdir = 'd:\Outex_TC_00012\';
Problem_STR = '001';
trainfile = strcat(rootdir,Problem_STR,'\','train.txt');

fid = fopen(trainfile);
filename = textscan(fid,'%s');
namelist = filename{1};
Num_Sample = str2num(namelist{1,1});
fclose(fid);

calssfile = strcat(rootdir,Problem_STR,'\','classes.txt');
fid = fopen(calssfile);
filename = textscan(fid,'%s');
namelistCL = filename{1};
Num_Class = str2num(namelistCL{1,1});
fclose(fid);

dataTrainTexture = cell(Num_Class,1);
dataTestTexture = cell(Num_Class,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Construct Training Labels
%        and sample list
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Labels_Train = [];
SampleList = [];

for index1 = 2:size(namelist,1)
    if(mod(index1,2)~=0)
        Labels_Train = [Labels_Train,str2num(namelist{index1,1})];
    else
        SampleList = [SampleList;namelist{index1,1}];
    end
end


imgpath = strcat(rootdir,'images');

[IndexZigzag] =  Generate_Zigzag(SIZE_N);
%IndexZigzag = IndexZigzag(1:100:end,:);
fprintf('....form tarin  data');
progress = size(SampleList,1);
curLableTrain = 0;
indexM = 1;
for index2 = 1:size(SampleList,1)
    str = strcat(imgpath,'/',SampleList(index2,:));
    for index3 = 1:WAVELETLEVEL
        strW = strcat(str,' WG');
        str_index = num2str(index3);
        str_index = strcat(32,str_index);
        strW = strcat(strW,str_index);
        strW = strcat(strW,'.txt');
        D = csvread(strW);       
        for index4 = 1: size(IndexZigzag,1)
            DataZigzag(index3,index4) =  D(IndexZigzag(index4,1),IndexZigzag(index4,2));  
        end;      
    end;  
    if curLableTrain ~= Labels_Train(index2)
        indexM = 1;
        curLableTrain = Labels_Train(index2);          
    end;
    DataZigzag = DataZigzag(:,1:81:end);
    dataTrainTexture{Labels_Train(index2)+1,indexM} = DataZigzag;
    indexM = indexM + 1;
    
    progress = progress - 1
end; 
    
testfile = strcat(rootdir,Problem_STR,'/','test.txt');
fid = fopen(testfile);
filename = textscan(fid,'%s');
namelist = filename{1};
Num_Sample = str2num(namelist{1,1});

Labels_Test = [];
SampleList = [];
for index1 = 2:size(namelist,1)
    if(mod(index1,2)~=0)
        Labels_Test = [Labels_Test,str2num(namelist{index1,1})];
    else
        SampleList = [SampleList;namelist{index1,1}];
    end
end

fclose(fid);
fprintf('....form test  data');
progress = size(SampleList,1);
curLableTest = 0;
indexM = 1;
for index2 = 1:size(SampleList,1)
    str = strcat(imgpath,'/',SampleList(index2,:));
    for index3 = 1:WAVELETLEVEL
        strW = strcat(str,' WG');
        str_index = num2str(index3);
        str_index = strcat(32,str_index);
        strW = strcat(strW,str_index);
        strW = strcat(strW,'.txt');
        D = csvread(strW);       
        for index4 = 1: size(IndexZigzag,1)
            DataZigzag(index3,index4) =  D(IndexZigzag(index4,1),IndexZigzag(index4,2));  
        end;      
    end;
    if curLableTest ~= Labels_Test(index2)
        indexM = 1;
        curLableTest = Labels_Test(index2);          
    end;
    DataZigzag = DataZigzag(:,1:81:end);
    dataTestTexture{Labels_Test(index2)+1,indexM} = DataZigzag;  
    indexM = indexM + 1;
    
    progress = progress - 1
    
end; 

save('dataTrainTexture.mat', 'dataTrainTexture','-v7.3');
save('dataTestTexture.mat', 'dataTestTexture','-v7.3');
fprintf('Stop form data');

    
    
    