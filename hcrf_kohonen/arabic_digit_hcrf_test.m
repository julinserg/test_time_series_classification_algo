function [loglikeTestArabicDigit labelTestArabicDigit] = arabic_digit_hcrf_test(dataTestArabicDigit,NUMBER)
%% about
%   классификация арабских цифр с помощью HCRF laybrary - тестирование

%% load test data
fprintf('..........Start test\n');
ENABLE_KOH = 0;
labelTestArabicDigit = cell(1,1);

for i=1:size(dataTestArabicDigit,1)
    for j=1:size(dataTestArabicDigit,2)
        labelTestArabicDigit{i,j} = i-1;
    end;
end;

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
% dataTestArabicDigit = mixoutNew;
dataTestArabicDigitKox = cell(1,1);
dataTestArabicDigitKox =  dataTestArabicDigit;
%% 14-ой размерность вставляем принадлежность к кластеру
if ENABLE_KOH == 1
%вывод номеров кластеров, которым принадлежат обучающие отчеты в файл
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
for i=1:size(dataTestArabicDigit,1)
    for j=1:size(dataTestArabicDigit,2)
       % for k=1:size(dataTestArabicDigit{i,j},2) 
            net2.inputs{1,1}.userdata.arrayEnd = size(dataTestArabicDigit{i,j},2);
            p = sim(net2,dataTestArabicDigit{i,j});
            pp = vec2ind(p);      
            dataTestArabicDigitKox{i,j}(14,:) = pp;   
        %end;
    end;
end;
weights = net2.iw{1,1};
%% 15-ой размерность вставляем расстояние между кластерами
% load distanseKox;
% load Probab;
% maxVs = size(distanseKox,2);
% for i=1:size(dataTestArabicDigitKox,1)
%     for j=1:size(dataTestArabicDigitKox,2)         
%         for k=1:size(dataTestArabicDigitKox{i,j},2)-1            
%             p = dataTestArabicDigitKox{i,j}(14,k);
%             q = dataTestArabicDigitKox{i,j}(14,k+1);
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
%              %sumProb = Probab(1,p) + Probab(1,q);
%             dataTestArabicDigitKox{i,j}(15,k) = temp; %log(sumProb)/temp;
%             
%         end;
%         dataTestArabicDigitKox{i,j}(15,size(dataTestArabicDigitKox{i,j},2)) = 0;
%     end;
% end;
for i=1:size(dataTestArabicDigitKox,1)
    for j=1:size(dataTestArabicDigitKox,2)
       %  p = dataTestArabicDigitKox{i,j}(14,1);
       %  hhh = weights(p,:)';
      %  dataTestArabicDigitKox{i,j}(16:18,1) = hhh;          
       % for k=1:size(dataTestArabicDigitKox{i,j},2)-1
            p = dataTestArabicDigitKox{i,j}(14,:);
          %  q = dataTestArabicDigitKox{i,j}(14,k+1);
            hhh = weights(p,:)';
          %  ggg = weights(q,:)';
            y = hhh;
            y = y(:,1:4:end);
            x = 1:1:size(y,2);
            xi = 1:0.25:size(y,2)+1;
            InY1 = interp1(x,y(1,:),xi,'spline');
            InY2 = interp1(x,y(2,:),xi,'spline'); 
            InY3 = interp1(x,y(3,:),xi,'spline');
            dataTestArabicDigitKox{i,j}(16,:) =InY1(:,1:size(hhh,2));
            dataTestArabicDigitKox{i,j}(17,:) =InY2(:,1:size(hhh,2));
            dataTestArabicDigitKox{i,j}(18,:) =InY3(:,1:size(hhh,2));
         %   dataTestArabicDigitKox{i,j}(16:18,:) = hhh;
       % end;        
    end;
end;
for i=1:size(dataTestArabicDigitKox,1)
    for j=1:size(dataTestArabicDigitKox,2)  
      dataTestArabicDigitKox{i,j}(15,:) = [];
      dataTestArabicDigitKox{i,j}(4:14,:) = [];   
    end;        
end;
end;
%% посчитаем среднее значение растояний и минимальную длину векторов дял
% каждого класса
% minLen = 10000;
% distARRAY(1:5,1:1000) = 0;
% for i=1:size(dataTestArabicDigitKox,1)
%     for j=1:size(dataTestArabicDigitKox,2)
%         if (size(dataTestArabicDigitKox{i,j},2) <  minLen)
%             minLen = size(dataTestArabicDigitKox{i,j},2);
%         end;
%         for k=1:size(dataTestArabicDigitKox{i,j},2)
%             distARRAY(i,k) = distARRAY(i,k) + dataTestArabicDigitKox{i,j}(15,k);
%         end;
%     end;
% end;
% for i=1:size(distARRAY,1)
%     for j=1:size(distARRAY,2)        
%         distARRAY(i,j) = distARRAY(i,j) /size(dataTestArabicDigitKox,2) ;         
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
% axis([2  22  0.2  1])


% m = dataTestArabicDigitKox;
% %load dataTestArabicDigitModifi;
% load dataTestArabicDigitModul;
% %load dataTestDeleteRepeat;
% %dataTestArabicDigit = dataTestDeleteRepeat;
% 
%     for i=1:size(dataTestArabicDigitKox,1)
%        for j=1:size(dataTestArabicDigitKox,2)
%           dataTestArabicDigit{i,j}(:,1) = dataTestArabicDigit{i,j}(:,2);
%           dataTestArabicDigitKox{i,j} = cat(1,m{i,j},dataTestArabicDigit{i,j}); 
%        end;
%     end;
%% test
loglikeTestArabicDigit = cell(1,1);
for i=1:size(dataTestArabicDigitKox,1)
    for j=1:size(dataTestArabicDigitKox,2)
        %labelTestArabicDigit{i,j} = repmat(i-1, 1, size(dataTestArabicDigit{i,j},2));
        matHCRF('setData',dataTestArabicDigitKox(i,j),[],int32(labelTestArabicDigit{i,j}(1,1)));
        matHCRF('test');
        ll =matHCRF('getResults');
        loglikeTestArabicDigit(i,j) = ll;
    end;
end;
fprintf('..........Stop test\n');
