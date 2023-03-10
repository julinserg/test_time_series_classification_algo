function [D] = getTrainData(NUMBER,SELECTDATASET)
if SELECTDATASET == 1
%% arabic digit
 load dataTrainArabicDigit;
 load dataTestArabicDigit;
 %dataTrainArabicDigit = dataTrainArabicDigit(1:5,1:50);
 D = dataTrainArabicDigit;
 M = dataTestArabicDigit;
 D = horzcat(D,M);
 if NUMBER == 1
  D = dataTrainArabicDigit;
end;
if NUMBER == 2
  D = horzcat(D(1:10,1:88),D(1:10,177:880));
  %D = D(:,:);
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
  %D = D(1:20,1:100);
  D = D(1:20,1:80);
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

if SELECTDATASET == 3
   load Train_Outex_TC_00012.mat;
   C = dataTrainTexture;
    if NUMBER == 1
        D = C(:,:);
%         for i=1:size(C,1)
%             for j=1:size(C,2)
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
    load Train_Outex_TC_00014.mat;
    D = dataTrainTexture;
    if NUMBER == 1
        D = D(:,:);
    end;
end;

if SELECTDATASET == 5
    load Train_Outex_TC_LBP.mat;
    D = dataTrainTexture;
    if NUMBER == 1
        D = D(:,:);
    end;
end;

if SELECTDATASET == 6
    load higgsTrain.mat;
    D = dataTrainArabicDigit;
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
    load TrainCinCECGtorso.mat;
    D = TrainCinCECGtorso;
    if NUMBER == 1
        D = D(:,:);
    end;
end;

if SELECTDATASET == 9  
    load TrainInlineSkate.mat;
    % InlineSkate http://www.cs.ucr.edu/~eamonn/time_series_data/
    D = TrainInlineSkate;
    if NUMBER == 1
        D = D(:,:);
    end;
end;

if SELECTDATASET == 10  
    load TrainHaptics.mat;
    % Haptics http://www.cs.ucr.edu/~eamonn/time_series_data/
    D = TrainHaptics;
    if NUMBER == 1
        D = D(:,:);
    end;
end;

if SELECTDATASET == 11  
    load dataTrainProfilogr.mat;
    % ? ???????
    D = dataTrainProfilogr;
    if NUMBER == 1
        D = D(:,:);
    end;
end;

if SELECTDATASET == 12 
    load dataTrainTelem.mat;
    % ? ???
    D = dataTrainTelem;
    if NUMBER == 1
        D = D(:,:);
    end;
end;

if SELECTDATASET == 13
    load dataMovementAAL.mat;
    % Indoor User Movement Prediction from RSS data Data Set 
    % http://archive.ics.uci.edu/ml/datasets/Indoor+User+Movement+Predictio
    % n+from+RSS+data
    D = dataMovementAAL;
    if NUMBER == 1
        D = D(1:2,1:105);
    end;
end;

if SELECTDATASET == 14
    load dataTrainISE100.mat;
    % ISTANBUL STOCK EXCHANGE Data Set 
    % http://archive.ics.uci.edu/ml/datasets/ISTANBUL+STOCK+EXCHANGE
    D = dataTrainISE100;
    if NUMBER == 1
        D = D(:,:);
    end;
end;

if SELECTDATASET == 15
    load dataTrainRndGaussHmm.mat;   
    D = dataTrain;
    if NUMBER == 1
        D = D(:,:);
    end;
end;

if SELECTDATASET == 16
    load dataTrainRndDiscreteHmm.mat;   
    D = dataTrain;
    if NUMBER == 1
        D = D(:,:);
    end;
end;

if SELECTDATASET == 17
    load dataTrainRndNoiseGaussHmm.mat;   
    D = dataTrain;
    if NUMBER == 1
        D = D(:,:);
    end
end

if SELECTDATASET == 18
    load dataTrainTextureImage.mat;   
    D = dataTrain;
    if NUMBER == 1
        D = D(:,:);
    end
end

if SELECTDATASET == 19
    load dataTrainSeqFromImage.mat;   
    D = dataTrainTelem;
    if NUMBER == 1
        D = D(:,:);
    end
end






