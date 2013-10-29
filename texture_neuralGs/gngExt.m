function [neuralGasMap] = gngExt(D,MAX_UNITS,MAX_TRAIN_LEN)

INIT_UNITS=2;
RANDOMIZE_DATA=1;
NGPLUS_INSERTION=1;
LAMBDA=size(D,1)*1;
ERROR_NEW_FACTOR=0.5;
ERROR_ALL_FACTOR=0.8;
%MAX_TRAIN_LEN=60;
COSINE=0;
MAX_LINK_AGE=size(D,1)/2;
ALPHA1=0.1;
ALPHA2=0.001;
%MAX_UNITS=35;
LOCK_TIME=size(D,1)*2;

%initialize random number generator
rand('state',sum(100*clock));

%random selection of INIT_UNITS initial units
if (INIT_UNITS>size(D,1))
    disp('Number of initial units is larger than the dataset');
    return;
end

%initial codebook
randIndeces = randperm(size(D,1));
M=D(randIndeces(1:INIT_UNITS),:);
M_OLD = M;

%matrices needed for training
%init linkMatrix: stores link information: links, link ages
linkMatrix = zeros(size(M,1),size(M,1));
linkStrength = linkMatrix;
lockedUnits = zeros(size(M,1),1);
qerrTotalUnits = zeros(size(M,1),1);

%threshold inits for each epoch
epochs=0;
epochIterationCount=0;
completeIterationCount=0;
traceData=cell(0);
lastEpoch=0;
logcount=0;
while (epochs<MAX_TRAIN_LEN)
  epochs=epochs+1;
  
  if epochs == MAX_TRAIN_LEN
      lastEpoch = 1;
  end;
  
  %randomize order of data
  if (RANDOMIZE_DATA==1) 
    randIndeces=randperm(size(D,1));
    D = D(randIndeces,:);
  else
    randIndeces=1:size(D,1);
  end
  
  %print info
  %fprintf(1,'Steps: %i/%i\n',epochs,MAX_TRAIN_LEN); 
  %fprintf(1,'Units: %i\n',size(M,1)); 
      
  %figure(1)
  %plot_neural_gas(M,D,linkMatrix);
  %pause
  
  INSERTION_ITERATION_LOG=200;
  
  
  for ind=1:length(randIndeces)
      epochIterationCount=epochIterationCount+1;
      completeIterationCount=completeIterationCount+1;
      
      % pick one sample vector
      x = D(randIndeces(ind),:); 
      
      % find 1st and 2nd BMU and their errors (distance to x)
      [bmu1,bmu2,errorBmu1,errorBmu2] = get_bmus(M,x,COSINE);
      
      if ((lastEpoch == 1) && (ind==1))
        linkStrength=linkMatrix;
        linkStrength(:)=-1;
      end
      
      if ((lastEpoch == 1))
        linkStrength(bmu1,bmu2)=linkStrength(bmu1,bmu2)+1;
        linkStrength(bmu2,bmu1)=linkStrength(bmu1,bmu2);
      end
      
      
      % link age, link creation
      %increase link age for all links from/to bmu1
      bmu1ToOtherLinks = linkMatrix(bmu1,:);
      otherToBmu1Links = linkMatrix(:,bmu1);
      linkIndex = bmu1ToOtherLinks>=0;
      bmu1ToOtherLinks(linkIndex)=bmu1ToOtherLinks(linkIndex)+1;
      otherToBmu1Links(linkIndex)=otherToBmu1Links(linkIndex)+1;
      linkMatrix(bmu1,:)=bmu1ToOtherLinks;
      linkMatrix(:,bmu1)=otherToBmu1Links;
      linkMatrix(bmu1,bmu1)=-1;
      % reset link age of link between bmu1/bmu2
      linkMatrix(bmu1,bmu2)=0;
      linkMatrix(bmu2,bmu1)=0;
      %check link age and remove links with age larger than MAX_LINK_AGE
      linkMatrixFlat = linkMatrix(:);
      tooOldLinkIndex = linkMatrixFlat>=MAX_LINK_AGE;
      linkMatrixFlat(tooOldLinkIndex) = -1;
      linkMatrix = reshape(linkMatrixFlat,size(M,1),size(M,1));
      %decrease lock time of each unit
      lockedUnits=lockedUnits-1;
      
      % increase error rate of bmu1
      qerrTotalUnits(bmu1) = qerrTotalUnits(bmu1) + errorBmu1;
      
      %update units with learning rates alpha1 (for bmu) and alpha2 (for neighbors)
      bmu1ToOtherLinks = linkMatrix(bmu1,:);
      linkIndex = bmu1ToOtherLinks>=0;
      h=zeros(size(M,1),1);
      h(linkIndex)=ALPHA2;
      h(bmu1)=ALPHA1;
      index = h>0;
    
      Dx = M(index,:) - x(ones(sum(index),1),:);                      % each map unit minus the vector
      M(index,:) = double(M(index,:)) - double(h(index,ones(size(x,2),1))).*double(Dx);
      
      [error,bmu1stError] = max(qerrTotalUnits);
      
     
      
      
   
      if (size(M,1)<MAX_UNITS && epochIterationCount >= LAMBDA && (lockedUnits(bmu1stError)<=0) && (lastEpoch==0))
         %traceMap.D = D;
         %traceMap.M = M;
         %traceMap.linkMatrix = linkMatrix;
         %traceMap.COSINE = COSINE;
         %traceMap.mdl = MDL(traceMap);    
        % traceData{end+1}=traceMap;
        logcount=INSERTION_ITERATION_LOG;
        
        epochIterationCount=0;
        bmuNew = size(M,1)+1;
        if (NGPLUS_INSERTION==1)
            %NGPLUS insertion
            %add new Unit at almost the same location as the old one/
            %avoids misplacement
            newUnit = M(bmu1stError,:)+eps;
        else
            %GNG insertion
            bmuNeighbors = linkMatrix(bmu1stError,:);
            bmuNeighbors(bmu1stError)=-1;
            bmus=1:size(M,1);
            index=bmuNeighbors>=0;
            qerrTotalUnits=qerrTotalUnits(index);
            bmus = bmus(index);
            [value index] = max(qerrTotalUnits);
            bmu2ndError = bmus(index);
            newUnit = (M(bmu1stError,:)+M(bmu2ndError,:))/2;
        end
        M(bmuNew,:)=newUnit;
        qerrTotalUnits(bmuNew) = 0;
        if size(M,1) ~= size(M_OLD,1)
            traceMap.M = M;
            traceData{end+1}=traceMap; 
        end;
        M_OLD = M;

        %init link from the new BMU to itself
        linkMatrix(bmuNew,:)=-1;
        linkMatrix(:,bmuNew)=-1;
        lockedUnits(bmuNew)=LOCK_TIME;


        if (NGPLUS_INSERTION == 1)
            %NGPLUS insertion
            qerrTotalUnits(bmu1stError) = qerrTotalUnits(bmu1stError)/2;
            qerrTotalUnits(bmuNew) = qerrTotalUnits(bmu1stError)/2;
            linkMatrix(bmu1stError,bmuNew)=0;
            linkMatrix(bmuNew,bmu1stError)=0;
        else
            %GNG insertion
            %reset link between bmu1 and bmu2
            qerrTotalUnits(bmu1stError) = qerrTotalUnits(bmu1stError)*ERROR_NEW_FACTOR;
            qerrTotalUnits(bmu2ndError) = qerrTotalUnits(bmu1stError)*ERROR_NEW_FACTOR;
            qerrTotalUnits(bmuNew) = qerrTotalUnits(bmu1stError);
            linkMatrix(bmu1stError,bmu2ndError)=-1;
            linkMatrix(bmu2ndError,bmu1stError)=-1;
            linkMatrix(bmu2ndError,bmuNew)=0;
            linkMatrix(bmuNew,bmu2ndError)=0;
            linkMatrix(bmu1stError,bmuNew)=0;
            linkMatrix(bmuNew,bmu1stError)=0;
        end
        
      end;
     
     % if (logcount>0)
            %traceMap.D = D;
            %traceMap.M = M;
            %traceMap.linkMatrix = linkMatrix;
            %traceMap.COSINE = COSINE;
            %traceMap.mdl = MDL(traceMap);    
            %traceData{end+1}=traceMap;
            %logcount=logcount-1;
     % end
      
     
      qerrTotalUnits=qerrTotalUnits*ERROR_ALL_FACTOR;
  end;
