clc;
clear;
%http://www.mustafabaydogan.com/multivariate-time-series-discretization-for-classification.html
%https://www.groundai.com/project/the-uea-multivariate-time-series-classification-archive-2018/1
%http://www.timeseriesclassification.com/dataset.php
rng('default');
r1 = normrnd(3,10,[600,5]); %нормальное
r2 = lognrnd(3,10,[600,5]); %логнормальное
r3 = poissrnd(20,[600,5]); %пуассона
r4 = wblrnd(1/2,1/2,[600,5]); % вейбула
r5 = trnd(3,600,5); %стьюдента
r6 = raylrnd(20,600,5); %релея
r7 = gamrnd(5,10,600,5); %гамма
r8 = frnd(2,2,600,5); %фишера
r9 = evrnd(3,10,[600,5]); % (экстримальное)
r10 = exprnd(5,600,5); % экспоненциальное
r11 = chi2rnd(6,[600,5]); % хи-квадрат
r12 = binornd(100,0.2,600,5); %биномиальное
r13 = betarnd(10,10,[600,5]); %бетта

r21 = getArrayExampleTrainData(1,'CharacterTrajectories_TRAIN.mat');
r22 = getArrayExampleTrainData(1,'SpokenArabicDigits_TRAIN.mat');
r22 = r22(1:10000,:);
r23 = getArrayExampleTrainData(1,'ArticularyWordRecognition_TRAIN.mat');
r24 = getArrayExampleTrainData(1,'AtrialFibrillation_TRAIN.mat');
r25 = getArrayExampleTrainData(1,'BasicMotions_TRAIN.mat');
r26 = getArrayExampleTrainData(1,'Cricket_TRAIN.mat');

                                            
Mskekur(r26,1,0.05,'Character Trajectories');