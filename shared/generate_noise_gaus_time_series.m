clc;
clear;
setSeed(2);
%% sample data
fprintf('..........START GENERATE\n');
states_number   = 6;
class_number = 5;
dimension       = 15; 
timeseries_length    = 50; 
nsamples  = 600;
noise = 0.1;
isOnesSigma = 1; 
Sigma = zeros(dimension, dimension, states_number);
if (isOnesSigma == 1)    
    for k=1:states_number
        Sigma(:, :, k) = diag(ones(dimension,1) + 9);
    end
else
    for k=1:states_number
        Sigma(:, :, k) = randpd(dimension) + 2*eye(dimension);
    end
end

dataTrain = cell(size(dimension,2),nsamples);
dataTest = cell(size(dimension,2),nsamples);
for i=1:class_number   
   hmmSource = mkRndGaussHmmMy(states_number, dimension, Sigma); 
   [Y, Z]    = hmmSample(hmmSource, timeseries_length, nsamples);    
   [Y1, Z1]  = hmmSample(hmmSource, timeseries_length, nsamples); 
   Y         = cellwrap(Y');
   Y1        = cellwrap(Y1');
   dataTrain(i,:) = Y;
   dataTest(i,:) = Y1;
end


% for i=1:size(dataTest,1)
%     for j=1:size(dataTest,2)
%          matrix = dataTest{i,j};
%          for k=1:size(matrix,1)
%             matrix(k,:) = awgn( matrix(k,:), 20, 'measured');
%             %noiseAmplitude = 33;
%             %matrix(k,:) = matrix(k,:) + noiseAmplitude * rand (1, length (matrix(k,:)));
%          end
%          dataTest{i,j} = matrix;
%     end
% end
for i=1:size(dataTrain,1)
    for j=1:size(dataTrain,2)
         matrixT = dataTrain{i,j};
         for k=1:size(matrixT,1)
            matrixT(k,:) = awgn( matrixT(k,:), noise, 'measured');
         end
         dataTrain{i,j} = matrixT;  
    end
end
%dataTrain1 = dataTrain;
% dataTrain1 = getTestData(1,11);
% dataTrain1 = dataTrain1(1:2,:);
% k = 1;
% for i=1:size(dataTrain1,1)
%     for j=1:size(dataTrain1,2)
%         dataTrainH{k,1} = dataTrain1{i,j};
%         labelTrain(k,1) = i-1; 
%         k = k+1;
%     end;
% end;
% k_1 = 1;
% dataTrainForClass = cell(size(dataTrain1,1),1);
% labelTrainForClass = cell(size(dataTrain1,1),1);
% for i=1:size(dataTrainH,1)  
%     u = size(dataTrainH{i},2);
%     a = dataTrainH{i};
%     t = size(dataTrainForClass{labelTrain(i)+1},2) +1;        
%     dataTrainForClass{labelTrain(i)+1}(:,t:t+u-1) = a;
%     labelTrainForClass{labelTrain(i)+1}(:,t:t+u-1) = repmat(labelTrain(i),1,size(a,2));
%     k_1 = k_1+size(a,2);  
% end;
% 
% A = dataTrainForClass{1,1};
% A = A(1:4,:);
% Y = labelTrainForClass{1,1};
% Y = Y(1,:);
% figure
% gplotmatrix(A',[],Y',[],[],[],false);

result = dataTrain;
sigmaVal = 0;
if(isOnesSigma == 1)
    sigmaVal = Sigma(1,1,1);
end
strPrefix = append('-',num2str(states_number),'-',num2str(class_number),'-', ...
num2str(dimension),'-',num2str(timeseries_length),'-',num2str(nsamples), '-',num2str(noise), '-',num2str(sigmaVal));
save(append('Multivariate_mat\\MyRndNoiseGaussHmm', strPrefix, '_TRAIN', '.mat'), 'result','-v7.3');
result = dataTest;
save(append('Multivariate_mat\\MyRndNoiseGaussHmm', strPrefix, '_TEST', '.mat'), 'result','-v7.3');
fprintf('..........STOP GENERATE\n');