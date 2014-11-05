function [arrDist] = calculateDist(net)

% Setup edges
numNeurons = size(net.iw{1,1},1);
hh = sparse(tril(net.layers{1}.distances <= 1.001) - eye(numNeurons));
ud.neighbors = sparse(tril(net.layers{1}.distances <= 1.001) - eye(numNeurons));
ud.numEdges = sum(sum(ud.neighbors));
ud.patches = zeros(1,ud.numEdges);
ud.text = zeros(1,ud.numEdges);  

weights = net.iw{1,1};
levels = zeros(1,ud.numEdges);
k = 1;
for i=1:numNeurons
  for j=find(ud.neighbors(i,:))
    levels(k) = sqrt(sum((weights(i,:)-weights(j,:)).^2)); % -l2 norm
    %levels(k) =sum((weights(i,:)-weights(j,:)).^2); % squa L2 norm
   % levels(k) =sum(abs(weights(i,:)-weights(j,:))); % l1 norm
    k = k + 1;
  end
end
mm = minmax(levels);
levels = (levels-mm(1)) ./ (mm(2)-mm(1));
if mm(1) == mm(2), levels = zeros(size(levels)) + 0.5; end

k = 1;
arrDist = repmat(0,numNeurons,numNeurons);
for i=1:numNeurons
  for j=find(ud.neighbors(i,:))
    level = 1-levels(k);
   % arrDist(i,j) = level;
    red = min(level*2,1); % positive
    green = max(level*2-1,0); % very positive/negative
    %c = [red green 0];
    %c = min(1,nnred*2*(1-level));
    c = level;
%    set(ud.patches(k),'FaceColor',c);
    arrDist(i,j) = c;
    k = k + 1;
  end
end

