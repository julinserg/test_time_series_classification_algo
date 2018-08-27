% инициализация
states_number   = 6;
class_number = 5;
dimension       = 15; 
timeseries_length    = 50; 
nsamples  = 200; 
dataTrain = cell(size(dimension,2),nsamples);
dataTest = cell(size(dimension,2),nsamples);
% генерация случайных последовательностей для тестовой и обучающей выборок
for i=1:class_number   
   hmmSource = mkRndGaussHmm(states_number, dimension); 
   [data1, ~]  = hmmSample(hmmSource, timeseries_length, nsamples);    
   [data2, ~]  = hmmSample(hmmSource, timeseries_length, nsamples); 
   dataTrain(i,:) = data1';
   dataTest(i,:) = data2';
end
% добавление шума в обучающую выборку
for i=1:size(dataTrain,1)
    for j=1:size(dataTrain,2)
         matrixT = dataTrain{i,j};
         for k=1:size(matrixT,1)
            matrixT(k,:) = awgn( matrixT(k,:), 0.1, 'measured');
         end
         dataTrain{i,j} = matrixT;  
    end
end
