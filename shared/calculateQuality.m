function [AveragePrecision, AverageRecall, F_measure, error] =  calculateQuality(arrayLabelDetect,arrayLabelTrue,numberClass)
    
% вычисляем количество ошибок первого и второго рода, суммируем их и делим на 
% общее количесвто тестовых примеров
error = sum(arrayLabelDetect~=arrayLabelTrue)/size(arrayLabelDetect,2);
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
% выводим матрицу неоднородностей 
%Confusion_Matrix
% вычисляем среднюю F-меру по всем классам
AveragePrecision = sum(Pricision) / numberClass;
AverageRecall = sum(Recall) / numberClass;
F_measure = 2*AveragePrecision*AverageRecall / (AveragePrecision + AverageRecall);
