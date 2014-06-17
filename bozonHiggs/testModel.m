function [arrayLL] = testModel(Probability,cellNetKox,dataTest)
%% ������� �������������
% ������� ������:
%       Probability - ������ �����((Nx1)- N - ���������� �������), ������ ������ ��� ������� �������� ������������� ������������ ��������
%       ����� ������ ����� ��������: LxL - ��� L =row_map*col_map
%       cellNetKox - ������ �������� ��������� ���� ����� ����� �������� ���
%       ������� ������: (Nx1)- N - ���������� �������
%       dataTest -������ ����� (cell) ��������� ������ ��� ������������, - 1xM,
%       ��� M - ���������� �������� ��������,������ ������ �������� 
%       ��������� ������������������� DxT - D - ����������� ������ ���������
%       , T - ����� ������������������
% �������� ������:
%       arrayLL - ������ �������� ������������� (NxM) - N - ����������
%       �������, M - ���������� �������� ��������
%%
for i = 1:size(dataTest,1)
    p = dataTest{i};
    parfor m = 1:size(cellNetKox,1)
       w= cellNetKox{m}.iw{1,1};       
       [S,R11] = size(w);
       [R2,Q] = size(p);
       z = zeros(S,Q);
       w = w';
       copies = zeros(1,Q);
       for ii=1:S
         z(ii,:) = sum((w(:,ii+copies)-p).^2,1);
       end;
       z = -z.^0.5;      
       prob = exp(z);
       loglik = sum(log(prob+eps));   
       arrayLL(i,m) = loglik;          
    end;
end;
arrayLL = arrayLL';