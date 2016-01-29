function [D] = getTestData(NUMBER,SELECTDATASET)
%% arabic digit
if SELECTDATASET == 1
 load dataTrainArabicDigit;
 load dataTestArabicDigit;
 %dataTrainArabicDigit = dataTrainArabicDigit(1:5,1:50);
 D = dataTrainArabicDigit;
 M = dataTestArabicDigit;
 D = horzcat(D,M); 
 C = D;
if NUMBER == 1   
   D = dataTestArabicDigit;
end;
if NUMBER == 2   
   D = C(:,89:176);  
end;
if NUMBER == 3   
   D = C(:,177:264);  
end;
if NUMBER == 4   
   D = C(:,265:352);   
end;
if NUMBER == 5  
   D = C(:,353:440);  
end;
if NUMBER == 6   
   D = C(:,441:528);   
end;
if NUMBER == 7   
   D = C(:,529:616);   
end;
if NUMBER == 8   
   D = C(:,616:704);   
end;
if NUMBER == 9   
   D = C(:,705:792);   
end;
if NUMBER == 10  
   D = C(:,793:880);   
end;
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
C = D;
if NUMBER == 1   
   D = D(1:20,51:100);
end;
if NUMBER == 2   
   D = C(:,11:20);  
end;
if NUMBER == 3   
   D = C(:,21:30);  
end;
if NUMBER == 4   
   D = C(:,31:40);   
end;
if NUMBER == 5  
   D = C(:,41:50);  
end;
if NUMBER == 6   
   D = C(:,51:60);   
end;
if NUMBER == 7   
   D = C(:,61:70);   
end;
if NUMBER == 8   
   D = C(:,71:80);   
end;
if NUMBER == 9   
   D = C(:,81:90);   
end;
if NUMBER == 10  
   D = C(:,91:100);   
end;
end;

if SELECTDATASET == 3
    load Test_Outex_TC_00012.mat;
    C = dataTestTexture;
    if NUMBER == 1
        D = C(:,:);
%         for i=1:size(C,1)
%              for j=1:size(C,2)
%                Data = C{i,j};
%                NewData = Data(:,:);
% %                NewData(6,:) = Data(1,:).*Data(2,:);
% %                NewData(7,:) = Data(2,:).*Data(3,:);
% %                NewData(8,:) = Data(3,:).*Data(4,:);
% %                NewData(9,:) = Data(4,:).*Data(5,:);
% %                for k =1:size(Data,2)                  
% %                    NewData(:,k) = Data(:,k)/norm(Data(:,k));
% %                end;
%                D(i,j) = {NewData};
%             end;
%         end;     
    end;
end;

if SELECTDATASET == 4
    load Test_Outex_TC_00014.mat;
    D = dataTestTexture;
    if NUMBER == 1
        D = D(:,:);
    end;
end;

if SELECTDATASET == 5
    load Test_Outex_TC_LBP.mat;
    D = dataTestTexture;
    if NUMBER == 1
        D = D(:,:);
    end;
end;

if SELECTDATASET == 6
    load higgsTest.mat;
    D = dataTestArabicDigit;
    if NUMBER == 1
        D = D(:,:);
    end;
end;

if SELECTDATASET == 7
    %http://archive.ics.uci.edu/ml/datasets/Dataset+for+ADL+Recognition+with+Wrist-worn+Accelerometer#
    load dataTestAccelerometer.mat;
    D = dataTest;
    if NUMBER == 1
        D = D(:,:);
    end;
end;

if SELECTDATASET == 8    
    load TestCinCECGtorso.mat;
    D = TestCinCECGtorso;
    if NUMBER == 1
        D = D(:,:);
    end;
end;

if SELECTDATASET == 9    
    load TestInlineSkate.mat;
    D = TestInlineSkate;
    if NUMBER == 1
        D = D(:,:);
    end;
end;

if SELECTDATASET == 10  
    load TestHaptics.mat;
    % Haptics http://www.cs.ucr.edu/~eamonn/time_series_data/
    D = TestHaptics;
    if NUMBER == 1
        D = D(:,:);
    end;
end;

if SELECTDATASET == 11  
    load dataTestProfilogr.mat;
    % ס ךאפוהנû
    D = dataTestProfilogr;
    if NUMBER == 1
        D = D(:,:);
    end;
end;
