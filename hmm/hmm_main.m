function [PrecisionT, RecallT, F_mT, errorT, PrecisionTR, RecallTR, F_mTR, errorTR] = hmm_main(dataTrainArabicDigit,dataTestArabicDigit,nstates,nmix,diag)

%% about
%   классификация  с помощью HMM pmtk library
%% init

setSeed(0); 

%% train
model = hmm_train(nstates,dataTrainArabicDigit,nmix);
% if (diag ~= 0)
%     for i=1:size(model.classConditionals,1)
%         for j=1:size(model.classConditionals{i,1}.emission.Sigma,3)
%             g = 0;
%             for k=1:size(model.classConditionals{i,1}.emission.Sigma,2)            
%                 for m=1:size(model.classConditionals{i,1}.emission.Sigma,1)
%                     if (k ~= m)
%                         model.classConditionals{i,1}.emission.Sigma(k,m,j) = 0;
%                     else
%                         g = g + model.classConditionals{i,1}.emission.Sigma(k,m,j);
%                     end;
%                 end;           
%             end;
%             % g = g / size(model.classConditionals{i,1}.emission.Sigma,1);
%             % gg = repmat(0.00001,1,size(model.classConditionals{i,1}.emission.Sigma,1));
%             % model.classConditionals{i,1}.emission.Sigma(:,:,j) = diag(gg);
%         end;
%     end;
% end;

save('modelHMM', 'model');

%% load model
load modelHMM;

%% test on test data
[PrecisionT, RecallT, F_mT, errorT] = hmm_test_l(dataTestArabicDigit,model);
%% test on train data
[PrecisionTR, RecallTR, F_mTR, errorTR] = hmm_test_l(dataTrainArabicDigit,model);

function [AveragePrecision, AverageRecall, F_measure, error] = hmm_test_l(dataTest,model)

[ll] = hmm_test(dataTest,model);
arrayLL = ll';
label = cell(1,1);
k = 1;
for i=1:size(dataTest,1)
    for j=1:size(dataTest,2)       
        label{i,j}(1,1) = i-1; 
        k = k+1;
    end;
end;

for i=1:size(arrayLL,2)
    [c index] = max(arrayLL(:,i));
     arrayLabelDetect(1,i) = index-1;    
end;
for i =1:size(label,1)
    for j=1:size(label,2)
     arrayLabelTrue(1,(i-1)*size(label,2)+j) = label{i,j}(1,1); 
    end;
end;
[AveragePrecision, AverageRecall, F_measure, error] =calculateQuality(arrayLabelDetect,arrayLabelTrue,size(label,1));
