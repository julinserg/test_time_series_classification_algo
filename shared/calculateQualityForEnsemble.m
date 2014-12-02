function [Confusion_Matrix,CM_per] =  calculateQualityForEnsemble(arrayLabelDetect,arrayLabelTrue,numberClass)
    
% вычисляем количество ошибок первого и второго рода, суммируем их и делим на 
% общее количесвто тестовых примеров
error = 0;
for i=1:size(arrayLabelDetect,2)
    if (arrayLabelDetect(1,i) ~= arrayLabelTrue(1,i))
        error = error+1;
    end;
end;
accuracy = 1 - (error / size(arrayLabelDetect,2));
%fprintf('accuracy  = %f\n', accuracy);

%вычисляем матрицу неоднородностей Confusion_Matrix
Confusion_Matrix = repmat(0, numberClass, numberClass);
for i=1:size(arrayLabelDetect,2)
    colum = arrayLabelTrue(1,i) + 1;
    row = arrayLabelDetect(1,i) + 1;
    Confusion_Matrix(row,colum) = Confusion_Matrix(row,colum) + 1; 
end;
% на основе матрицы неоднородностей высисляем точность и полноту
Pricision = repmat(0, 1, numberClass);
Recall = repmat(0, 1, numberClass);
for i=1:numberClass
    if sum(Confusion_Matrix(i,:)) == 0
       Pricision(1,i) = 0;
    else
       Pricision(1,i) =  Confusion_Matrix(i,i) / sum(Confusion_Matrix(i,:));
    end;
    if sum(Confusion_Matrix(:,i)) == 0
      Recall(1,i) = 0;
    else
      Recall(1,i) = Confusion_Matrix(i,i) / sum(Confusion_Matrix(:,i));  
    end;   
end;
arrayLabelDetect = arrayLabelDetect + ones(size(arrayLabelDetect,1),size(arrayLabelDetect,2));
indexesLabelDetect = repmat(0,numberClass,size(arrayLabelDetect,2));
for i=1:size(arrayLabelDetect,2)
    indexesLabelDetect(arrayLabelDetect(i),i) = 1;
end;
arrayLabelTrue  = arrayLabelTrue + ones(size(arrayLabelTrue,1),size(arrayLabelTrue,2));
indexesLabelTrue = repmat(0,numberClass,size(arrayLabelTrue,2));
for i=1:size(arrayLabelTrue,2)
    indexesLabelTrue(arrayLabelTrue(i),i) = 1;
end;
[TrainError,ConfusionMatrix,CM_ind,CM_per]=confusion(indexesLabelTrue,indexesLabelDetect);








