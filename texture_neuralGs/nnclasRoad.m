clc;
clear;
Im = imread('texture/test.png');

window = 15;
NewSizeX = fix(size(Im,1)/window)*window;
NewSizeY = fix(size(Im,2)/window)*window;
Im = Im(1:NewSizeX,1:NewSizeY,:);
testIm = Im;
radius = 1;
samples = 8;
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
        TestIm2=imrotate(TestIm,90);
        mapping=getmaplbphf(samples);
        h=lbp(TestIm,radius,samples,mapping,'h');
        h=h/sum(h);
        histograms(1,:)=h;
        h=lbp(TestIm2,radius,samples,mapping,'h');
        h=h/sum(h);
        histograms(2,:)=h;
        lbp_hf_features=constructhf(histograms,mapping);
        
        RawTest(th,:) = lbp_hf_features(1,:);
        th = th +1;        
        j = j+window;    
    end; 
    countX = countX + 1;
    j= 1;
    bY = 0;
    i = i+window;    
end;

for i =1:5
filename = sprintf('texture\\sground%01d.png', i);
Im = imread(filename);
Im2=imrotate(Im,90);
mapping=getmaplbphf(samples);
h=lbp(Im,radius,samples,mapping,'h');
h=h/sum(h);
histograms(1,:)=h;
h=lbp(Im2,radius,samples,mapping,'h');
h=h/sum(h);
histograms(2,:)=h;
lbp_hf_features=constructhf(histograms,mapping);
calassRoad(i,:) = lbp_hf_features(1,:);
end;

for i =1:5
filename = sprintf('texture\\ground%01d.png', i);
Im = imread(filename);
Im2=imrotate(Im,90);
mapping=getmaplbphf(samples);
h=lbp(Im,radius,samples,mapping,'h');
h=h/sum(h);
histograms(1,:)=h;
h=lbp(Im2,radius,samples,mapping,'h');
h=h/sum(h);
histograms(2,:)=h;
lbp_hf_features=constructhf(histograms,mapping);
calassGround(i,:) = lbp_hf_features(1,:);
end;


for i =1:5
filename = sprintf('texture\\les%01d.png', i);
Im = imread(filename);
Im2=imrotate(Im,90);
mapping=getmaplbphf(samples);
h=lbp(Im,radius,samples,mapping,'h');
h=h/sum(h);
histograms(1,:)=h;
h=lbp(Im2,radius,samples,mapping,'h');
h=h/sum(h);
histograms(2,:)=h;
lbp_hf_features=constructhf(histograms,mapping);
calassLes(i,:) = lbp_hf_features(1,:);
end;
trains = cat(1,calassRoad,calassGround,calassLes);
trainClassIDs = [0,0,0,0,0,1,1,1,1,1,2,2,2,2,2];
tests = RawTest;
testClassIDs = repmat(0,1,size(RawTest,1));
[final_accu,PreLabel] = NNClassifier_L1(trains',tests',trainClassIDs,testClassIDs);

i = 1;
j = 1;
t = 1;
while i <= countX*(window)
    bX = i;
    eX = i+window-1;
    while j <= countY*(window)
        bY = j;
        eY = j+window-1;
        arrayAnswer(bX:eX,bY:eY) = repmat(PreLabel(1,t),window,window);
        t = t + 1;
        j = j + window;
    end;
    j = 1;
    i = i + window;
end;
arrayAnswer  = flipdim(arrayAnswer,1);
image(testIm);
hold on
for i=1:size(testIm,1)
    for j=1:size(testIm,2)
        if arrayAnswer(i,j) == 0
            testIm(i,j,:) = [0 0 128];
        end;
        if arrayAnswer(i,j) == 1
             testIm(i,j,:) = [0 255 0];
        end;
        if arrayAnswer(i,j) == 2
             testIm(i,j,:) = [255 0 0];
        end;
    end;
end;
testIm  = flipdim(testIm,1);
image(testIm);










