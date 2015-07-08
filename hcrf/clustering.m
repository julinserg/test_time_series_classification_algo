function [] = clustering(dataTrainArabicDigit)
%% выполнение кластеризации картой Кохонена
    % все исходные обучающие данные записываються в одну карту 100 на 100
    % сохранение информация о принадлежности каждого отчета определнному кластеру
    % сохранени информации о расстоянии между кластерами
% clc;
% clear;
% load dataTrainArabicDigit.mat;
% 
% 
% 
% load mixoutALL_shifted;
% 
% mixoutNew = cell(1,1);
% %mixoutNew{1,1} = mixout{1,1};
% mixoutNew = cell(1,1);
% mixoutNew{1,1} = mixout{1,1};
% il = 1;
% jl = 1;
% for i=2:size(consts.charlabels,2)
%     if consts.charlabels(i) == consts.charlabels(i-1) 
%        k = 1;
%         for j=1:size(mixout{1,i},2)
%             if ~(mixout{1,i}(1,j) == 0 && mixout{1,i}(2,j) == 0 && mixout{1,i}(3,j) == 0)
%                 arr(:,k) = mixout{1,i}(:,j);
%                 k = k+1;
%             end;
%         end;
%        mixoutNew{il,jl} = arr; 
%        jl = jl + 1;
%     else
%        il = il + 1;
%        jl = 1;   
%        k = 1;
%         for j=1:size(mixout{1,i},2)
%             if ~(mixout{1,i}(1,j) == 0 && mixout{1,i}(2,j) == 0 && mixout{1,i}(3,j) == 0)
%                 arr(:,k) = mixout{1,i}(:,j);
%                 k = k+1;
%             end;
%         end;
%         mixoutNew{il,jl} = arr; 
%     end;    
% end;
% 
% dataTrainArabicDigit = mixoutNew;
% 
%  dataTrainArabicDigit = dataTrainArabicDigit(1:10,1:5);

%модуль непрерывности
% for ii=1:size(dataTrainArabicDigit,1)
% for jj=1:size(dataTrainArabicDigit,2)
%     
% for i=1:size(dataTrainArabicDigit{ii,jj},1)
%   for j=1:size(dataTrainArabicDigit{ii,jj},2)
%     index = 1;
%     clear('selectForMax');
%     if j > 1
%       for k=1:j-1
%         for l=k+1:j
%           selectForMax(index) = abs(dataTrainArabicDigit{ii,jj}(i,k) - dataTrainArabicDigit{ii,jj}(i,l));
%           index = index +1;
%         end;           
%       end; 
%     else
%       selectForMax(index) = 0;      
%     end;
%     M(i,j) = sign(dataTrainArabicDigit{ii,jj}(i,j))*max(selectForMax);
%   end;   
% end;
% dataTrainArabicDigit{ii,jj} = M;
% ii
% jj
% end;
% end;
% dataTestArabicDigit = dataTrainArabicDigit;
% save('dataTestArabicDigitModul.mat','dataTestArabicDigit');

k = 1;
row = 5;
col = 5;

%net.trainParam.epochs = 200;
%pp = net.IW;
%net.inputs{1,1}.userdata.curEpoh = 1;
%epochs = 200;
%for ep=1:epochs  

 index = 1;
arrayBeginClass(1) = 1;
for i=1:size(dataTrainArabicDigit,1)
    %clear('dataTrain','u','a');
    %k = 1;
    for j=1:size(dataTrainArabicDigit,2);
        u = size(dataTrainArabicDigit{i,j},2);
        a = dataTrainArabicDigit{i,j};
        dataTrain(:,k:k+u-1) = a;       
        k = k+size(a,2);
        arrayEnd(index) = k-1;
        index = index + 1;
       % dataTrain(:,k) = [666,666,666];
       % k = k+1;
       % ep
       % i
        %j
        %net.inputs{1,1}.userdata.curEpoh = ep;
        %[net,tr] = train(net,dataTrainArabicDigit{i,j});        
    end; 
    if (i< size(dataTrainArabicDigit,1))
        arrayBeginClass(i+1) = k;
    end;
   %j
   %net.inputs{1,1}.userdata.arrayBeginClass = arrayBeginClass;
   %net.inputs{1,1}.userdata.arrayEnd = arrayEnd;
   %[net,tr] = train(net,dataTrain);
end; 
%ep
%end;
ppp = arrayEnd;
net = newsom(dataTrain,[row col],'hextop','dist');
net.inputs{1,1}.userdata.curEpoh = 0;
net.inputs{1,1}.userdata.arrayEnd = arrayEnd;
net.inputs{1,1}.userdata.arrayBeginClass = arrayBeginClass;
net.trainParam.epochs = 10;
[net,tr] = train(net,dataTrain);
net2 = net;

