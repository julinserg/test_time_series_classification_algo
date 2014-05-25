clc;
clear;
%% ������������� ���� ������� (������� ���������� �������)
isOpen = matlabpool('size') > 0;
if isOpen
   matlabpool close; 
end;
matlabpool open local 2;
%% ������������� ���������� ��������������
USETRAIN = 1 % 1-������� ������ ������ 0-������������ ����������� ������ 
row_map = 10; % ����������� ����� ����� ��������
col_map = 10; % ����������� �������� ����� ��������
epohs_map = 100; % ����������� ���� �������� ����� ��������
val_dirichlet = 0; % �������� ������������� �������
% ������ ��������� ������
% ���������� ��������� ������ ��� ����� ��������

% ��������� ��������� ������ 
%       dataTrainRaw - ������ ����� (cell) ��������� ��������� ������,
%       ����� ������ ������������ ������, � �������� ����������� ���������
%       ������: (NxM) - N - ���������� �������, M - ���������� ���������
%       �������� ��� ������� ������; ������ ������ �������� ������ -
%       ��������� ������������������ DxT - D - ����������� ������ ���������
%       , T - ����� ������������������
%load dataTrainRaw;
dataTrainRaw = getTrainData(1);
k = 1;
for i=1:size(dataTrainRaw,1)
    for j=1:size(dataTrainRaw,2)
        dataTrain{k,1} = dataTrainRaw{i,j};
        labelTrain(k,1) = i-1; 
        k = k+1;
    end;
end;
k_1 = 1;
dataTrainForClass = cell(size(dataTrainRaw,1),1);
for i=1:size(dataTrain,1)  
    u = size(dataTrain{i},2);
    a = dataTrain{i};
    t = size(dataTrainForClass{labelTrain(i)+1},2) +1;        
    dataTrainForClass{labelTrain(i)+1}(:,t:t+u-1) = a;       
    k_1 = k_1+size(a,2);  
end; 

%% �������� ������
if USETRAIN == 1    
   [Probability, cellNetKox] = trainModel(dataTrainRaw,dataTrainForClass, ...
   row_map,col_map,epohs_map,val_dirichlet);
   % ���������� ������ �������� ������������ � ����
   save('ProbabilityTransaction.mat','Probability');
   % ���������� ���� ������� � ����
   save('modelKohonen.mat', 'cellNetKox');
end;
%% �������������
% �������� ����� ����������� ������
load modelKohonen;
load ProbabilityTransaction;
% ��������� �������� ������
%       dataTest - ������ ����� (cell) ��������� �������� ����������� ������,
%       ����� ������ ������������ ������, � �������� ����������� ��������
%       ����������  ������: (NxM) - N - ���������� �������, M - ���������� ���������
%       �������� ��� ������� ������; ������ ������ �������� ������ -
%       ��������� ������������������ DxT - D - ����������� ������ ���������
%       , T - ����� ������������������
%load dataTest; 
dataTest = getTestDataOnTest(1);
for i=1:size(dataTest,1)
    for j=1:size(dataTest,2)       
        labelTest{i,j}(1,1) = i-1; 
        k = k+1;
    end;
end;
dataTest = dataTest(:);
[arrayLL] = testModel(Probability,cellNetKox,dataTest);
% arrayLabelDetect - ������ ����� ������� �������� ���������������  
for i=1:size(arrayLL,2)
    [c index] = max(arrayLL(:,i));
     arrayLabelDetect(1,i) = index-1;  
end;
% arrayLabelTrue - ������ ����� ������� �������� ���������
arrayLabelTrue = cell2mat(labelTest(:));
arrayLabelTrue = arrayLabelTrue';

%% ������ �������� �������������
[ff,gg, fmear,qual] = calculateQuality(arrayLabelDetect,arrayLabelTrue,size(arrayLL,1));
save('lastTest.dat','-ascii','qual','-double');


