function [model] = hmm_train(nstates,dataTrainArabicDigit)
%% about
%   классификация арабских цифр с помощью HMM pmtk library - обучение модели

%% load train data
fprintf('..........Start train\n');


dataTrain = cell(1,1);
k = 1;
for i=1:size(dataTrainArabicDigit,1)
    for j=1:size(dataTrainArabicDigit,2)
        dataTrain{k,1} = dataTrainArabicDigit{i,j};       
        labelTrain(k,1) = i-1; 
        k = k+1;
    end;
end;

%% train
pi0 = [1, 0, 0, 0, 0, 0 ,0];
transmat0 = normalize(diag(ones(nstates, 1)) + ...
            diag(ones(nstates-1, 1), 1), 2);
%fitArgs = {'pi0', pi0, 'trans0', transmat0, 'maxIter', 1000, 'verbose', true};
%nmix    = 16; 
%fitArgs = [fitArgs, {'nmix', nmix}];
%fitFn   = @(X)hmmFit(X, nstates, 'mixGaussTied', fitArgs{:});
fitArgs = {'pi0', pi0, 'trans0', transmat0, 'maxIter', 500, 'verbose', true};
fitFn   = @(X)hmmFit(X, nstates, 'gauss', fitArgs{:}); 
model = generativeClassifierFit(fitFn, dataTrain, labelTrain);
fprintf('..........Stop train\n');
