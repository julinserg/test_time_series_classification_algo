clc;
clear;
dataTrainRaw = getTrainData(1);


row = 10;
col = 10;
epohs = 100;
dataTrainForClass = cell(size(dataTrainRaw,1),1);
porydok = randperm(row*col);
k = 1;
k_1 = 1;
k_2 = 1;
for i=1:size(dataTrainRaw,1)
    for j=1:size(dataTrainRaw,2)
        dataTrain{k,1} = dataTrainRaw{i,j};
        labelTrain(k,1) = i-1; 
        k = k+1;
    end;
end;
for i=1:size(dataTrain,1)  
    u = size(dataTrain{i},2);
    a = dataTrain{i};
    t = size(dataTrainForClass{labelTrain(i)+1},2) +1;        
    dataTrainForClass{labelTrain(i)+1}(:,t:t+u-1) = a;       
    k_1 = k_1+size(a,2);  
end; 
for i=1:size(dataTrainForClass,1)
  i
  net = newsom(dataTrainForClass{i},[row col],'hextop','dist');
  net.trainParam.epochs = epohs;
  [net,tr] = train(net,dataTrainForClass{i});  
  numNeurons = size(net.iw{1,1},1);
 
  distArray = calculateDist(net);
   cellNetKox{i} = net;
   GraphGmodelG{i} = distArray;
   GraphWmodelW{i} = sparse(distArray > 0);
  
end;

dataTest =  getTestDataOnTest(1);
%dataTest = getTrainData(1);
%dataTest = getTestDataOnTest(4);
for i=1:size(dataTest,1)
    for j=1:size(dataTest,2)       
        labelTest{i,j}(1,1) = i-1; 
        k = k+1;
    end;
end;
index = 1;
for i=1:size(dataTest,1)
    for j=1:size(dataTest,2) 
        p = dataTest{i,j};
         for m = 1:size(cellNetKox,2)
           w= cellNetKox{m}.iw{1,1};       
           [S,R11] = size(w);
           [R2,Q] = size(p);
           z = zeros(S,Q);
           w = w';
           copies = zeros(1,Q);
           for ii=1:S
             z(ii,:) = sum((w(:,ii+copies)-p).^2,1); % l2-norm
           % z(ii,:) = sum(abs(w(:,ii+copies)-p),1); % l1 -norm
           end;
           z = -z.^0.5;     
           n= z;
           [maxn,rows] = max(z,[],1);
           Ar = repmat(0,size(GraphGmodelG{m},1),size(GraphGmodelG{m},2));
           Ar(:,rows) = GraphGmodelG{m}(:,rows);
           GraphG = Ar;
            GraphW = sparse(GraphG > 0);
            arrayLLFldVec(index,m) = matchingGraphs(0,GraphGmodelG{m},GraphWmodelW{m},GraphG,GraphW);    
         end;
          index = index + 1;
         
    end;
end;


index = 0;
arrayLLFldVec = arrayLLFldVec';
for i=1:size(arrayLLFldVec,2)
    [c index] = max(arrayLLFldVec(:,i));
     arrayLabelDetectLaplas(1,i) = index-1;    
end;
for i =1:size(labelTest,1)
    for j=1:size(labelTest,2)
     arrayLabelTrue(1,(i-1)*size(labelTest,2)+j) = labelTest{i,j}(1,1); 
    end;
end;
[ff,gg, fmear,qual] = calculateQuality(arrayLabelDetectLaplas,arrayLabelTrue,size(arrayLLFldVec,1));
gg = 0;