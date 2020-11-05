clc;clear;
x = randn(100,2); 
%y = log(abs(randn(100,2)));
y = randn(100,2);
[pm,e_n] = minentest(x,y)