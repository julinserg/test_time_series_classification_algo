
clc;
clear;
load training.mat
load label
load test
file_data = load('Ionosphere.txt');
MAXNUM = 250000;
%transforming data to toolbox formats
TrainData1 = training(1:MAXNUM,2:31);
FullData = TrainData1';
GroupTrue = label(1:MAXNUM,3);
TestData = test(:,2:31);
%FullData = file_data(:,1:end-1)';
%FullLabels = file_data(:, end)';
%FullLabels = FullLabels*2 - 1;
for i=1:length(GroupTrue)
    if GroupTrue{i} == 's'       
        LabelTrue(i,1) = -1;
       
    end;
    if GroupTrue{i} == 'b'       
        LabelTrue(i,1) = 1;        
    end;
end;
FullLabels = LabelTrue';
MaxIter = 500; % boosting iterations
CrossValidationFold = 20; % number of cross-validation folds

weak_learner = tree_node_w(2); % constructing weak learner

% initializing matrices for storing step error
RAB_control_error = zeros(1, MaxIter);
MAB_control_error = zeros(1, MaxIter);
GAB_control_error = zeros(1, MaxIter);

% constructing object for cross-validation
CrossValid = crossvalidation(CrossValidationFold); 

% initializing it with data
CrossValid = Initialize(CrossValid, FullData, FullLabels);

NuWeights = [];

% for all folds
for n = 1 : CrossValidationFold    
    TrainData = [];
    TrainLabels = [];
    ControlData = [];
    ControlLabels = [];
    
    % getting current fold
    [ControlData ControlLabels] = GetFold(CrossValid, n);
    
    % concatinating other folds into the training set
    for k = 1:CrossValidationFold
        if(k ~= n)
            [TrainData TrainLabels] = CatFold(CrossValid, TrainData, TrainLabels, k); 
        end
    end
  
    GLearners = [];
    GWeights = [];
    RLearners = [];
    RWeights = [];
    NuLearners = [];
    NuWeights = [];
    
    %training and storing the error for each step
    for lrn_num = 1 : MaxIter

        clc;
        disp(strcat('Cross-validation step: ',num2str(n), '/', num2str(CrossValidationFold), '. Boosting step: ', num2str(lrn_num),'/', num2str(MaxIter)));
 
        %training gentle adaboost
        [GLearners GWeights] = GentleAdaBoost(weak_learner, TrainData, TrainLabels, 1, GWeights, GLearners);
       
        %evaluating control error
        GControl = sign(Classify(GLearners, GWeights, ControlData));
        
        GAB_control_error(lrn_num) = GAB_control_error(lrn_num) + sum(GControl ~= ControlLabels) / length(ControlLabels); 
        
        %training real adaboost
        [RLearners RWeights] = RealAdaBoost(weak_learner, TrainData, TrainLabels, 1, RWeights, RLearners);
       
        %evaluating control error
        RControl = sign(Classify(RLearners, RWeights, ControlData));
        
        RAB_control_error(lrn_num) = RAB_control_error(lrn_num) + sum(RControl ~= ControlLabels) / length(ControlLabels); 

        %training modest adaboost
        [NuLearners NuWeights] = ModestAdaBoost(weak_learner, TrainData, TrainLabels, 1, NuWeights, NuLearners);
       
        %evaluating control error
        NuControl = sign(Classify(NuLearners, NuWeights, ControlData));
                
        MAB_control_error(lrn_num) = MAB_control_error(lrn_num) + sum(NuControl ~= ControlLabels) / length(ControlLabels);
       
    end    
end

%saving results
%save(strcat(name,'_result'),'RAB_control_error', 'MAB_control_error', 'CrossValidationFold', 'MaxIter', 'name', 'CrossValid');

% displaying graphs
figure, plot(GAB_control_error / CrossValidationFold );
hold on;
plot(MAB_control_error / CrossValidationFold , 'r');

plot(RAB_control_error / CrossValidationFold, 'g');
hold off;

legend('Gentle AdaBoost', 'Modest AdaBoost', 'Real AdaBoost');
title(strcat(num2str(CrossValidationFold), ' fold cross-validation'));
xlabel('Iterations');
ylabel('Test Error');
save ('RLearners.mat','RLearners');
save ('RWeights.mat','RWeights');
save ('NuWeights.mat','NuWeights');
save ('NuLearners.mat','NuLearners');
save ('GWeights.mat','GWeights');
save ('GLearners.mat','GLearners');
ResultR = sign(Classify(RLearners, RWeights, TestData'));

ResultNu = sign(Classify(NuLearners, NuWeights, TestData'));

ResultG = sign(Classify(GLearners, GWeights, TestData'));

for i=1:length(ResultG)
    if ResultG(i) == -1
        GroupDetect{i} = 's';
    end;
    if ResultG(i) == 1
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
