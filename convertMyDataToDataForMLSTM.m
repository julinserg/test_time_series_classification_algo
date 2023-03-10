clc;
clear;

path = './Multivariate_mat/';
groupDATA = {'ArticularyWordRecognition' 'AtrialFibrillation' 'BasicMotions' ...
    'CharacterTrajectories' 'Cricket' 'EigenWorms' 'Epilepsy' ...
    'EthanolConcentration' 'ERing' 'FaceDetection' 'FingerMovements' ...
    'HandMovementDirection' 'Handwriting' 'Heartbeat' 'InsectWingbeat' ...
    'JapaneseVowels' 'Libras' 'LSST' 'MotorImagery' 'NATOPS' 'PenDigits' ...
    'PEMS-SF' 'Phoneme' 'RacketSports' 'SelfRegulationSCP1' 'SelfRegulationSCP2' ...
    'SpokenArabicDigits' 'StandWalkJump' 'UWaveGestureLibrary' };
%groupDATA = {'SpokenArabicDigits'};
fprintf('..........BEGIN \n');
if ~exist('./Multivariate_mat_for_mlstm/', 'dir')
       mkdir('./Multivariate_mat_for_mlstm/')
end
for indexData = 1:10
    for groupDATAId = 1:length(groupDATA)
        nameDataSet = groupDATA{groupDATAId};
        fprintf('..........BEGIN %s \n', nameDataSet);
        nameDataSetIndexing = append(nameDataSet, '-', num2str(indexData));
        [X, Y] = loadMyMatData(path, nameDataSetIndexing, '_TRAIN.mat');
        X_train = X';
        Y_train = Y';
        [X, Y] = loadMyMatData(path, nameDataSet, '_TEST.mat');
        X_test = X';
        Y_test = Y';      

        resultFileName = ['./Multivariate_mat_for_mlstm/' nameDataSetIndexing '_MLSTM.mat'];
        save( resultFileName, 'X_train', 'Y_train', 'X_test', 'Y_test');
        fprintf('..........END %s \n', nameDataSet);
    end
end
fprintf('..........END \n');

function [X, Y] = loadMyMatData(path, nameDataSet, type)
    str = [path nameDataSet type];
    if exist(str, 'file') == 0
        return;
    end
    load(str);
    
    X = cell(1,1);
    Y = [];
    k = 1;
    for i=1:size(result,1)
        for j=1:size(result,2)
            X{k,1} = result{i,j};       
            Y(k,1) = i-1; 
            k = k+1;
        end
    end
    clearvars result;
end

