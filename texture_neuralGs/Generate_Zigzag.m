function [Indices, Indices_l] = Generate_Zigzag(N)
% ��������� �������� ��� ������ ������� �� �������
%     ������� ���������:
%                        N - ���������� ��������� � ���������� �������
%     �������� ���������:
%                        Indices - ������ (N^2,2), ���������� ������ �����
%                        � �������� ��������� ���������� ������� � �������
%                        ������. ������ ������� ������������� ������ ������,
%                        ������ ������� - ������ �������
%                        Indices_l - ������ (N^2,1), ���������� �� �� �����
%                        ����������, ��� � Indices, �� ������ ���������
%                        ��������� � ���� ����������� �������� �� ������
%                        �������. ��� ���� �����������, ��� ������� � MATLAB
%                        �������� �� ��������!
%--------------------------------------------------------------------------

Indices = zeros(N*N, 2); % ������� �������� ����� ��� ������� (N^2 x 2)
    % ������ ����������� �������� ������� (���� �������)
Indices(1, :) = [1 1];
a = 2;                     % �������� ������ � ������� ��������
       % ������������ ��������� ������ ������ 1 (���, ����� ������ � ���������)
for t=2:1:(2*N-2)          % � ������� NxN ����� ���� 2N-1 ����������. ���� ��� ������
       % ������� ������������ ������� �� ������ ������� ���������
       % � ������������ ����������� ��������� �������� �� ���
    if (rem(t,2)~=0)         % ���� ��������� �������� (rem � ������� �� �������)
        dr = 1; dc = -1;     % ���������� ��� �������� � ���������� �������� ���������
        if (t <= N)          % ����� ��������� ������ ��� �����������?
            P = t;           % ���� ������ - �� ����� ��������� ����� ������ ���������
            Indices(a, 1) = Indices(a-1, 1);
            Indices(a, 2) = Indices(a-1, 2)+1;
        else
            P = 2*N-t;       % �����: (2N - ����� ���������)
            Indices(a, 1) = Indices(a-1, 1)+1;
                                                                                         47


              Indices(a, 2) = Indices(a-1, 2);
          end
      else                    % ���� ��������� ������
          dr = -1; dc = 1;
          if (t <= N)         % ����� ��������� ������ ��� �����������?
              P = t;          % ���� ������ - �� ����� ��������� ����� ������ ���������
              Indices(a, 1) = Indices(a-1, 1) + 1;
              Indices(a, 2) = Indices(a-1, 2);
          else
              P = 2*N-t;      % �����: (2N - ����� ���������)
              Indices(a, 1) = Indices(a-1, 1);
              Indices(a, 2) = Indices(a-1, 2)+1;
          end
      end
      a = a + 1;              % ������ ������� ��������� ����������
          % ������ �������� �� ���������� ��������� ���������
      for i=2:1:P
          Indices(a, 1) = Indices(a-1, 1) + dr;
          Indices(a, 2) = Indices(a-1, 2) + dc;
          a = a + 1;
      end
end
    % ��������� ����������� �������� ������� (���� �������)
Indices(N*N, :) = [N N];
    % ������������� ����������� �������� ������� ���������
    % ��� �������������� (row,col) => ind ����� ��������������
    % ������� sub2ind ����
    % ix = sub2ind([n n], ind(:,1), ind(:,2));
    % �� ��������� ��� ����� "���������", �� ������ ���
    % ����� ������������ �������� �� ������ ������� "�������". ��� ����
    % ������� �������, ��� � MATLAB ��������� ������ �������� �� ��������.
Indices_l = (Indices(:,2)-1)*N + Indices(:,1);