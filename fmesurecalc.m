N = 660*10; %����� ���������� ����������� �����������
TP = 0.90*N; % ��������� ����������������
TN = 0;
FP = 0.01*N; % ����������� ��������
FN = 0.09*N; % ����������� �����������

PR = TP / (TP+FP)
RE = TP / (TP+FN)
F = 2*PR*RE/ (PR+RE)