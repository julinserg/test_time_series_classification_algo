clc;
clear;
x = -1:0.01:1;
m = 0;
s = 0.1;
%f = 1/(sqrt(2*pi)*s)*exp(-(x-m).^2/(2*(s^2)));
f1 = exp(-(x-m).^2/(2*(s^2)));
%hold on;
%plot(x,f);
plot(x,f1);
%hold off;