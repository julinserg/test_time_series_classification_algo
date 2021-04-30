clc;
clear;

path = './Multivariate_mat/';
%DuckDuckGeese
groupDATA = {'ArticularyWordRecognition' 'AtrialFibrillation' 'BasicMotions' ...
    'CharacterTrajectories' 'Cricket' 'EigenWorms' 'Epilepsy' ...
    'EthanolConcentration' 'ERing' 'FaceDetection' 'FingerMovements' ...
    'HandMovementDirection' 'Handwriting' 'Heartbeat' 'InsectWingbeat' ...
    'JapaneseVowels' 'Libras' 'LSST' 'MotorImagery' 'NATOPS' 'PenDigits' ...
    'PEMS-SF' 'Phoneme' 'RacketSports' 'SelfRegulationSCP1' 'SelfRegulationSCP2' ...
    'SpokenArabicDigits' 'StandWalkJump' 'UWaveGestureLibrary' };
%groupDATA = {'SpokenArabicDigits'};
fprintf('..........BEGIN \n');
for groupDATAId = 1:length(groupDATA)
    nameDataSet = groupDATA{groupDATAId};
    fprintf('..........BEGIN %s \n', nameDataSet);
    str = [path nameDataSet '_TRAIN.mat'];
    if exist(str, 'file') == 0
        return;
    end
    load(str);  
    cols = size(result,2);
    for index = 1 : 10        
        P = randperm(cols);
        result = result(:,P);
        resultFileName = [path nameDataSet '-' num2str(index) '_TRAIN.mat'];
        save( resultFileName, 'result','-v7.3');
    end   
   
    fprintf('..........END %s \n', nameDataSet);
end
fprintf('..........END \n');

