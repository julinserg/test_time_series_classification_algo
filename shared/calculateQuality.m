function [AveragePrecision, AverageRecall, F_measure, error] =  calculateQuality(arrayLabelDetect,arrayLabelTrue,numberClass)
    
% ��������� ���������� ������ ������� � ������� ����, ��������� �� � ����� �� 
% ����� ���������� �������� ��������
error = sum(arrayLabelDetect~=arrayLabelTrue)/size(arrayLabelDetect,2);
%fprintf('accuracy  = %f\n', accuracy);

%��������� ������� ��������������� Confusion_Matrix
Confusion_Matrix = repmat(0, numberClass, numberClass);
for i=1:size(arrayLabelDetect,2)
    colum = arrayLabelTrue(1,i) + 1;
    row = arrayLabelDetect(1,i) + 1;
    Confusion_Matrix(row,colum) = Confusion_Matrix(row,colum) + 1; 
end;
% �� ������ ������� ��������������� ��������� �������� � �������
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
% ������� ������� ��������������� 
%Confusion_Matrix
% ��������� ������� F-���� �� ���� �������
AveragePrecision = sum(Pricision) / numberClass;
AverageRecall = sum(Recall) / numberClass;
F_measure = 2*AveragePrecision*AverageRecall / (AveragePrecision + AverageRecall);
