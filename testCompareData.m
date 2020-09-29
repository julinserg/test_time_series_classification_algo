clc;
clear;
fprintf('..........START EXPERIMENT\n');

% groupDATA = {'ArticularyWordRecognition' 'AtrialFibrillation' 'BasicMotions' ...
%     'CharacterTrajectories' 'Cricket' 'EigenWorms' 'Epilepsy' ...
%     'EthanolConcentration' 'ERing' 'FaceDetection' 'FingerMovements' ...
%     'HandMovementDirection' 'Handwriting' 'Heartbeat' 'InsectWingbeat' ...
%     'JapaneseVowels' 'Libras' 'LSST' 'MotorImagery' 'NATOPS' 'PenDigits' ...
%     'PEMS-SF' 'Phoneme' 'RacketSports' 'SelfRegulationSCP1' 'SelfRegulationSCP2' ...
%     'SpokenArabicDigits' 'StandWalkJump' 'UWaveGestureLibrary' };

% fail - 'FaceDetection' 'InsectWingbeat' 'Phoneme'

groupDATA = {'ArticularyWordRecognition' 'AtrialFibrillation' 'BasicMotions' ...
     'CharacterTrajectories' 'Cricket' 'EigenWorms' 'Epilepsy' 'EthanolConcentration' ...
     'ERing' 'FingerMovements' 'HandMovementDirection' 'Handwriting' 'Heartbeat' 'JapaneseVowels' ...
     'Libras' 'LSST' 'MotorImagery' 'NATOPS' 'PenDigits' 'PEMS-SF' 'RacketSports' ...
     'SelfRegulationSCP1' 'SelfRegulationSCP2' 'SpokenArabicDigits' ...
     'StandWalkJump' 'UWaveGestureLibrary'};

%groupDATA = {'Phoneme'};
% myBestOn 7 - ArticularyWordRecognition Cricket EigenWorms JapaneseVowels UWaveGestureLibrary
% myBestOn 7 - ArticularyWordRecognition Cricket EigenWorms ERing
% JapaneseVowels MotorImagery UWaveGestureLibrary
% myBestOn 5 - ArticularyWordRecognition Cricket EigenWorms ERing
% JapaneseVowels MotorImagery
% myBestOn 3 - Cricket EigenWorms ERing JapaneseVowels MotorImagery NATOPS
% myBestOn 9 - ArticularyWordRecognition Cricket EigenWorms ERing
% JapaneseVowels MotorImagery UWaveGestureLibrary

nameDataSetIndex = 0;
t = tiledlayout(4,7);
for groupDATAId = 1:length(groupDATA)
nexttile
clear dataTrainForClass dataTrain labelTrain;
nameDataSetTrain = append(groupDATA{groupDATAId}, '_TRAIN.mat') ;
nameDataSetTest = append(groupDATA{groupDATAId}, '_TEST.mat') ;
nameDataSetIndex = nameDataSetIndex + 1;

dataTrainUCI = getData2020(nameDataSetTrain);
dataTest = getData2020(nameDataSetTest);

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
data = dataTrainForClass{1,1}';
for i=1:size(data,2)
   minV = min(data(:,i));
   maxV = max(data(:,i));
   data(:,i) = (data(:,i) - minV) / (maxV - minV); 
end

if size(data,1) > 2000
    data = data(1:2000,:);
end
%Roystest(data);
%HZmvntest(data);
%figure
fprintf("--------------%s", groupDATA{groupDATAId});
Mskekur(data,1,0.05,groupDATA{groupDATAId});

%clust = kmeans(data,7);
%silhouette(data,clust, 'Euclidean')

%net = selforgmap([10 10]);
%net = train(net,data');
%plotsompos(net,data')
title(groupDATA{groupDATAId}) 
end
