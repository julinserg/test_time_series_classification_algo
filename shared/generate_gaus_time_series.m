setSeed(2);
%% sample data
states_number   = 5;
class_number = 10;
dimension       = 13; 
timeseries_length    = 45; 
nsamples  = 220; 
dataTrain = cell(size(dimension,2),nsamples);
dataTest = cell(size(dimension,2),nsamples);
for i=1:class_number   
   hmmSource = mkRndGaussHmm(states_number, dimension); 
   [Y, Z]    = hmmSample(hmmSource, timeseries_length, nsamples);    
   [Y1, Z1]  = hmmSample(hmmSource, timeseries_length, nsamples); 
   Y         = cellwrap(Y');
   Y1        = cellwrap(Y1');
   dataTrain(i,:) = Y;
   dataTest(i,:) = Y1;
end

A = cell2mat(Y);
%Mskekur(A,1);
result = dataTrain;
save('Multivariate_mat\\MyRndGaussHmm_TRAIN.mat', 'result','-v7.3');
result = dataTest;
save('Multivariate_mat\\MyRndGaussHmm_TEST.mat', 'result','-v7.3');