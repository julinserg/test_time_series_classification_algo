function main()
clear;
clc;
a = 0;
b = 100;
m1 = a + (b-a).*rand(1,1);
m2 = a + (b-a).*rand(1,1);
m3 = a + (b-a).*rand(1,1);
s1 = rand(1,1);
s2 = rand(1,1);
s3 = rand(1,1);
MU = [m1 m2 m3];
SIGMA = [s1 0 0
    0 s2 0
    0 0 s3];

R = mvnrnd(MU,SIGMA,1000);
R = [R R];
Roystest(R);
HZmvntest(R);
%Mskekur(R,1);
t =0;
end