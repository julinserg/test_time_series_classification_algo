function [D] = getTestDataOnTrain(NUMBER)
SELECTDATASET = 2;
if SELECTDATASET == 1
%% arabic digit
 load dataTrainArabicDigit;
 dataTrainArabicDigit = dataTrainArabicDigit(1:5,1:50);
 D = dataTrainArabicDigit;
end;
if SELECTDATASET == 2
  %% hendwrite character
load mixoutALL_shifted;

mixoutNew = cell(1,1);
mixoutNew{1,1} = mixout{1,1};
il = 1;
jl = 1;
for i=2:size(consts.charlabels,2)
    if consts.charlabels(i) == consts.charlabels(i-1) 
       k = 1;
        for j=1:size(mixout{1,i},2)
            if ~(mixout{1,i}(1,j) == 0 && mixout{1,i}(2,j) == 0 && mixout{1,i}(3,j) == 0)
                arr(:,k) = mixout{1,i}(:,j);
                k = k+1;
            end;
        end;
       mixoutNew{il,jl} = arr; 
       jl = jl + 1;
    else
       il = il + 1;
       jl = 1;   
       k = 1;
        for j=1:size(mixout{1,i},2)
            if ~(mixout{1,i}(1,j) == 0 && mixout{1,i}(2,j) == 0 && mixout{1,i}(3,j) == 0)
                arr(:,k) = mixout{1,i}(:,j);
                k = k+1;
            end;
        end;
        mixoutNew{il,jl} = arr; 
    end;    
end;
D = mixoutNew(1:20,1:50);
D(1:20,51:100) = mixoutNew(21:40,1:50);
if NUMBER == 1
   D = D(1:20,1:20);
end;
if NUMBER == 2
   D = D(:,11:20);
end;
if NUMBER == 3
   D = D(:,21:30);
end;
if NUMBER == 4
   D  = D(:,31:40);
end;
if NUMBER == 5
    D  = D(:,41:50);
end;
if NUMBER == 6
    D  = D(:,51:60);
end;
end;