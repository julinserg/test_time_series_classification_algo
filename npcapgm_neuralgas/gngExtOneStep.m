function [neuralGasMap map] = gngExtOneStep(D,MAX_UNITS,isFirst,map)
if isFirst == 1
map.INIT_UNITS=2;
map.RANDOMIZE_DATA=1;
map.NGPLUS_INSERTION=1;
map.LAMBDA=size(D,1)*1;
map.ERROR_NEW_FACTOR=0.5;
map.ERROR_ALL_FACTOR=0.8;
%MAX_TRAIN_LEN=60;
map.COSINE=0;
map.MAX_LINK_AGE=size(D,1)/2;
map.ALPHA1=0.1;
map.ALPHA2=0.001;
%MAX_UNITS=35;
map.LOCK_TIME=size(D,1)*2;

%initialize random number generator
rand('state',sum(100*clock));

%random selection of map.INIT_UNITS initial units
if (map.INIT_UNITS>size(D,1))
    disp('Number of initial units is larger than the dataset');
    return;
end

%initial codebook
map.randIndeces = randperm(size(D,1));
map.M=D(map.randIndeces(1:map.INIT_UNITS),:);
map.M_OLD = map.M;

%matrices needed for training
%init map.linkMatrix: stores link information: links, link ages
map.linkMatrix = zeros(size(map.M,1),size(map.M,1));
map.linkStrength = map.linkMatrix;
map.lockedUnits = zeros(size(map.M,1),1);
map.qerrTotalUnits = zeros(size(map.M,1),1);

%threshold inits for each epoch
map.epochs=0;
map.epochIterationCount=0;
map.completeIterationCount=0;

map.lastEpoch=0;
map.logcount=0;
end;


  map.epochs=map.epochs+1;
  
  
  %randomize order of data
  if (map.RANDOMIZE_DATA==1) 
    map.randIndeces=randperm(size(D,1));
    D = D(map.randIndeces,:);
  else
    map.randIndeces=1:size(D,1);
  end
  
  %print info
  %fprintf(1,'Steps: %i/%i\n',map.epochs,MAX_TRAIN_LEN); 
  %fprintf(1,'Units: %i\n',size(map.M,1)); 
      
  %figure(1)
  %plot_neural_gas(map.M,D,map.linkMatrix);
  %pause
  
  INSERTION_ITERATION_LOG=200;
  
  
  for ind=1:length(map.randIndeces)
      map.epochIterationCount=map.epochIterationCount+1;
      map.completeIterationCount=map.completeIterationCount+1;
      
      % pick one sample vector
      x = D(map.randIndeces(ind),:); 
      
      % find 1st and 2nd BMU and their errors (distance to x)
      [bmu1,bmu2,errorBmu1,errorBmu2] = get_bmus(map.M,x,map.COSINE);
      
      if ((map.lastEpoch == 1) && (ind==1))
        map.linkStrength=map.linkMatrix;
        map.linkStrength(:)=-1;
      end
      
      if ((map.lastEpoch == 1))
        map.linkStrength(bmu1,bmu2)=map.linkStrength(bmu1,bmu2)+1;
        map.linkStrength(bmu2,bmu1)=map.linkStrength(bmu1,bmu2);
      end
      
      
      % link age, link creation
      %increase link age for all links from/to bmu1
      bmu1ToOtherLinks = map.linkMatrix(bmu1,:);
      otherToBmu1Links = map.linkMatrix(:,bmu1);
      linkIndex = bmu1ToOtherLinks>=0;
      bmu1ToOtherLinks(linkIndex)=bmu1ToOtherLinks(linkIndex)+1;
      otherToBmu1Links(linkIndex)=otherToBmu1Links(linkIndex)+1;
      map.linkMatrix(bmu1,:)=bmu1ToOtherLinks;
      map.linkMatrix(:,bmu1)=otherToBmu1Links;
      map.linkMatrix(bmu1,bmu1)=-1;
      % reset link age of link between bmu1/bmu2
      map.linkMatrix(bmu1,bmu2)=0;
      map.linkMatrix(bmu2,bmu1)=0;
      %check link age and remove links with age larger than map.MAX_LINK_AGE
      linkMatrixFlat = map.linkMatrix(:);
      tooOldLinkIndex = linkMatrixFlat>=map.MAX_LINK_AGE;
      linkMatrixFlat(tooOldLinkIndex) = -1;
      map.linkMatrix = reshape(linkMatrixFlat,size(map.M,1),size(map.M,1));
      %decrease lock time of each unit
      map.lockedUnits=map.lockedUnits-1;
      
      % increase error rate of bmu1
      map.qerrTotalUnits(bmu1) = map.qerrTotalUnits(bmu1) + errorBmu1;
      
      %update units with learning rates map.ALPHA1 (for bmu) and map.ALPHA2 (for neighbors)
      bmu1ToOtherLinks = map.linkMatrix(bmu1,:);
      linkIndex = bmu1ToOtherLinks>=0;
      h=zeros(size(map.M,1),1);
      h(linkIndex)=map.ALPHA2;
      h(bmu1)=map.ALPHA1;
      index = h>0;
    
      Dx = map.M(index,:) - x(ones(sum(index),1),:);                      % each map unit minus the vector
      map.M(index,:) = map.M(index,:) - h(index,ones(size(x,2),1)).*Dx;
      
      [error,bmu1stError] = max(map.qerrTotalUnits);
      
     
      
      
   
      if (size(map.M,1)<MAX_UNITS && map.epochIterationCount >= map.LAMBDA && (map.lockedUnits(bmu1stError)<=0) && (map.lastEpoch==0))
         %traceMap.D = D;
         %traceMap.map.M = map.M;
         %traceMap.map.linkMatrix = map.linkMatrix;
         %traceMap.map.COSINE = map.COSINE;
         %traceMap.mdl = MDL(traceMap);    
        % map.traceData{end+1}=traceMap;
        map.logcount=INSERTION_ITERATION_LOG;
        
        map.epochIterationCount=0;
        bmuNew = size(map.M,1)+1;
        if (map.NGPLUS_INSERTION==1)
            %NGPLUS insertion
            %add new Unit at almost the same location as the old one/
            %avoids misplacement
            newUnit = map.M(bmu1stError,:)+eps;
        else
            %GNG insertion
            bmuNeighbors = map.linkMatrix(bmu1stError,:);
            bmuNeighbors(bmu1stError)=-1;
            bmus=1:size(map.M,1);
            index=bmuNeighbors>=0;
            map.qerrTotalUnits=map.qerrTotalUnits(index);
            bmus = bmus(index);
            [value index] = max(map.qerrTotalUnits);
            bmu2ndError = bmus(index);
            newUnit = (map.M(bmu1stError,:)+map.M(bmu2ndError,:))/2;
        end
        map.M(bmuNew,:)=newUnit;
        map.qerrTotalUnits(bmuNew) = 0;
        if size(map.M,1) ~= size(map.M_OLD,1)
            traceMap.map.M = map.M;            
        end;
        map.M_OLD = map.M;

        %init link from the new BMU to itself
        map.linkMatrix(bmuNew,:)=-1;
        map.linkMatrix(:,bmuNew)=-1;
        map.lockedUnits(bmuNew)=map.LOCK_TIME;


        if (map.NGPLUS_INSERTION == 1)
            %NGPLUS insertion
            map.qerrTotalUnits(bmu1stError) = map.qerrTotalUnits(bmu1stError)/2;
            map.qerrTotalUnits(bmuNew) = map.qerrTotalUnits(bmu1stError)/2;
            map.linkMatrix(bmu1stError,bmuNew)=0;
            map.linkMatrix(bmuNew,bmu1stError)=0;
        else
            %GNG insertion
            %reset link between bmu1 and bmu2
            map.qerrTotalUnits(bmu1stError) = map.qerrTotalUnits(bmu1stError)*map.ERROR_NEW_FACTOR;
            map.qerrTotalUnits(bmu2ndError) = map.qerrTotalUnits(bmu1stError)*map.ERROR_NEW_FACTOR;
            map.qerrTotalUnits(bmuNew) = map.qerrTotalUnits(bmu1stError);
            map.linkMatrix(bmu1stError,bmu2ndError)=-1;
            map.linkMatrix(bmu2ndError,bmu1stError)=-1;
            map.linkMatrix(bmu2ndError,bmuNew)=0;
            map.linkMatrix(bmuNew,bmu2ndError)=0;
            map.linkMatrix(bmu1stError,bmuNew)=0;
            map.linkMatrix(bmuNew,bmu1stError)=0;
        end
        
      end;
     
     % if (map.logcount>0)
            %traceMap.D = D;
            %traceMap.map.M = map.M;
            %traceMap.map.linkMatrix = map.linkMatrix;
            %traceMap.map.COSINE = map.COSINE;
            %traceMap.mdl = MDL(traceMap);    
            %map.traceData{end+1}=traceMap;
            %map.logcount=map.logcount-1;
     % end
      
     
      map.qerrTotalUnits=map.qerrTotalUnits*map.ERROR_ALL_FACTOR;
  end;
