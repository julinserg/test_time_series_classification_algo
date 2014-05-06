function result = ExtractMultiplePartsOfAMatrix(a,i,j)
%
% это координаты кубиков, левый верхний для каждого кубика
%
%x=[1 1 6 6];
%y=[1 6 1 6];
%
% а это сама нарезка
%
[I,J] = ndgrid(1:i:j,1:i:j);
y=I(:);
x=J(:);
indexFcn = @(r,c) a(r:(r+i-1),c:(c+i-1));
result = arrayfun(indexFcn,x,y,'UniformOutput',false);
result = cat(3,result{:});