clc;
clear;
ss = csvread(['D:\bitbucket_proj\phd_codesourse\shared\' 'ISTANBUL_STOCK_EXCHANGE_Data_Set.csv']);  
dataTrainISE100 = cell(1,1);
dataTrainISE100{1,1} = ss';
save('dataTrainISE100.mat', 'dataTrainISE100','-v7.3');