%    if size(traceData,2) > 0      
%      % if size(traceData{end}.linkMatrix,2) < size(linkMatrix,2)
%          % traceMap.D = D;
%           traceMap.M = M;
%           traceMap.linkMatrix = linkMatrix;
%          % traceMap.COSINE = COSINE;
%           traceData{end+1}=traceMap;  
%      % end;
%    else
%      % traceMap.D = D;
%       traceMap.M = M;
%       traceMap.linkMatrix = linkMatrix;
%       %traceMap.COSINE = COSINE;
%       traceData{end+1}=traceMap;   
%   end;

  
  %figure(1)
  %plot_neural_gas(M,D,ones(size(M,1),1),linkMatrix);
%  plot_neural_gas(M,D,[],linkMatrix);
  %pause;
  %pause;
  %movie_clip(epochs)=getframe;
end;
neuralGasMap.codeBook = M;
neuralGasMap.linkMatrix = linkStrength;
neuralGasMap.traceData = traceData;
neuralGasMap.COSINE = COSINE;

%neuralGasMap = findClusters(neuralGasMap);
return

function [bmu1,bmu2,error_bmu1,error_bmu2] = get_bmus(M,x,COSINE)
    if COSINE == 0
          %euclidean distance
          Dx = M - x(ones(size(M,1),1),:);     % each map unit minus the vector
          XX = (Dx.^2);
          YY = ones(size(M,2),1);
          result = double(XX)*double(YY);
    else
          %cosine distance
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