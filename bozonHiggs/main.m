clc;
clear;
load training.mat
load label
load test

MAXNUM = 250000;
TrainData = training(1:MAXNUM,2:31);
GroupTrue = label(1:MAXNUM,3);
TestData = test(:,2:31);
index1 = 1;
index2 = 1;
for i=1:size(TrainData,1)
    if GroupTrue{i} == 's'
        dataTrainArabicDigit{1,index1} = TrainData(i,:)';
        index1 = index1 +1;
    end;
    if GroupTrue{i} == 'b' 
        dataTrainArabicDigit{2,index2} = TrainData(i,:)';
        index2 = index2 +1;
    end;
end;
for i=1:size(TestData,1)   
     dataTestArabicDigit{i,1} = TestData(i,:)';  
end;
%LabelTrue = double(cell2mat(GroupTrue));
%LabelTrue = LabelTrue';
for i=1:length(GroupTrue)
    if GroupTrue{i} == 's'       
        LabelTrue(i,1) = 1;
        LabelTrue(i,2) = 0;
    end;
    if GroupTrue{i} == 'b'       
        LabelTrue(i,1) = 0;
        LabelTrue(i,2) = 1;
    end;
end;
%LabelTrue = LabelTrue';
%model = svmtrain(LabelTrue, TrainData,'-t 0');
%[predict_label, accuracy, dec_values] = svmpredict(LabelTrue, TestData, model);
%TrainData= double(TrainData);
display('Start');
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
output_test = net(TestData');
output_test = output_test';
[maxVal indexMaxVal] = max(output_test,[],2);
for i=1:length(indexMaxVal)
    if indexMaxVal(i) == 1
        GroupDetect{i} = 's';
    end;
    if indexMaxVal(i) == 2
        GroupDetect{i} = 'b';
    end;
end;
% GroupDetect = GroupDetect';
%options = optimset('maxiter',10000);
%SVMModel = svmtrain(TrainData,GroupTrue,'Kernel_Function','linear','Method','QP',...
%            'quadprog_opts',options);
%GroupDetect = svmclassify(SVMModel,TestData);
%net = newp(TrainData,T);
% final_output = net(TestData');
% for i=1:length(final_output)
%     if final_output(i) <= 0.4
%         GroupDetect{i} = 's';
%     end;
%     if final_output(i) > 0.4
%         GroupDetect{i} = 'b';
%     end;
% end;
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

eutid = fopen('result.csv', 'w+'); 
fprintf(eutid, '%s\n', T); 
for i=1:size(C,1)
fprintf(eutid, '%s\n', C(i,:)); 
end;
fclose(eutid); 
display('Stop');
