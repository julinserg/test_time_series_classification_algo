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
% skip - 'PEMS-SF'
groupDATA = {'ArticularyWordRecognition' 'AtrialFibrillation' 'BasicMotions' ...
     'CharacterTrajectories' 'Cricket' 'EigenWorms' 'Epilepsy' 'EthanolConcentration' ...
     'ERing' 'FingerMovements' 'HandMovementDirection' 'Handwriting' 'Heartbeat' 'JapaneseVowels' ...
     'Libras' 'LSST' 'MotorImagery' 'NATOPS' 'PenDigits'  'RacketSports' ...
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

ResultCell = cell(length(groupDATA), 17);
nameDataSetIndexX = 0;
%t = tiledlayout(4,7);
for groupDATAIdX = 1:length(groupDATA)
%nexttile
nameDataSetTrainX = append(groupDATA{groupDATAIdX}, '_TRAIN.mat') ;
nameDataSetIndexX = nameDataSetIndexX + 1;
dataTrainUCIX = getData2020(nameDataSetTrainX);
dataX = getRawData(dataTrainUCIX, 1, 1000);
dataX2 = getRawData(dataTrainUCIX, 2, 1000);

ResultCell(nameDataSetIndexX, 1) = { groupDATA{groupDATAIdX}};
DepTest1ClassJohn = DepTest1(dataX,'test','john');
DepTest1ClassWang = DepTest1(dataX,'test','wang');
DepTest1ClassSign = DepTest1(dataX,'test','sign');
DepTest1ClassBcs = DepTest1(dataX,'test','bcs');

DepTest1ClassSpearman = DepTest1(dataX,'test','spearman');
DepTest1ClassKendall = DepTest1(dataX,'test','kendall');

%  UniSphereTestClassRayleighl = UniSphereTest(dataX,'test','rayleigh'); % Rayleigh test fails since resultant is zero
%  UniSphereTestClassGine = UniSphereTest(dataX,'test','gine-ajne'); % Weighted Gine-Ajne
%  UniSphereTestClassRandproj = UniSphereTest(dataX,'test','randproj'); % random projection
%  UniSphereTestClassBingham = UniSphereTest(dataX,'test','bingham'); % Bingham

ResultCell(nameDataSetIndexX, 2) = {num2str(DepTest1ClassJohn.h, 4)};
ResultCell(nameDataSetIndexX, 3) = {num2str(DepTest1ClassWang.h, 4)};
ResultCell(nameDataSetIndexX, 4) = {num2str(DepTest1ClassSign.h, 4)};
ResultCell(nameDataSetIndexX, 5) = {num2str(DepTest1ClassBcs.h, 4)};

ResultCell(nameDataSetIndexX, 6) = {num2str(DepTest1ClassSpearman.h, 4)};
ResultCell(nameDataSetIndexX, 7) = {num2str(DepTest1ClassKendall.h, 4)};

%  ResultCell(nameDataSetIndexX, 8) = {num2str(UniSphereTestClassRayleighl.h, 4)};
%  ResultCell(nameDataSetIndexX, 9) = {num2str(UniSphereTestClassGine.h, 4)};
%  ResultCell(nameDataSetIndexX, 10) = {num2str(UniSphereTestClassRandproj.h, 4)};
%  ResultCell(nameDataSetIndexX, 11) = {num2str(UniSphereTestClassBingham.h, 4)};
ResultCell(nameDataSetIndexX, 12) = {num2str(mean(std(dataX)), 4)};
ResultCell(nameDataSetIndexX, 13) = {num2str(mean(std(dataX2)), 4)};
if(size(dataTrainUCIX,1) > 2)
    dataX3 = getRawData(dataTrainUCIX, 3, 1000);
    ResultCell(nameDataSetIndexX, 14) = {num2str(mean(std(dataX3)), 4)};
end
if(size(dataTrainUCIX,1) > 3)
    dataX4 = getRawData(dataTrainUCIX, 4, 1000);
    ResultCell(nameDataSetIndexX, 15) = {num2str(mean(std(dataX4)), 4)};
end
if(size(dataTrainUCIX,1) > 4)
    dataX5 = getRawData(dataTrainUCIX, 5, 1000);
    ResultCell(nameDataSetIndexX, 16) = {num2str(mean(std(dataX5)), 4)};
end
if(size(dataTrainUCIX,1) > 5)
    dataX6 = getRawData(dataTrainUCIX, 6, 1000);
    ResultCell(nameDataSetIndexX, 17) = {num2str(mean(std(dataX6)), 4)};
end


% mu = mean(dataX(:,1:2));
% Sigma = std(dataX(:,1:2));
% x1 = -3:0.2:3;
% x2 = -3:0.2:3;
% [X1,X2] = meshgrid(x1,x2);
% X = [X1(:) X2(:)];
% y = mvnpdf(X,mu,Sigma);
% y = reshape(y,length(x2),length(x1));
% surf(x1,x2,y)
% caxis([min(y(:))-0.5*range(y(:)),max(y(:))])
% axis([-3 3 -3 3 0 0.4])
% xlabel('x1')
% ylabel('x2')
% zlabel('Probability Density')

end

% Convert cell to a table and use first row as variable names
NameDataSetVar = {'NameDataSet'};
TableHeader = [ NameDataSetVar {'John.h', 'Wang.h', 'Sign.h', 'Bcs.h' 'Spearman.h' ...
    'Kendall.h' 'Rayleighl.h' 'Gine.h' 'Randproj.h' 'Bingham.h' ...
    'std cl1' 'std cl2' 'std cl3' 'std cl4' 'std cl5' 'std cl6'} ];
T = cell2table(ResultCell, 'VariableNames',TableHeader);
% Write the table to a CSV file
writetable(T,append('CompareData-DepTest1', '.csv'))
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
