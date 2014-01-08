clc;
clear all;
NUMBERPROPUSK =98;
USETRAIN = 1
SAVELOGLIKEFORGIBRID = 0
isOpen = matlabpool('size') > 0;
% if isOpen
%    matlabpool close; 
% end;
%matlabpool open local 12;
load sampleData;
dataTrainRaw = cell(1,1);
dataTest = cell(1,1);
%load initDataTransHMMtoHCRF
%paramsData.weightsPerSequence = ones(1,128) ;
%paramsData.factorSeqWeights = 1;
Im = imread('texture/test.png');

window = 10;
%windowLocal = 50;
NewSizeX = fix(size(Im,1)/window)*window;
NewSizeY = fix(size(Im,2)/window)*window;
Im = Im(1:NewSizeX,1:NewSizeY,:);

th = 1;
i = 1;
j = 1;
countX = 0;
countY = 0;
bX = 0;
bY = 0;
while bX <= size(Im,1)-window
    bX = i;
    eX = i+window-1;
    
    while bY <= size(Im,2)-window
        if countX == 0
            countY = countY + 1;
        end;
        bY = j;        
        eY = j+window-1;
        TestIm = Im(bX:eX,bY:eY,:);
        
        angle = 0;
        index = 1;
        mapping=getmaplbphf(8);
        while angle <= 270
            ImLocal=imrotate(TestIm,angle);
            h=lbp(ImLocal,1,8,mapping,'h');
            h=h/sum(h);
            histograms(index,:)=h;    
            index = index + 1;
            angle = angle + 30;
        end;        
        lbp_hf_features=constructhf(histograms,mapping);   
        dataTest(1,th) = {lbp_hf_features'};
        th = th +1;        
        j = j+window;    
    end; 
    countX = countX + 1;
    j= 1;
    bY = 0;
    i = i+window;    
end;

% for i =1:5
% filename = sprintf('texture\\road%01d.png', i);
% Im = imread(filename);
% NewSizeX = fix(size(Im,1)/windowLocal)*windowLocal;
% NewSizeY = fix(size(Im,2)/windowLocal)*windowLocal;
% Im = Im(1:NewSizeX,1:NewSizeY,:);
% RawTest = razbienie(windowLocal,Im);
% dataTrainRaw(1,i) = {RawTest'};
% end;
% 
% for i =1:5
% filename = sprintf('texture\\ground%01d.png', i);
% Im = imread(filename);
% NewSizeX = fix(size(Im,1)/windowLocal)*windowLocal;
% NewSizeY = fix(size(Im,2)/windowLocal)*windowLocal;
% Im = Im(1:NewSizeX,1:NewSizeY,:);
% RawTest = razbienie(windowLocal,Im);
% dataTrainRaw(2,i) = {RawTest'};
% end;
% 
% 
% for i =1:5
% filename = sprintf('texture\\les%01d.png', i);
% Im = imread(filename);
% NewSizeX = fix(size(Im,1)/windowLocal)*windowLocal;
% NewSizeY = fix(size(Im,2)/windowLocal)*windowLocal;
% Im = Im(1:NewSizeX,1:NewSizeY,:);
% RawTest = razbienie(windowLocal,Im);
% dataTrainRaw(3,i) = {RawTest'};
% end;
for i =1:5
filename = sprintf('texture\\road%01d.png', i);
Im = imread(filename);
angle = 0;
index = 1;
mapping=getmaplbphf(8);
while angle <= 270
    ImLocal=imrotate(Im,angle);
    h=lbp(ImLocal,1,8,mapping,'h');
    h=h/sum(h);
    histograms(index,:)=h;    
    index = index + 1;
    angle = angle + 30;
end;        
lbp_hf_features=constructhf(histograms,mapping); 
dataTrainRaw(1,i) = {lbp_hf_features'};
end;

for i =1:5
filename = sprintf('texture\\ground%01d.png', i);
Im = imread(filename);
angle = 0;
index = 1;
mapping=getmaplbphf(8);
while angle <= 270
    ImLocal=imrotate(Im,angle);
    h=lbp(ImLocal,1,8,mapping,'h');
    h=h/sum(h);
    histograms(index,:)=h;    
    index = index + 1;
    angle = angle + 30;
end;        
lbp_hf_features=constructhf(histograms,mapping); 
dataTrainRaw(2,i) = {lbp_hf_features'};
end;


for i =1:5
filename = sprintf('texture\\les%01d.png', i);
Im = imread(filename);
angle = 0;
index = 1;
mapping=getmaplbphf(8);
while angle <= 270
    ImLocal=imrotate(Im,angle);
    h=lbp(ImLocal,1,8,mapping,'h');
    h=h/sum(h);
    histograms(index,:)=h;    
    index = index + 1;
    angle = angle + 30;
end;        
lbp_hf_features=constructhf(histograms,mapping); 
dataTrainRaw(3,i) = {lbp_hf_features'};
end;



k = 1;
%dataTrainRaw = getTestDataOnTest(2);
for i=1:size(dataTrainRaw,1)
    for j=1:size(dataTrainRaw,2)
        dataTrain{k,1} = dataTrainRaw{i,j};       
        labelTrain(k,1) = i-1; 
        k = k+1;
    end;
end;
%dataTest =  getTrainData(2);

if 1 == 1
CountNet = [10 12];
%% обучаем карты Кохонена для каждого класса 
if USETRAIN == 1
k_1 = 1;
k_2 = 1;
countNeuron = 99999;
epohs = 10;
dataTrainForClass = cell(size(dataTrainRaw,1),1);
for i=1:size(dataTrain,1)  
    u = size(dataTrain{i},2);
    a = dataTrain{i};
    t = size(dataTrainForClass{labelTrain(i)+1},2) +1;        
    dataTrainForClass{labelTrain(i)+1}(:,t:t+u-1) = a;       
    k_1 = k_1+size(a,2);  
end; 
cellNetGas = cell(size(dataTrainRaw,1),1);
errorNeuralGas = cell(size(dataTrainRaw,1),1);

for i=1:size(dataTrainForClass,1)
  D = dataTrainForClass{i};
  netGas = gngExt(D',countNeuron,epohs);
%   for kk=1:size(netGas.traceData)
%       netGas.traceData{1,kk}.D = [];
%       netGas.traceData{1,kk}.linkMatrix = [];
%   end;  
  cellNetGas{i} = netGas;
end;
save('modelNeuronGas.mat', 'cellNetGas','-v7.3');
end;
%%
load modelNeuronGas;
loglistINDEX = 0;



  clear('Probability','arrayLL','arrayLabelDetect','arrayLabelTrue');
% %% вычисляем матрицу B (матрицу выходов) для каждого класса
% outputs = sim(net_class1,dataTrain_class1);
% hits = sum(outputs,2);
% numNeurons = net_class1.layers{1}.size;
% for i=1:numNeurons
%   Probab_class1(i) = hits(i);
% end
% sumN = sum(Probab_class1);
% Probab_class1 = Probab_class1/sumN;
% 
% outputs = sim(net_class2,dataTrain_class2);
% hits = sum(outputs,2);
% numNeurons = net_class2.layers{1}.size;
% for i=1:numNeurons
%   Probab_class2(i) = hits(i);
% end
% sumN = sum(Probab_class2);
% Probab_class2 = Probab_class2/sumN;
% Probab_class1 = normalizeLogspace(Probab_class1);
% Probab_class1 = exp(Probab_class1);
% Probab_class2 = normalizeLogspace(Probab_class2');
% Probab_class2 = exp(Probab_class2');
%% вычисляем матрицу А (матрицу выходов) для каждого класса
% weights_class1 = net_class1.iw{1,1};
% weights_class2 = net_class2.iw{1,1};
Probability = cell(size(cellNetGas,1),1);

for i=1:size(cellNetGas,1);
    t = cellNetGas{i};
    ry = size(t.traceData,2);
    w = t.traceData{1,ry}.M;
    sizeW = size(w,1);
    Probability{i}.A = repmat(0,sizeW,sizeW);
    Probability{i}.At = repmat(0,sizeW,1);
end;
%A_1 = repmat(0,size(weights_class1,1),size(weights_class1,1));
%A_2 = repmat(0,size(weights_class1,1),size(weights_class1,1));
%countTrans_1 = 0;
%countTrans_2 = 0;
for i=1:size(dataTrainRaw,1)
    for j=1:size(dataTrainRaw,2)
        %for k=1:size(dataTrainRaw{i,j},2)-1            
            %w= cellNetGas{i}.codeBook;
            t = cellNetGas{i};
            ry = size(t.traceData,2);
            w = t.traceData{1,ry}.M;
            p = dataTrainRaw{i,j};
            [S,R11] = size(w);
            [R2,Q] = size(p);
            z = zeros(S,Q);
            w = w';
            copies = zeros(1,Q);
            for ii=1:S
             z(ii,:) = sum((w(:,ii+copies)-p).^2,1);
               % d = w(:,ii+copies)-p;
               % z(ii,:) =  sum(abs(d),1);
            end;
            z = -z.^0.5;
            %z = -z;
            n= z;
            [maxn,rows] = max(n,[],1);
            array = rows;
            for k=1:size(array,2)-1
                pp = array(1,k);
                qq = array(1,k+1);
                Probability{i}.A(pp,qq) = Probability{i}.A(pp,qq) + 1;
                Probability{i}.At(pp) =  Probability{i}.At(pp) + 1;
            end;
%             pp = vec2ind(pr);              
%             pr = sim(cellNetKox{i},dataTrainRaw{i,j}(:,k+1));
%             qq = vec2ind(pr);
%             Probability{i}.A(pp,qq) = Probability{i}.A(pp,qq) + 1;       
       % end;
    end;
end;
%A_1 = A_1./countTrans_1;
%A_2 = A_2./countTrans_2;
% for i=1:size(Probability,1)
%     logA = normalizeLogspace(Probability{i}.A);
%     Probability{i}.A = exp(logA);
% end;
for i=1:size(Probability,1)
     for j=1:size(Probability{i}.A,2)
         if Probability{i}.At(j) ~= 0
            Probability{i}.A(j,:) = Probability{i}.A(j,:) ./  Probability{i}.At(j);
         end;
%        sumRow = sum(Probability{i}.A(:,j));
%        if sumRow ~= 0
%            devide = Probability{i}.A(:,j) ./ sumRow;
%        end;
%        %devide = Probability{i}.A(:,j);
        %devide(~devide) = 0.000001;
        %Probability{i}.A(:,j) = devide;
     end;
     %Probability{i}.A = ones(size(Probability{i}.A,2),size(Probability{i}.A,2));
      Probability{i}.A(~Probability{i}.A) = 0.0000001;  
%     %logA = normalizeLogspace(Probability{i}.A);
%     %Probability{i}.A = exp(logA);
%     linkMatrix = cellNetGas{i}.linkMatrix;
%     for j=1:size(linkMatrix,1)
%        for t=1:size(linkMatrix,2)
%            if linkMatrix(j,t) ~= -1
%               Probability{i}.A(j,t) = 1;
%            else
%               Probability{i}.A(j,t) = 0.0001;  
%            end;
%        end;
%     end;
    
end;
% logA1 = normalizeLogspace(A_1);
% A_1 = exp(logA1);
% logA2 = normalizeLogspace(A_2);
% A_2 = exp(logA2);
%A_1(~A_1) = 0.000001;
%A_2(~A_2) = 0.000001;
%% тест

%dataTest = getTrainData(1);
for i=1:size(dataTest,1)
    for j=1:size(dataTest,2)       
        labelTest{i,j}(1,1) = i-1; 
        k = k+1;
    end;
end;
if SAVELOGLIKEFORGIBRID == 1
    arrayLogLikDataSetTest = cell(1,1);
end;
index = 1;
for i = 1:size(dataTest,1)
  for j = 1:size(dataTest,2)
    if SAVELOGLIKEFORGIBRID == 0
        for m = 1:size(cellNetGas,1)
           %w= cellNetGas{m}.codeBook;
            t = cellNetGas{m};
             p = dataTest{i,j};
             ry = size(t.traceData,2);
            w = t.traceData{1,ry}.M;
            [S,R11] = size(w);
            [R2,Q] = size(p);
            z = zeros(S,Q);
            w = w';       

           copies = zeros(1,Q);
           for ii=1:S
             z(ii,:) = sum((w(:,ii+copies)-p).^2,1);              
            % d = w(:,ii+copies)-p;
            % z(ii,:) =  sum(abs(d),1);
           end;
           z = -z.^0.5;
           %z = -z;
           n= z;
           [maxn,rows] = max(n,[],1);
           [logB scale] = normalizeLogspace(n');
           B = exp(logB');
          %[logB scale] = normalize(n');
          %B = logB';
           pi = repmat(5,1,size(w',1));
           pi(1,rows(1,1)) = 10;
           pi = normalizeLogspace(pi);
           pi = exp(pi);
           A =  Probability{m}.A;
    %        resP = log(B(rows(1,1),1));
    %        for li=2:size(rows,2)
    %          t_cur = rows(1,li);
    %          t_prev = rows(1,li-1);
    %          resP = resP + log(A(t_prev,t_cur)) + log(B(t_cur,li));
    %        end;
    %        logp =resP;
           logp = hmmFilter(pi, A, B);
           %logp = 0;
           logp = logp + sum(scale);     
           arrayLL(index,m) = logp;       
        end;
        index = index + 1;
    end;  
  end;
end;




%arrayLL = exp(normalizeLogspace(arrayLL));
arrayLL = arrayLL';
for i=1:size(arrayLL,2)
    [c index] = max(arrayLL(:,i));
     arrayLabelDetect(1,i) = index-1;    
end;
i = 1;
j = 1;
t = 1;
while i <= countX*(window)
    bX = i;
    eX = i+window-1;
    while j <= countY*(window)
        bY = j;
        eY = j+window-1;
        arrayAnswer(bX:eX,bY:eY) = repmat(arrayLabelDetect(1,t),window,window);
        t = t + 1;
        j = j + window;
    end;
    j = 1;
    i = i + window;
end;
arrayAnswer  = flipdim(arrayAnswer,1);
% for i =1:size(labelTest,1)
%     for j=1:size(labelTest,2)
%      arrayLabelTrue(1,(i-1)*size(labelTest,2)+j) = labelTest{i,j}(1,1); 
%     end;
% end;
% calculateQuality(arrayLabelDetect,arrayLabelTrue,size(arrayLL,1));

loglist(loglistINDEX) = {arrayLL};


save('loglist.mat', 'loglist','-v7.3');
end;
load loglist
%loglist(~loglist) = -100;

CountSeq = size(dataTest,2);
NclassI = size(loglist{1},1);
NmodelI = length(loglist);
globDifAllSeq = repmat(0,NclassI,length(loglist));
b = 0;
e = 0;
for classI =1:NclassI
    b = e + 1;
    e = CountSeq*classI;
    for modelI=1:NmodelI        
        for dataSeqI=b:e        
            sumAllLogLike = 0;

            for i =1:NclassI           
               sumAllLogLike = sumAllLogLike +  exp(loglist{modelI}(i,dataSeqI));          
            end;

            val = exp(loglist{modelI}(classI,dataSeqI));
            logSum = log(sumAllLogLike);
            difAllLogLike = log(val/ sumAllLogLike);

        end;
        globDifAllSeq(classI,modelI) = globDifAllSeq(classI,modelI) + difAllLogLike; 
    end;
end;
mmi = mean(globDifAllSeq,1);
for i=1:size(mmi,2)-1
    dmmi(i) = mmi(i+1)-mmi(i);
end;
[vaM in] = max(mmi);
plot(mmi);
fprintf('Stop');

