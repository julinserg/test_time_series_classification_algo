function [model] = hmm_train(nstates,dataTrainArabicDigit,nmix)
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
pi0 = repmat(0,1,nstates);
pi0(1,1) = 1;
transmat0 = normalize(diag(ones(nstates, 1)) + ...
            diag(ones(nstates-1, 1), 1), 2);
if nmix > 0
    fitArgs = {'pi0', pi0, 'trans0', transmat0, 'maxIter', 1000, 'verbose', true};    
    fitArgs = [fitArgs, {'nmix', nmix}];
    fitFn   = @(X)hmmFit(X, nstates, 'mixGaussTied', fitArgs{:});
else    
    fitArgs = {'pi0', pi0, 'trans0', transmat0, 'maxIter', 500, 'verbose', true};
    fitFn   = @(X)hmmFit(X, nstates, 'gauss', fitArgs{:}); 
end;
model = generativeClassifierFit(fitFn, dataTrain, labelTrain);
fprintf('..........Stop train\n');
