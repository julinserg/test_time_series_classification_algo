clc;
clear;

javaaddpath('c:\Program Files\Weka-3-8-4\weka.jar');
path = 'd:\\science\\phd_codesource\\Multivariate_arff\\';
%DuckDuckGeese
groupDATA = {'ArticularyWordRecognition' 'AtrialFibrillation' 'BasicMotions' ...
    'CharacterTrajectories' 'Cricket' 'EigenWorms' 'Epilepsy' ...
    'EthanolConcentration' 'ERing' 'FaceDetection' 'FingerMovements' ...
    'HandMovementDirection' 'Handwriting' 'Heartbeat' 'InsectWingbeat' ...
    'JapaneseVowels' 'Libras' 'LSST' 'MotorImagery' 'NATOPS' 'PenDigits' ...
    'PEMS-SF' 'Phoneme' 'RacketSports' 'SelfRegulationSCP1' 'SelfRegulationSCP2' ...
    'SpokenArabicDigits' 'StandWalkJump' 'UWaveGestureLibrary' };
%groupDATA = {'ERing'};
for groupDATAId = 1:length(groupDATA)
nameDataSet = groupDATA{groupDATAId};
fprintf('..........BEGIN %s \n', nameDataSet);
%trainOrTest = 'TEST';
%trainOrTest = 'TRAIN';
groupTT = {'TRAIN' 'TEST'};
for groupTTId = 1:length(groupTT)
trainOrTest = groupTT{groupTTId};
result = cell(1,1);
dim = 0;
while true
    dim = dim + 1;
    str = [path nameDataSet '\\' nameDataSet 'Dimension' int2str(dim) '_' trainOrTest '.arff'];
    if exist(str, 'file') == 0
        break;
    end
    wekaOBJ = loadARFF(str);    
    [mdata,featureNames,targetNDX,stringVals,relationName] = weka2matlab(wekaOBJ,[]);
    mdataSort = sortrows(mdata,size(mdata,2));
    inst = 0;
    classOld = -1;
    for i = 1: size(mdataSort,1) 
        class = mdataSort(i, targetNDX);
        if class ~= classOld
           inst = 1; 
        else
           inst = inst + 1;
        end
        classOld = class;
        Array = mdataSort(i,1:end-1);
        %ArrayNotNAN = Array(~isnan(Array));
        result{class + 1,inst}(dim,:) = Array;
    end
end


CellDimMax = size(result,2);
CellDimNotNan = repmat(CellDimMax,1, size(result,1));
for class = 1: size(result,1)
for inst = 1: size(result,2)
   Array = result{class,inst};
   ArrayDimNotNan = [];
   for ArrayRowInd = 1: size(Array,1)
      ArrayRow = Array(ArrayRowInd, :);
      ArrayRowNotNAN = ArrayRow(~isnan(ArrayRow));
      ArrayDimNotNan(ArrayRowInd) = size(ArrayRowNotNAN,2);
   end
   minNotNanIndex = min(ArrayDimNotNan);
   ArrayNotNAN = Array(:,1:minNotNanIndex);   
   result{class,inst} = ArrayNotNAN;
   
   if isempty(Array)
       if CellDimNotNan(class) == CellDimMax
            CellDimNotNan(class) = inst - 1; 
       end
   end
   
end 
end

CellMinNotNanIndex = min(CellDimNotNan);
result = result(:,1:CellMinNotNanIndex);
resultFileName = ['d:\\science\\phd_codesource\\Multivariate_mat\\' nameDataSet '_' trainOrTest '.mat'];
save( resultFileName, 'result','-v7.3');
fprintf('..........END %s %s \n', trainOrTest, nameDataSet);
end
end

