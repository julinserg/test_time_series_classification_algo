clc;
clear;
fprintf('..........START COMPARE\n');

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

%groupDATA = {'ArticularyWordRecognition' 'AtrialFibrillation'};
% myBestOn 7 - ArticularyWordRecognition Cricket EigenWorms JapaneseVowels UWaveGestureLibrary
% myBestOn 7 - ArticularyWordRecognition Cricket EigenWorms ERing
% JapaneseVowels MotorImagery UWaveGestureLibrary
% myBestOn 5 - ArticularyWordRecognition Cricket EigenWorms ERing
% JapaneseVowels MotorImagery
% myBestOn 3 - Cricket EigenWorms ERing JapaneseVowels MotorImagery NATOPS
% myBestOn 9 - ArticularyWordRecognition Cricket EigenWorms ERing
% JapaneseVowels MotorImagery UWaveGestureLibrary

ResultCell = cell(length(groupDATA), length(groupDATA));
nameDataSetIndexX = 0;
%t = tiledlayout(4,7);
for groupDATAIdX = 1:length(groupDATA)
%nexttile
nameDataSetTrainX = append(groupDATA{groupDATAIdX}, '_TRAIN.mat') ;
nameDataSetIndexX = nameDataSetIndexX + 1;
dataTrainUCIX = getData2020(nameDataSetTrainX);
dataX = getRawData(dataTrainUCIX, 1, 100);

ResultCell(nameDataSetIndexX, 1) = { groupDATA{groupDATAIdX}};
nameDataSetIndexY = 1;
for groupDATAIdY = 1:length(groupDATA)
fprintf("--------------%s-%s \n", groupDATA{groupDATAIdX},groupDATA{groupDATAIdY});

nameDataSetTrainY = append(groupDATA{groupDATAIdY}, '_TRAIN.mat') ;
nameDataSetIndexY = nameDataSetIndexY + 1;
dataTrainUCIY = getData2020(nameDataSetTrainY);
dataY = getRawData(dataTrainUCIY, 1, 100);

DepTest2Class = DepTest2(dataX,dataY,'test','hsic');
resultStr = num2str(DepTest2Class.h, 4);
ResultCell(nameDataSetIndexX, nameDataSetIndexY) = {resultStr};
end
end

% Convert cell to a table and use first row as variable names
NameDataSetVar = {'NameDataSet'};
TableHeader = [ NameDataSetVar groupDATA ];
T = cell2table(ResultCell, 'VariableNames',TableHeader);
% Write the table to a CSV file
writetable(T,append('CompareData-DepTest2', '.csv'))
fprintf('..........STOP COMPARE\n');


%figure
%Mskekur(data,1,0.05, groupDATA{groupDATAId});
%p = anova1(data)
%h = chi2gof(data)
%HZmvntest(data);
%Roystest(data);

%clust = kmeans(data,7);
%silhouette(data,clust, 'Euclidean')

%net = selforgmap([10 10]);
%net = train(net,data');
%plotsompos(net,data')
%title(groupDATA{groupDATAId}) 
