clear all;
clc;
rootpic = 'd:\git\phd_codesourse\LBPformTrainTestDataTextute\';
picNum = 1; 
row_map = 10;
col_map = 10;
epohs_map = 400;
for i=1:picNum;
    % filename = sprintf('%s\\images\\%06d.png', rootpic, i-1);
    filename = sprintf('%s\\images\\%s', rootpic,  '000007.png');
    Gray = imread(filename);
    Gray = rgb2gray(Gray);
    nrows = size(Gray,1);
    ncols = size(Gray,2);
    ab = reshape(Gray,nrows*ncols,1); 
    ab = double(ab);
    net = newsom(ab',[row_map col_map],'hextop','dist');
    net.trainParam.epochs = epohs_map;
    [net] = train(net,ab');    
    w = net.iw{1,1};
    [S,R11] = size(w);
    [R2,Q] = size(ab');
    z = zeros(S,Q);
    w = w';
    copies = zeros(1,Q);
    for ii=1:S
     z(ii,:) = sum((w(:,ii+copies)-ab').^2,1);
    end;
    n = -z.^0.5;
    [maxn,rows] = max(n,[],1);
    z = zeros(1,S);
    for j=1:size(w,2)
        count = 0;
        for k=1:size(ab',2)
            if rows(k) == j
                count = count + 1;
                z(j) = z(j) + (w(j) - ab(k))^2;
            end;
        end;
        z(j) = z(j)/count;
    end; 
    beta = 0;
    for k=1:size(ab',2)
        index = rows(k);
        beta = beta + (w(index) - ab(k))^2;        
    end;
    beta = beta / size(ab',2);
end;
display(beta);
hold on;
Fsum = 0;
for i=1:length(w)
    X=0:0.2:300;
    MU=w(i);
    SIGMA=z(i);
    if ~isnan(SIGMA)
        f1 = normpdf(X,MU,SIGMA);
        Fsum = Fsum + f1;
        plot(X,f1);
    end;
end;
%plot(X,Fsum,'-r');