clc;
clear;
fprintf('..........BEGIN\n');
javaaddpath('c:\Program Files\Weka-3-8-4\weka.jar');
path = 'd:\\science\\phd_codesource\\Multivariate_arff\\';

nameDataSet = 'Cricket';
trainOrTest = 'TEST';
%trainOrTest = 'TRAIN';

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
    inst = 0;
    classOld = -1;
    for i = 1: size(mdata,1) 
        class = mdata(i, targetNDX);
        if class ~= classOld
           inst = 1; 
        else
           inst = inst + 1;
        end
        classOld = class;
        Array = mdata(i,1:end-1);
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
fprintf('..........END\n');

