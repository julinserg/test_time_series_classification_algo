function [XY] = Generate_Spiral(n)
x = 0;
y = 1;
num = 1; % ���������� � ������� ������� (1 <= num <= n^2)
ln = n; % ����� ������� ������ (n >= ln >= 1)
inc = 1; % ���������� ��������� {-1, 1}
index = 0;
while (ln ~= 0)
  i = 0;
  while (i ~= ln)
    x = x + inc;
    a(y, x) = num;
    num = num + 1;
    i = i+1;
    index = index + 1;
    XY(index,1) = x;
    XY(index,2) = y;
  end
  i = 0;
  ln = ln-1;
  while (i ~= ln)
    y = y + inc;
    a(y,x) = num;
    num = num + 1;
    i = i + 1;
    index = index + 1;
    XY(index,1) = x;
    XY(index,2) = y;
  end
  inc = inc * (-1);
end
end