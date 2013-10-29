function [R] = arabic_digit_hcrf_gibrid_train(R,dataTrainArabicDigit,NUMBER)
%% about
%   классификация арабских цифр с помощью HCRF library - обучение модели

%% load train data
load arrayLogLikDataSetTrain
fprintf('..........Start train\n');
ENABLE_KOH = 0;

% 
labelTrainArabicDigit = cell(1,1);

for i=1:size(dataTrainArabicDigit,1)
    for j=1:size(dataTrainArabicDigit,2)
        labelTrainArabicDigit{i,j} = repmat(i-1, 1, size(dataTrainArabicDigit{i,j},2));
        
        s = size(dataTrainArabicDigit{i,j},1);
        s1 = size(arrayLogLikDataSetTrain{i,j},1);
        d = s+s1+1 - (s+1);
        d1 = size(arrayLogLikDataSetTrain{i,j},1);
        dataInsert =  arrayLogLikDataSetTrain{i,j}(:,:);
        index1 = s+1;
        index2 = s+s1;
        dataTrainArabicDigit{i,j}(index1:index2,:) = dataInsert;
       % inputMas = dataTrainArabicDigit{i,j};
       % Mas = cat(1, inputMas,dataInsert);
       % dataTrainArabicDigit{i,j} = Mas;
    end;
end;
dataTrainArabicDigitKox = cell(1,1);
dataTrainArabicDigitKox = dataTrainArabicDigit;
% load mixoutALL_shifted;
% 
% mixoutNew = cell(1,1);
% mixoutNew{1,1} = mixout{1,1};
% il = 1;
% jl = 1;
% for i=2:size(consts.charlabels,2)
%     if consts.charlabels(i) == consts.charlabels(i-1)
%        mixoutNew{il,jl} = mixout{1,i}; 
%        jl = jl + 1;
%     else
%        il = il + 1;
%        jl = 1;
%        mixoutNew{il,jl} = mixout{1,i};
%     end;
% end;
% 
% dataTrainArabicDigit = mixoutNew;


%% 14-ой размерность вставляем принадлежность к кластеру
if ENABLE_KOH == 1
%load net2;
if NUMBER == 1
  load net2_1;
end;
if NUMBER == 2
   load net2_2;
end;
if NUMBER == 3
   load net2_3;
end;
if NUMBER == 4
  load net2_4;
end;
if NUMBER == 5
    load net2_5;
end;
if NUMBER == 6
   load net2_5;
end;
% вывод номеров кластеров, которым принадлежат обучающие отчеты в файл

for i=1:size(dataTrainArabicDigit,1)
    for j=1:size(dataTrainArabicDigit,2)
       % for k=1:size(dataTrainArabicDigit{i,j},2)            
          %  p = sim(net2,dataTrainArabicDigit{i,j}(:,k));
            net2.inputs{1,1}.userdata.arrayEnd = size(dataTrainArabicDigit{i,j},2);
            p = sim(net2,dataTrainArabicDigit{i,j});
            pp = vec2ind(p);      
            dataTrainArabicDigitKox{i,j}(14,:) = pp;   
       % end;
    end;
end;
weights = net2.iw{1,1};
%% 15-ой размерность вставляем расстояние между кластерами
% load distanseKox;
% load Probab;
% maxVs = size(distanseKox,2);
% for i=1:size(dataTrainArabicDigitKox,1)
%     for j=1:size(dataTrainArabicDigitKox,2)         
%         for k=1:size(dataTrainArabicDigitKox{i,j},2)-1            
%             p = dataTrainArabicDigitKox{i,j}(14,k);
%             q = dataTrainArabicDigitKox{i,j}(14,k+1);
%             
%             if p == q
%                 temp = 1;
%             else
%                 if p == maxVs
%                     temp = distanseKox(p,q);
%                      if temp == 0
%                         temp = distanseKox(q,p);
%                     end;
%                 end;
%                 if q == maxVs
%                     temp = distanseKox(q,p);
%                      if temp == 0
%                         temp = distanseKox(p,q);
%                     end;
%                 end;
%                 if p ~= maxVs && q ~=maxVs
%                     temp =  distanseKox(p,q);
%                     if temp == 0
%                         temp = distanseKox(q,p);
%                     end;
%                 end;
%             end;           
%             % sumProb = Probab(1,p) + Probab(1,q);
%             dataTrainArabicDigitKox{i,j}(15,k) =temp; %log(sumProb)/temp;
%             
%         end;
%         dataTrainArabicDigitKox{i,j}(15,size(dataTrainArabicDigitKox{i,j},2)) = 0;
%     end;
% end;
for i=1:size(dataTrainArabicDigitKox,1)
    for j=1:size(dataTrainArabicDigitKox,2)
        % p = dataTrainArabicDigitKox{i,j}(14,1);
        % hhh = weights(p,:)';
        %dataTrainArabicDigitKox{i,j}(16:18,1) = hhh;          
      % for k=1:size(dataTrainArabicDigitKox{i,j},2)-1
            p = dataTrainArabicDigitKox{i,j}(14,:);
          %  q = dataTrainArabicDigitKox{i,j}(14,k+1);
            hhh = weights(p,:)';
         %   ggg = weights(q,:)';
            y = hhh;
            y = y(:,1:4:end);
            x = 1:1:size(y,2);
            xi = 1:0.25:size(y,2)+1;
            InY1 = interp1(x,y(1,:),xi,'spline');
            InY2 = interp1(x,y(2,:),xi,'spline'); 
            InY3 = interp1(x,y(3,:),xi,'spline');
            dataTrainArabicDigitKox{i,j}(16,:) =InY1(:,1:size(hhh,2));
            dataTrainArabicDigitKox{i,j}(17,:) =InY2(:,1:size(hhh,2));
            dataTrainArabicDigitKox{i,j}(18,:) =InY3(:,1:size(hhh,2));
           % dataTrainArabicDigitKox{i,j}(16:18,:) =hhh; %(hhh -ggg).^2;
           %dataTrainArabicDigitKox{i,j}(19,k) = norm(hhh-ggg);
       % end;        
    end;
