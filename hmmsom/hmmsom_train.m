function [model, cellNetKox] = hmmsom_train(dataTrainRaw,dataTrainForClass, row_map, col_map, epohs_map, nstates)
%% ������� �������� ������ 
% ������� ������:
%       dataTrainRaw - ������ ����� (cell) ��������� ��������� ������,
%       ����� ������ ������������ ������, � �������� ����������� ���������
%       ������: (NxM) - N - ���������� �������, M - ���������� ���������
%       �������� ��� ������� ������; ������ ������ �������� ������ -
%       ��������� ������������������ DxT - D - ����������� ������ ���������
%       , T - ����� ������������������
%       dataTrainForClass - ������ ����� (cell)��������� ���������
%       ������ ��� ����� ������,������������� � ���� �������: (Nx1) - N - ���������� �������  
%       row_map - ����������� ����� ����� ��������
%       col_map - ����������� �������� ����� ��������
%       epohs_map - ����������� ���� �������� ����� ��������
%       val_dirichlet - �������� ������������� �������
% �������� ������: 
%       Probability - ������ �����((Nx1)- N - ���������� �������), ������ ������ ��� ������� �������� ������������� ������������ ��������
%       ����� ������ ����� ��������: LxL - ��� L =row_map*col_map
%       cellNetKox - ������ �������� ��������� ���� ����� ����� �������� ���
%       ������� ������: (Nx1)- N - ���������� �������
% �������� ����� �������� ��� ������� ������ 
%%
cellNetKox = cell(size(dataTrainRaw,1),1);
% �������� ���� ��������
% !!!! �������� ����� ������ parfor �������� ������ ������ � ������ R2013a 
for i=1:size(dataTrainForClass,1)
   i % ����� �������� ������ ������ � �������
  F = dataTrainForClass{i};
  net = newsom(F,[row_map col_map],'hextop','dist');
  net.trainParam.epochs = epohs_map;
  net.trainParam.showWindow = false;
  [net] = train(net,F); 
  cellNetKox{i} = net;
end
dataTrainForHMM = cell(1,1);
for i=1:size(dataTrainRaw,1)
    for j=1:size(dataTrainRaw,2)
       array = sim(cellNetKox{i},dataTrainRaw{i,j});           
       array = vec2ind(array);
       dataTrainForHMM{i,j} = array;
    end
end

dataTrain = cell(1,1);
k = 1;
for i=1:size(dataTrainForHMM,1)
    for j=1:size(dataTrainForHMM,2)
        dataTrain{k,1} = dataTrainForHMM{i,j};       
        labelTrain(k,1) = i-1; 
        k = k+1;
    end
end

%% train
pi0 = repmat(0,1,nstates);
pi0(1,1) = 1;
nrestarts = 2;
transmat0 = normalize(diag(ones(nstates, 1)) + ...
            diag(ones(nstates-1, 1), 1), 2); 
fitFn   = @(X)hmmFit(X, nstates, 'discrete', ...
    'pi0', pi0, 'trans0', transmat0, 'maxIter', 500, ...
    'convTol', 1e-5, 'verbose', true);
model = generativeClassifierFit(fitFn, dataTrain, labelTrain);

