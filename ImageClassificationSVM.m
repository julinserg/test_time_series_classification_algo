trainingSet = imageDatastore({'d:\scienceProject\texture\kamni\D23.gif','d:\scienceProject\texture\kamni\D27.gif',...
    'd:\scienceProject\texture\setka\D3.gif', 'd:\scienceProject\texture\setka\D22.gif',...
    'd:\scienceProject\texture\kirpich\D1.gif', 'd:\scienceProject\texture\kirpich\D94.gif'});
trainingSet.Labels = {'1','1','2','2','3','3'};

testSet = imageDatastore({'d:\scienceProject\texture\kamni\D28.gif','d:\scienceProject\texture\kamni\D54.gif',...
    'd:\scienceProject\texture\setka\D35.gif', 'd:\scienceProject\texture\setka\D36.gif',...
    'd:\scienceProject\texture\kirpich\D95.gif', 'd:\scienceProject\texture\kirpich\D96.gif'});
testSet.Labels = {'1','1','2','2','3','3'};

bag = bagOfFeatures(trainingSet);
categoryClassifier = trainImageCategoryClassifier(trainingSet,bag);
confMatrix = evaluate(categoryClassifier,testSet);
error = 1 - mean(diag(confMatrix))