end;
for i=1:size(dataTrainArabicDigitKox,1)
    for j=1:size(dataTrainArabicDigitKox,2)  
      dataTrainArabicDigitKox{i,j}(15,:) = [];
      dataTrainArabicDigitKox{i,j}(4:14,:) = [];   
    end;        
end;
end;
%% посчитаем среднее значение растояний и минимальную длину векторов дял
% каждого класса
% minLen = 10000;
% distARRAY(1:5,1:1000) = 0;
% for i=1:size(dataTrainArabicDigitKox,1)
%     for j=1:size(dataTrainArabicDigitKox,2)
%         if (size(dataTrainArabicDigitKox{i,j},2) <  minLen)
%             minLen = size(dataTrainArabicDigitKox{i,j},2);
%         end;
%         for k=1:size(dataTrainArabicDigitKox{i,j},2)
%             distARRAY(i,k) = distARRAY(i,k) + dataTrainArabicDigitKox{i,j}(15,k);
%         end;
%     end;
% end;
% for i=1:size(distARRAY,1)
%     for j=1:size(distARRAY,2)        
%         distARRAY(i,j) = distARRAY(i,j) /size(dataTrainArabicDigitKox,2) ;         
%     end;
% end;
% hF1 = figure;
% figure(hF1);
% x = 2:minLen; 
% xi = 2:.1:minLen;
% y1 = interp1(x,distARRAY(1,2:minLen),xi);
% y2 = interp1(x,distARRAY(2,2:minLen),xi);
% y3 = interp1(x,distARRAY(3,2:minLen),xi);
% y4 = interp1(x,distARRAY(4,2:minLen),xi);
% y5 = interp1(x,distARRAY(5,2:minLen),xi);
% 
% plot(xi,y1,'-k',xi,y2,'-+k',xi,y3,'-.k',xi,y4,':k',xi,y5,'-c');
% h = legend('class 0 ','class 1 ','class 2 ','class 3 ','class 4 ',5);
% set(h,'Interpreter','none');
% для 1 класса

% x = 1:minLen; 
% xi = 1:.1:minLen;
% y1 = interp1(x,dataTrainArabicDigitKox{1,1}(15,1:minLen),xi);
% y2 = interp1(x,dataTrainArabicDigitKox{1,2}(15,1:minLen),xi);
% y3 = interp1(x,dataTrainArabicDigitKox{1,3}(15,1:minLen),xi);
% y4 = interp1(x,dataTrainArabicDigitKox{1,4}(15,1:minLen),xi);
% y5 = interp1(x,dataTrainArabicDigitKox{1,5}(15,1:minLen),xi);
% 
% plot(xi,y1,'r',xi,y2,'g',xi,y3,'b',xi,y4,'c',xi,y5,'m');
%% посчитаем корреляцию
dataForCalcCorrelation = dataTrainArabicDigitKox;
save('dataForCalcCorrelation','dataForCalcCorrelation');
% 
%   m = dataTrainArabicDigitKox;
%     load dataTrainArabicDigitModul;
% %  %load dataTrainArabicDigitModifi;
% %  
%   for i=1:size(dataTrainArabicDigitKox,1)
%       for j=1:size(dataTrainArabicDigitKox,2)
%           dataTrainArabicDigit{i,j}(:,1) = dataTrainArabicDigit{i,j}(:,2);
%          dataTrainArabicDigitKox{i,j} = cat(1,m{i,j},dataTrainArabicDigit{i,j});         
%       end;      
%   end;
%% train
index = 1;
for i=1:size(dataTrainArabicDigitKox,1)
    for j=1:size(dataTrainArabicDigitKox,2);
       data(1,index) =   dataTrainArabicDigitKox(i,j);
       label(1,index) = labelTrainArabicDigit(i,j);
       index = index + 1;
    end;    
end; 
dataTrainArabicDigitKox = data;
labelTrainArabicDigit = label;
[R{2}.model R{2}.stats] = train(dataTrainArabicDigitKox, labelTrainArabicDigit, R{2}.params); 
fprintf('..........Stop train\n');
