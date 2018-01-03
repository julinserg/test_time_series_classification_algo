function [lstm_net,miniBatchSize] = lstm_train(dataTrainArabicDigit)
%% about
%   классификация арабских цифр с помощью HMM pmtk library - обучение модели

%% load train data
fprintf('..........Start train\n');


dataTrain = cell(1,1);
k = 1;
for i=1:size(dataTrainArabicDigit,1)
    for j=1:size(dataTrainArabicDigit,2)
        dataTrain{k,1} = dataTrainArabicDigit{i,j};       
        labelTrain(k,1) = i;
        lengthSeq(k,1) = size(dataTrainArabicDigit{i,j},2);
        k = k+1;
    end;
end;

%% train
inputSize = size(dataTrain{1,1},1);
outputSize = 100;
outputMode = 'last';
numClasses = size(dataTrainArabicDigit,1);

layers = [ ...
    sequenceInputLayer(inputSize)
    lstmLayer(outputSize,'OutputMode',outputMode)
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];
maxEpochs = 150;
miniBatchSize = 27;
shuffle = 'never';

options = trainingOptions('sgdm', ...
    'MaxEpochs',maxEpochs, ...   
    'Shuffle', shuffle);
labelTrain_c = categorical(labelTrain);
lstm_net = trainNetwork(dataTrain,labelTrain_c,layers,options);
fprintf('..........Stop train\n');
