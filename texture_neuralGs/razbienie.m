function [RawTest,countX,countY] = razbienie(window,Im)

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
        mapping=getmaplbphf(8);
        h=lbp(TestIm,1,8,mapping,'h');
        h=h/sum(h);
        histograms(1,:)=h;
        h=lbp(TestIm2,1,8,mapping,'h');
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

