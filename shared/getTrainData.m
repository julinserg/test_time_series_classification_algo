function [D] = getTrainData(NUMBER)
SELECTDATASET = 1;
if SELECTDATASET == 1
%% arabic digit
 load dataTrainArabicDigit;
 load dataTestArabicDigit;
 %dataTrainArabicDigit = dataTrainArabicDigit(1:5,1:50);
 D = dataTrainArabicDigit;
 M = dataTestArabicDigit;
 D = horzcat(D,M);
 if NUMBER == 1
  D = D(1:10,89:880);
  %D = D(1:20,1:50);
end;
if NUMBER == 2
  D = horzcat(D(1:10,1:88),D(1:10,177:880));
end;
if NUMBER == 3
  D = horzcat(D(1:10,1:176),D(1:10,265:880));
end;
if NUMBER == 4
   D = horzcat(D(1:10,1:264),D(1:10,383:880));
end;
if NUMBER == 5
  D = horzcat(D(1:10,1:352),D(1:10,441:880));
end;
if NUMBER == 6
  D = horzcat(D(1:10,1:440),D(1:10,529:880));
end;
if NUMBER == 7
  D = horzcat(D(1:10,1:528),D(1:10,617:880));
end;
if NUMBER == 8
   D = horzcat(D(1:10,1:616),D(1:10,705:880));
end;
if NUMBER == 9
   D = horzcat(D(1:10,1:704),D(1:10,793:880));
end;
if NUMBER == 10
  D = D(1:10,1:792);  
end;
end; 
if SELECTDATASET == 2
 %% hendwrite character
load mixoutALL_shifted;

mixoutNew = cell(1,1);
%mixoutNew{1,1} = mixout{1,1};
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
  D = D(1:20,11:100);
  %D = D(1:20,1:50);
end;
if NUMBER == 2
  D = horzcat(D(1:20,1:10),D(1:20,21:100));
end;
if NUMBER == 3
  D = horzcat(D(1:20,1:20),D(1:20,31:100));
end;
if NUMBER == 4
   D = horzcat(D(1:20,1:30),D(1:20,41:100));
end;
if NUMBER == 5
  D = horzcat(D(1:20,1:40),D(1:20,51:100));
end;
if NUMBER == 6
  D = horzcat(D(1:20,1:50),D(1:20,61:100));
end;
if NUMBER == 7
   D = horzcat(D(1:20,1:60),D(1:20,71:100));
end;
if NUMBER == 8
   D = horzcat(D(1:20,1:70),D(1:20,81:100));
end;
if NUMBER == 9
   D = horzcat(D(1:20,1:80),D(1:20,91:100));
end;
if NUMBER == 10
  D = D(1:20,1:90);  
end;
end;