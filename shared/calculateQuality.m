function [AveragePricision, AverageRecall, F_measure, quality] =  calculateQuality(arrayLabelDetect,arrayLabelTrue,numberClass)
    
% ��������� ���������� ������ ������� � ������� ����, ��������� �� � ����� �� 
% ����� ���������� �������� ��������
error = 0;
for i=1:size(arrayLabelDetect,2)
    if (arrayLabelDetect(1,i) ~= arrayLabelTrue(1,i))
        error = error+1;
    end;
end;
quality = 1 - (error / size(arrayLabelDetect,2));
fprintf('Quality  = %f\n', quality);

%numberClass = size(arrayLabelDetect,2) / sizeLableForClass;
Confusion_Matrix = repmat(0, numberClass, numberClass);
for i=1:size(arrayLabelDetect,2)
    colum = arrayLabelTrue(1,i) + 1;
    row = arrayLabelDetect(1,i) + 1;
    Confusion_Matrix(row,colum) = Confusion_Matrix(row,colum) + 1; 
end;
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
Confusion_Matrix
AveragePricision = sum(Pricision) / numberClass;
AverageRecall = sum(Recall) / numberClass;
F_measure = 2*AveragePricision*AverageRecall / (AveragePricision + AverageRecall);
fprintf('Average Pricision  = %f\n', AveragePricision);
fprintf('Average Recall  = %f\n', AverageRecall);
fprintf('F-measure  = %f\n', F_measure);















