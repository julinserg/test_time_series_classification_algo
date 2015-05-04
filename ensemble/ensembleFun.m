function [ ] = ensembleFun( test_arrayLabelDetectOne,test_arrayLLOne,test_arrayLabelDetectTwo,test_arrayLLTwo,test_arrayLabelTrue,train_arrayLabelDetectOne,train_arrayLLOne,train_arrayLabelDetectTwo,train_arrayLLTwo,train_arrayLabelTrue )
%% Ensemble Toolbox
CLF_Train_output(1).Abstract_level_output = (train_arrayLabelDetectOne + ones(size(train_arrayLabelDetectOne,1),size(train_arrayLabelDetectOne,2)))';
CLF_Train_output(2).Abstract_level_output = (train_arrayLabelDetectTwo + ones(size(train_arrayLabelDetectTwo,1),size(train_arrayLabelDetectTwo,2)))';
DP=mapminmax(train_arrayLLOne',0,1);
CLF_Train_output(1).Measurment_level_output = DP;
DP=mapminmax(train_arrayLLTwo',0,1);
CLF_Train_output(2).Measurment_level_output = DP;
[temp,Ranked_class]=sort(train_arrayLLOne,'descend');
CLF_Train_output(1).Rank_level_output = Ranked_class';
[temp,Ranked_class]=sort(train_arrayLLTwo,'descend');
CLF_Train_output(2).Rank_level_output = Ranked_class';
[Confusion_Matrix TpTnPerCl] = calculateQualityForEnsemble(train_arrayLabelDetectOne,train_arrayLabelTrue,size(train_arrayLLOne,1));
CLF_Train_output(1).ConfusionMatrix = Confusion_Matrix;
[Confusion_Matrix TpTnPerCl] = calculateQualityForEnsemble(train_arrayLabelDetectTwo,train_arrayLabelTrue,size(train_arrayLLOne,1));
CLF_Train_output(2).ConfusionMatrix = Confusion_Matrix;

N_train = size(train_arrayLLOne,2);
TrainTargets = train_arrayLabelTrue;

%% Ensemble Toolbox
CLF_Test_output(1).Abstract_level_output = (test_arrayLabelDetectOne + ones(size(test_arrayLabelDetectOne,1),size(test_arrayLabelDetectOne,2)))';
CLF_Test_output(2).Abstract_level_output = (test_arrayLabelDetectTwo + ones(size(test_arrayLabelDetectTwo,1),size(test_arrayLabelDetectTwo,2)))';
DP=mapminmax(test_arrayLLOne',0,1);
CLF_Test_output(1).Measurment_level_output = DP;
DP=mapminmax(test_arrayLLTwo',0,1);
CLF_Test_output(2).Measurment_level_output = DP;
[temp,Ranked_class]=sort(test_arrayLLOne,'descend');
CLF_Test_output(1).Rank_level_output = Ranked_class';
[temp,Ranked_class]=sort(test_arrayLLTwo,'descend');
CLF_Test_output(2).Rank_level_output = Ranked_class';

CombinitionMethods=[1,2,3,4,5,6,7,8,9]; 
N_classifiers = 2;
N_test = size(test_arrayLLOne,2);
N_class = size(test_arrayLLOne,1);
TestTargets = (test_arrayLabelTrue + ones(size(test_arrayLabelTrue,1),size(test_arrayLabelTrue,2)));
 for C=1:length(CombinitionMethods);
      CombinitionMethod=CombinitionMethods(C);
      Ensemble_decisions(C,:)=CombineCLFs(CombinitionMethod,...
        CLF_Train_output,CLF_Test_output,N_classifiers,N_test,N_train,N_class,TrainTargets);
      Accuracy_fold_Ensemble(C)=sum(Ensemble_decisions(C,:)==TestTargets)/N_test;
 end
[best Ibest] =  max(Accuracy_fold_Ensemble);
[Confusion_Matrix TpTnPerCl] = calculateQualityForEnsemble(Ensemble_decisions(Ibest,:) - ones(size(test_arrayLabelTrue,1),size(test_arrayLabelTrue,2)),test_arrayLabelTrue,N_class);
Accuracy_fold_Ensemble
TpTnPerCl


end

