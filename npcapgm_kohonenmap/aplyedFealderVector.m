clc;
clear;
dataTrainRaw = getTrainData(1);


row = 10;
col = 10;
epohs = 200;
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
  g = graph;
  resize(g,numNeurons);
  clear_edges(g); 
  distArray = calculateDist(net);
  distArrayCell{i} = distArray;
  for ii=1:size(distArray,1)
      for jj=1:size(distArray,2)
         if  distArray(ii,jj) < 0.5
              add(g,ii,jj);  
         end;
      end;
  end;
  %renumber(g,porydok);
  %L = laplacian(g);
 % [V,d] = eig(L);
  %v2 = V(:,2);
 % ppp = split(g);
 % clf; % erase the previous drawing
% cdraw(g,ppp);
  [ju,v2,rt] = cs_fiedler(matrix(g));
  v2 = v2(ju);
  FilderVect{i} = v2;
  free(g);
end;
index = 1;
epohs = 600;
%for i=m:size(dataTrainRaw,1)
for i=1:size(dataTrainRaw,1)
    for j=1:size(dataTrainRaw,2)         
          net = newsom(dataTrainRaw{i,j},[row col],'hextop','dist');
          net.trainParam.epochs = epohs;
          [net,tr] = train(net,dataTrainRaw{i,j});           
          numNeurons1 = size(net.iw{1,1},1);
          g = graph;
          resize(g,numNeurons1);
          clear_edges(g); 
          distArray = calculateDist(net);           
          for ii=1:size(distArray,1)
              for jj=1:size(distArray,2)
                 if  distArray(ii,jj) < 0.5
                      add(g,ii,jj);  
                 end;
              end;
          end;
          %renumber(g,porydok);
          %L = laplacian(g);
          %[V,d] = eig(L);
          %v2 = V(:,2);
          %[ju,v2,rt] = cs_fiedler(matrix(g));
          %v2 = v2(ju);
          FilderVectData{i,j} = v2;
          FilderVectDataNN(index,:) = v2;
          index = index + 1;
          free(g);
    end;
end;
index = 1;
for i = 1:size(dataTrainRaw,1)
  for j = 1:size(dataTrainRaw,2)
      for m=1:size(FilderVect,2)
        Fv = sum((FilderVect{m}-FilderVectData{i,j}).^2,1);
        Fv = -Fv.^0.5;
        arrayLLFldVec(index,m) = Fv;        
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
train = [FilderVectData{1,1},FilderVectData{1,2},FilderVectData{2,1},FilderVectData{2,2},FilderVectData{3,1},FilderVectData{3,2},FilderVectData{4,1},FilderVectData{4,2},FilderVectData{5,1},FilderVectData{5,2} ];
trainLable = [0,0, 1,1, 2 ,2,3 ,3,4,4];
[final_accu,PreLabel] = NNClassifier_L1(train,FilderVectDataNN',trainLable ,labelTrain');
[ff,gg, fmear,qual] = calculateQuality(arrayLabelDetectLaplas,labelTrain',size(arrayLLFldVec,1));
gg = 0;