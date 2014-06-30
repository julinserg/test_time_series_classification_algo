clc;
clear;
load training.mat
load label
load test

MAXNUM = 250000;
%trueindex = [1 2 3 4 6 8 9 10 11 12 14 15 16 17 18 19 20 21 22 23 24 25 26 27 30];

ValidateData = training(:,2:31);
ValidataGroup = label(:,3);
TrainData = training(1:MAXNUM,2:31);
%TrainData = TrainData(:,trueindex);
GroupTrue = label(1:MAXNUM,3);
TestData = test(:,2:31);
%sigma = 1;
%X = TrainData;
%X2 = sum(X.^2, 2);
%K = bsxfun(@plus, X2, bsxfun(@plus, X2', - 2 * (X * X')));
%K = gaussianKernel(1, 0,sigma) .^ K;
% for i=1:size(TrainData,1)
%     for j=1:size(TrainData,1)
%         K(i,j) = TrainData(i,:)*TrainData(j,:)';
%     end;
% end;
%TrainData = K;
%AllData = cat(1,TrainData ,TestData);
%[AllData_norm, mu, sigma] = featureNormalize(AllData);
%[U, S] = pca(AllData);
%  Project the data onto K = 1 dimension
%K = 40;
%Z = projectData(AllData, U, K);
%TrainData = Z(1:250000,:);
%TestData = Z(250001:800000,:);
%TestData = TestData(:,trueindex);
% index1 = 1;
% index2 = 1;
% for i=1:size(TrainData,1)
%     if GroupTrue{i} == 's'
%         dataTrainArabicDigit{1,index1} = TrainData(i,:)';
%         index1 = index1 +1;
%     end;
%     if GroupTrue{i} == 'b' 
%         dataTrainArabicDigit{2,index2} = TrainData(i,:)';
%         index2 = index2 +1;
%     end;
% end;
% for i=1:size(TestData,1)   
%      dataTestArabicDigit{i,1} = TestData(i,:)';  
% end;
%LabelTrue = double(cell2mat(GroupTrue));
%LabelTrue = LabelTrue';
for i=1:length(GroupTrue)
    if GroupTrue{i} == 's'       
        LabelTrue(i,1) = 0;
       
    end;
    if GroupTrue{i} == 'b'       
        LabelTrue(i,1) = 1;        
    end;
end;
for i=1:length(ValidataGroup)
    if ValidataGroup{i} == 's'       
        ValidataLabel(i,1) = 0;
       
    end;
    if ValidataGroup{i} == 'b'       
        ValidataLabel(i,1) = 1;        
    end;
end;
display('Start');
% C = 0.1;
% model = svmTrain(TrainData, LabelTrue, C, @linearKernel);
% p = svmPredict(model, ValidateData);
% fprintf('Training Accuracy: %f\n', mean(double(p == ValidataLabel)) * 100);
% 
% fprintf('\nEvaluating the trained Linear SVM on a test set ...\n')
% 
% p = svmPredict(model, TestData);
%LabelTrue = LabelTrue';
%model = svmtrain(LabelTrue, TrainData,'-t 0');
%[predict_label, accuracy, dec_values] = svmpredict(LabelTrue, TestData, model);
%TrainData= double(TrainData);

% hidden_layers = [30];
% iterations = 1000;  
% learning_rate = 0.1;
% momentum = 0.1;

% initialize and train the model
%[model cc_train output_train] = train_mlp(TrainData, LabelTrue, hidden_layers, iterations, learning_rate, momentum);
%load model
%cc_train
%[output_test] = testtest_mlp(model, TestData,2);
% B = mnrfit(TrainData,LabelTrue);
% pihat = mnrval(B,TestData);
% output_test = net(TestData');
% output_test = output_test';
% [maxVal indexMaxVal] = max(output_test,[],2);
% for i=1:length(p)
%     if p(i) == 0
%         GroupDetect{i} = 's';
%     end;
%     if p(i) == 1
%         GroupDetect{i} = 'b';
%     end;
% end;
% GroupDetect = GroupDetect';
%options = optimset('maxiter',10000);
%SVMModel = svmtrain(TrainData,GroupTrue,'Kernel_Function','linear','Method','QP',...
%            'quadprog_opts',options);
%GroupDetect = svmclassify(SVMModel,TestData);
%net = newp(TrainData,T);

%%LVQ
% net = lvqnet(10);
% net = train(net,TrainData',LabelTrue');
% view(net)

%load netsom
% array = sim(net,TrainData');
% [row,col] = find(array == 1);
% index_0 = 1;
% index_1 = 1;
% for i=1:size(LabelTrue,1)
%     if LabelTrue(i) == 0
%         Set_0(index_0) =  row(i);
%         index_0 = index_0 + 1;
%     end;
%     if LabelTrue(i) == 1
%         Set_1(index_1) =  row(i);
%         index_1 = index_1 + 1;
%     end;    
% end;
% Set_0n = unique(Set_0);
% Set_1n = unique(Set_1);
% C_0 = setdiff(Set_0n,Set_1n);
% C_1 = setdiff(Set_1n,Set_0n);
%validate_output = net(TrainData');
% ¬€¡»–¿≈Ã œŒ–Œ√
% range = 0;
% accura_max = 0;
% range_max = 0;
% for i=1:100
%     range = range + 0.01;
%     for j=1:length(validate_output)
%         if validate_output(j) <= range
%             LabelValidDetect(j,1) = 0;
%         end;
%         if validate_output(j) > range
%             LabelValidDetect(j,1) = 1;
%         end;   
%     end; 
%     accura = mean(double(LabelValidDetect == LabelTrue)) * 100;
%     fprintf('Range = %f , Training Accuracy: %f\n',range, accura);
%     if accura > accura_max
%         accura_max = accura;
%         range_max = range;
%     end;
% end;
%final_output = sim(net,TestData');
%[finalres,col] = find(final_output == 1);
LabelDetect = NNClassifier_L1(TrainData',TestData',LabelTrue');
for i=1:length(LabelDetect)
    if LabelDetect(i) == 0
        GroupDetect{i} = 's';
    end;
    if LabelDetect(i) == 1
        GroupDetect{i} = 'b';       
    end;
end;
GroupDetect = GroupDetect';
nuulVector = repmat(0,1,size(TestData,1));
pointVector = repmat(',',1,size(TestData,1));
ddotVector = repmat('\n',1,size(TestData,1));
nuulVector = find(nuulVector==0);
nuulVector = nuulVector(randperm(length(nuulVector)));
nuulVector = nuulVector';
GroupDetect = cell2mat(GroupDetect);
testID = test(:,1);
EventId = 'EventId';
RankOrder = 'RankOrder';
Class = 'Class';
point = ',';
T = [EventId,point,RankOrder,point,Class];
C = cat(2, num2str(testID),pointVector', num2str(nuulVector),pointVector',GroupDetect);
%RES = cat(1,T,C);

eutid = fopen('result.csv', 'w'); 
fprintf(eutid, '%s\n', T); 
for i=1:size(C,1)
fprintf(eutid, '%s\n', C(i,:)); 
end;
fclose(eutid); 
display('Stop');
