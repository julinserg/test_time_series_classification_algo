clc;
clear;
%% ������������� ���� ������� (������� ���������� �������)
% ������ ���������� ������� = ���������� ���� ����������
isOpen = matlabpool('size') > 0;
if isOpen
   matlabpool close; 
end;
matlabpool open local 4;
%% ������������� ���������� ��������������
USETRAIN = 1 % 1-������� ������ ������ 0-������������ ����������� ������ 
row_map = 10; % ����������� ����� ����� ��������
col_map = 10; % ����������� �������� ����� ��������
epohs_map = 100; % ����������� ���� �������� ����� ��������
val_dirichlet = 0; % �������� ������������� �������
% ������ ��������� ������
% ���������� ��������� ������ ��� ����� ��������

%% �������� ������
if USETRAIN == 1    
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
        if ~isempty(dataTrainRaw{i,j})
            dataTrain{k,1} = dataTrainRaw{i,j};
            labelTrain(k,1) = i-1; 
            k = k+1;
        end;
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


   [Probability, cellNetKox] = trainModel(dataTrainRaw,dataTrainForClass, ...
   row_map,col_map,epohs_map,val_dirichlet);
   % ���������� ������ �������� ������������ � ����
   save('ProbabilityTransaction.mat','Probability');
   % ���������� ���� ������� � ����
   save('modelKohonen.mat', 'cellNetKox');
end;
display('Stop Train');
%% �������������
% �������� ����� ����������� ������
load modelKohonen;
% ��������� �������� ������
%       dataTest - ������ ����� (cell) ��������� �������� ����������� ������,
%       ����� ������ ������������ ������, � �������� ����������� ��������
%       ����������  ������: (NxM) - N - ���������� �������, M - ���������� ���������
%       �������� ��� ������� ������; ������ ������ �������� ������ -
%       ��������� ������������������ DxT - D - ����������� ������ ���������
%       , T - ����� ������������������
%load dataTest; 
k = 1;
dataTest = getTestDataOnTest(1);
for i=1:size(dataTest,1)
    for j=1:size(dataTest,2)       
        labelTest{i,j}(1,1) = i-1; 
        k = k+1;
    end;
end;
dataTest = dataTest(:);
b = 0;
e = 0;
for i=1:4  
    b = e + 1;
    e = b + 25*i - 1;
    
    [arrayLL{i}] = testModel(0,cellNetKox,dataTest(b:e,:));
end;
% arrayLabelDetect - ������ ����� ������� �������� ���������������  
for i=1:size(arrayLL,2)
    [c index] = max(arrayLL(:,i));
     arrayLabelDetect(1,i) = index-1;  
end;
% arrayLabelTrue - ������ ����� ������� �������� ���������
%arrayLabelTrue = cell2mat(labelTest(:));
%arrayLabelTrue = arrayLabelTrue';
for i=1:length(arrayLabelDetect)
    if arrayLabelDetect(i) == 0
        GroupDetect{i} = 's';
    end;
    if arrayLabelDetect(i) == 1
        GroupDetect{i} = 'b';
    end;
end;
OtValue = arrayLL(2,:) ./ arrayLL(1,:);
[NewLL IndexLL] = sort(OtValue);
[NewLL1 IndexLL1] = sort(IndexLL);
GroupDetect = GroupDetect';
nuulVector = repmat(0,1,size(dataTest,1));
pointVector = repmat(',',1,size(dataTest,1));
ddotVector = repmat('\n',1,size(dataTest,1));
nuulVector = IndexLL1';
GroupDetect = cell2mat(GroupDetect);
load test;
testID = test(:,1);
EventId = 'EventId';
RankOrder = 'RankOrder';
Class = 'Class';
point = ',';
T = [EventId,point,RankOrder,point,Class];
C = cat(2, num2str(testID),pointVector', num2str(nuulVector),pointVector',GroupDetect);
%RES = cat(1,T,C);

eutid = fopen('result.csv', 'w+'); 
fprintf(eutid, '%s\n', T); 
for i=1:size(C,1)
fprintf(eutid, '%s\n', C(i,:)); 
end;
fclose(eutid); 
%% ������ �������� �������������
%[ff,gg, fmear,accuracy] = calculateQuality(arrayLabelDetect,arrayLabelTrue,size(arrayLL,1));
%save('lastTest.dat','-ascii','fmear','-double');
display('Stop');

