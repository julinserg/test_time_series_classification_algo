function [] = calcDataForInitHCRF(model)

f = 0;
index= 1;
for i=1:model.nclasses
    matrixTrans = model.classConditionals{i,1}.A;
    for j=1:size(matrixTrans,1)
      for l=1:size(matrixTrans,2)
          out(index) = matrixTrans(j,l);
          index = index + 1;
      end;
    end;
end;
initDataTransHMMtoHCRF = out;
save ('initDataTransHMMtoHCRF.mat','initDataTransHMMtoHCRF');
