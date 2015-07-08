function [post labelTest] = arabic_digit_hmm_test_koh(dataTestArabicDigit,model)
%% about
%   классификация с помощью HCRF laybrary - тестирование

%% load test data
fprintf('..........Start test\n');



dataTestArabicDigitKox = cell(1,1);
dataTestArabicDigitKox = dataTestArabicDigit;
%% 14-ой размерность вставляем принадлежность к кластеру
%вывод номеров кластеров, которым принадлежат обучающие отчеты в файл
load net2;
for i=1:size(dataTestArabicDigit,1)
    for j=1:size(dataTestArabicDigit,2)
       % for k=1:size(dataTestArabicDigit{i,j},2)            
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
%         % dataTestArabicDigitKox{i,j}(15,1) = 0;
%         for k=1:size(dataTestArabicDigitKox{i,j},2)            
%             p = dataTestArabicDigitKox{i,j}(14,k);
%             q = dataTestArabicDigitKox{i,j}(14,k);
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
%             dataTestArabicDigitKox{i,j}(15,k) = Probab(1,p);%temp; %log(sumProb)/temp;
%             
%         end;
%        
%     end;
% end;
for i=1:size(dataTestArabicDigitKox,1)
    for j=1:size(dataTestArabicDigitKox,2)
       %  p = dataTestArabicDigitKox{i,j}(14,1);
       %  hhh = weights(p,:)';
      %  dataTestArabicDigitKox{i,j}(16:18,1) = hhh;          
        %for k=1:size(dataTestArabicDigitKox{i,j},2)
            p = dataTestArabicDigitKox{i,j}(14,:);
          %  q = dataTestArabicDigitKox{i,j}(14,k+1);
            hhh = weights(p,:)';
           % ggg = weights(q,:)';
           dataTestArabicDigitKox{i,j}(16:18,:) =hhh;
          %  dataTestArabicDigitKox{i,j}(16:18,k) =  sign(dataTestArabicDigitKox{i,j}(1:3,k)).*sqrt(abs(dataTestArabicDigitKox{i,j}(1:3,k))); %hhh; %(hhh -ggg).^2;
        %end;        
    end;
end;
for i=1:size(dataTestArabicDigitKox,1)
    for j=1:size(dataTestArabicDigitKox,2)  
      dataTestArabicDigitKox{i,j}(15,:) = [];
      dataTestArabicDigitKox{i,j}(4:14,:) = [];   
    end;        
end;

dataTest = cell(1,1);
labelTest = cell(1,1);
k = 1;
for i=1:size(dataTestArabicDigit,1)
    for j=1:size(dataTestArabicDigit,2)
        dataTest{k,1} = dataTestArabicDigitKox{i,j};       
        labelTest{i,j}(1,1) = i-1; 
        k = k+1;
    end;
end;

%% test
logprobFn = @hmmLogprob;
[yhat, post] = generativeClassifierPredict(logprobFn, model,dataTest);

fprintf('..........Stop test\n');