% load net2;
% weights = net2.iw{1,1};
% for i=1:size(dataTrainArabicDigit,1)
%     for j=1:size(dataTrainArabicDigit,2)
%        % for k=1:size(dataTrainArabicDigit{i,j},2)            
%           %  p = sim(net2,dataTrainArabicDigit{i,j}(:,k));
%             net2.inputs{1,1}.userdata.arrayEnd = size(dataTrainArabicDigit{i,j},2);
%             p = sim(net2,dataTrainArabicDigit{i,j});
%             pp = vec2ind(p);      
%             dataTrainArabicDigit{i,j}(14,:) = pp; 
%             hhh = weights(pp,:)';
%             dataTrainArabicDigit{i,j}(16:18,:) =hhh;
%             %dataTrainArabicDigit{i,j}(1:15,:) = [];
%        % end;
%     end;
% end;
% 
% dataTestArabicDigit = getTestDataOnTest(1);
% for i=1:size(dataTestArabicDigit,1)
%     for j=1:size(dataTestArabicDigit,2)
%        % for k=1:size(dataTrainArabicDigit{i,j},2)            
%           %  p = sim(net2,dataTrainArabicDigit{i,j}(:,k));
%             net2.inputs{1,1}.userdata.arrayEnd = size(dataTestArabicDigit{i,j},2);
%             p = sim(net2,dataTestArabicDigit{i,j});
%             pp = vec2ind(p);      
%             dataTestArabicDigit{i,j}(14,:) = pp; 
%             hhh = weights(pp,:)';
%             dataTestArabicDigit{i,j}(16:18,:) =hhh;
%             %dataTestArabicDigit{i,j}(1:15,:) = [];
%        % end;
%     end;
% end;
% t = 0;

% y = dataTrainArabicDigit{1,1}(16,:);
% y = y(:,1:4:end);
% x = 1:1:size(y,2);
% xi = 1:0.25:size(y,2);
% InY = interp1(x,y,xi,'spline');

% net = newsom(dataTrain,[15 15],'hextop','dist');
% net.trainParam.epochs = 10;

% [net3,tr] = train(net2,dataTrain(:,11:20));
% [distanseKox] = calculateDist(net2);
% 
% %load net2;
% outputs = sim(net2,dataTrain);
% 
% pos = gridtop(row,col);
% distBox = boxdist(pos);
% % вывод номеров кластеров, которым принадлежат обучающие отчеты в файл
% out = cell(1,1);
% plotFraf_x = cell(1,1);
% plotFraf_y = cell(1,1);
% for i =2:2%size(dataTrainArabicDigit,1)
%     for j = 2:2%size(dataTrainArabicDigit,2)
%         for z = 1:size(dataTrainArabicDigit{i,j},2)
%              p = sim(net2,dataTrainArabicDigit{i,j}(:,z));
%              pp = vec2ind(p);
%              x(z) = fix(pp/row);
%              %ost = rem(pp,row);
%              y(z) = pp - col.*x(z);
%              out{i,j}(:,z) = pp;
%              if z ~= size(dataTrainArabicDigit{i,j},2)
%                   q = sim(net2,dataTrainArabicDigit{i,j}(:,z+1));
%                   qq = vec2ind(q);                  
%                   distArray(z) = distBox(pp,qq);                                   
%              end;            
%         end;        
%     end;   
%     plotFraf_x{1,i} =  x;
%     plotFraf_y{1,i} = y;
% end;
% zeeer  = size(find(distArray == 0),2);
% resDist = sum(distArray)/(size(distArray,2));
% plot(plotFraf_y{1,1},plotFraf_x{1,1},'--rs','LineWidth',2,...
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','g',...
%                 'MarkerSize',10); 
%plot(plotFraf_y{1,1},plotFraf_x{1,1},'-mo',plotFraf_y{1,2},plotFraf_x{1,2},'-ro'); 
%axis([0  col  0  row]);
%csvwrite('fileClusterTrain.csv',coordDataTrue);
%csvwrite('fileClusterTrainSize.csv',sizeCoordDataTrain);

% hits = sum(outputs,2);
% numNeurons = net2.layers{1}.size;
% for i=1:numNeurons
%   Probab(i) = hits(i);
% end
% sumN = sum(Probab);
% Probab = Probab/sumN;
% save('Probab.mat', 'Probab');
% save('distanseKox.mat', 'distanseKox');
% csvwrite('fileDist.csv',distanseKox);


save('net2.mat', 'net2');

% load dataTestArabicDigit.mat;
% dataTestArabicDigit = dataTestArabicDigit(1:5,1:220);
% k = 1;
% for i=1:size(dataTestArabicDigit,1)
%     for j=1:size(dataTestArabicDigit,2);
%         u = size(dataTestArabicDigit{i,j},2);
%         %dataTrain(:,k:u) = dataTrainArabicDigit{i,j};
%         a = dataTestArabicDigit{i,j};
%         dataTest(:,k:k+u-1) = a;
%         k = k+size(a,2);
%         sizeCoordDataTest(1,(i-1)*size(dataTestArabicDigit,2)+j) = u;
%     end;
% end;
% 
% % вывод номеров кластеров, которым принадлежат обучающие отчеты в файл
% for j =1:size(dataTrain,2)
%     p = sim(net2,dataTrain(:,j));
%     pp = vec2ind(p);   
%     coordDataTrue(1,j) = pp; 
%    
% end;
% csvwrite('fileClusterTrain.csv',coordDataTrue);
% csvwrite('fileClusterTrainSize.csv',sizeCoordDataTrain);
% 
% % вывод номеров кластеров, которым принадлежат тестовые отчеты в файл
% for j =1:size(dataTest,2)
%     p = sim(net2,dataTest(:,j));
%     pp = vec2ind(p);   
%     coordDataDetect(1,j) = pp;   
% end;
% csvwrite('fileClusterTest.csv',coordDataDetect);
% csvwrite('fileClusterTestSize.csv',sizeCoordDataTest);

