function model = mkRndDiscreteHmm(nstates, d, nObsStates)
%% Make a random HMM model with a Gaussian emission distribution
% nstates is the number of hidden states
% d is the observation dimensionality
%%

% This file is from pmtk3.googlecode.com

T = normalize(rand(nstates, nObsStates, d), 2);
emission = condDiscreteProdCpdCreate(T);
piPrior = 1*ones(1, nstates);
transPrior = 1*ones(nstates, nstates);
pi = normalize(rand(1, nstates) + piPrior -1);
A  = normalize(rand(nstates) + transPrior -1, 2);
model = hmmCreate('discrete', pi, A, emission);
end


