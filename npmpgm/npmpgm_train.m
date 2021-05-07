function [Probability, cellNetKox] = npmpgm_train(dataTrainRaw,dataTrainForClass, row_map, col_map, epohs_map, val_dirichlet)
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
parfor i=1:size(dataTrainForClass,1)
   i % ����� �������� ������ ������ � �������
  F = dataTrainForClass{i};
  net = newsom(F,[row_map col_map],'hextop','dist');
  net.trainParam.epochs = epohs_map;
  net.trainParam.showWindow = false;
  [net] = train(net,F); 
  cellNetKox{i} = net;
end;
% ��������� ������������� ������������ ��������� ����� ������ ����� ��� ������� ������
Probability = cell(size(cellNetKox,1),1);
for i=1:size(cellNetKox,1);
    sizeW = size(cellNetKox{i}.iw{1,1},1);
    Probability{i}.A = repmat(0,sizeW,sizeW);
    Probability{i}.At = repmat(0,sizeW,1);
end;
for i=1:size(dataTrainRaw,1)
    for j=1:size(dataTrainRaw,2)
       array = sim(cellNetKox{i},dataTrainRaw{i,j});           
       array = vec2ind(array);
       for k=1:size(array,2)-1
           pp = array(1,k);
           qq = array(1,k+1);
           Probability{i}.A(pp,qq) = Probability{i}.A(pp,qq) + 1;               
           Probability{i}.At(pp)  = Probability{i}.At(pp) + 1;
       end;
    end;
end;
for i=1:size(Probability,1)
   for j =1:size(Probability{i}.A,2)
        if Probability{i}.At(j) ~= 0          
          vecSumDir = repmat(val_dirichlet,1,size(Probability{i}.A,2));
          Probability{i}.A(j,:) = (Probability{i}.A(j,:)+vecSumDir) ./ (Probability{i}.At(j)+(val_dirichlet*size(Probability{i}.A,2)));
        else
          vecSumDir = repmat(val_dirichlet,1,size(Probability{i}.A,2));
          if val_dirichlet ~= 0             
            Probability{i}.A(j,:) = vecSumDir ./ (val_dirichlet*size(Probability{i}.A,2));
          end;
        end;       
    end;
end;