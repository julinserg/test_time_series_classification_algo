clear;
clc;
% 
% f = @(x,y,t) t.*exp(-x.^2 - y.^2);
% [x,y,t] = ndgrid(-1:0.2:1,-1:0.2:1,0:2:10);
% v = f(x,y,t);
% [xi,yi,ti] = ndgrid(-1:0.05:1,-1:0.08:1, ...
%                        0:0.5:10);
% vi = interpn(x,y,t,v,xi,yi,ti,'spline');

dataTrainArabicDigit = getTrainData(1);
fprintf('Start train Koh\n');
clustering(dataTrainArabicDigit);
fprintf('Stop train Koh\n');