%    if size(map.traceData,2) > 0      
%      % if size(map.traceData{end}.map.linkMatrix,2) < size(map.linkMatrix,2)
%          % traceMap.D = D;
%           traceMap.map.M = map.M;
%           traceMap.map.linkMatrix = map.linkMatrix;
%          % traceMap.map.COSINE = map.COSINE;
%           map.traceData{end+1}=traceMap;  
%      % end;
%    else
%      % traceMap.D = D;
%       traceMap.map.M = map.M;
%       traceMap.map.linkMatrix = map.linkMatrix;
%       %traceMap.map.COSINE = map.COSINE;
%       map.traceData{end+1}=traceMap;   
%   end;

  
  %figure(1)
  %plot_neural_gas(map.M,D,ones(size(map.M,1),1),map.linkMatrix);
%  plot_neural_gas(map.M,D,[],map.linkMatrix);
  %pause;
  %pause;
  %movie_clip(map.epochs)=getframe;

neuralGasMap.codeBook = map.M;
neuralGasMap.linkMatrix = map.linkStrength;
neuralGasMap.COSINE = map.COSINE;

%neuralGasMap = findClusters(neuralGasMap);
return

function [bmu1,bmu2,error_bmu1,error_bmu2] = get_bmus(M,x,COSINE)
    if COSINE == 0
          %euclidean distance
          Dx = M - x(ones(size(M,1),1),:);     % each map unit minus the vector
          result = (Dx.^2)*ones(size(M,2),1);
    else
          %map.COSINE distance
          if (sum(x)>0)
              onesM = ones(size(M,1),1);
              xNorm = sqrt(x*x');
              result = mod_distance(acos(sum((M.*x(onesM,:)),2)./(sqrt(sum(M.^2,2)).*xNorm)));
          else
              result = 0;
          end
    end
    [error_bmu1 bmu1] = min(result); 
    result(bmu1,:)=NaN;
    [error_bmu2 bmu2] = min(result); 
    return;   