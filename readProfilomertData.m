clear;
clc;
fprintf('Start form data');
Profil1 = csvread('D:\bitbucket_proj\phd_codesourse\shared\exdata\profile\C1_.csv');
Profil2 = csvread('D:\bitbucket_proj\phd_codesourse\shared\exdata\profile\C2_.csv');

Tw = 25; %analysis frame duration (ms)
Ts = 10;           % analysis frame shift (ms)
alpha = 0.97;      % preemphasis coefficient
R = [ 1 700 ];  % frequency range to consider
M = 20;            % number of filterbank channels 
C = 13;            % number of cepstral coefficients
L = 22;            % cepstral sine lifter parameter

% hamming window (see Eq. (5.2) on p.73 of [1])
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));

% Read speech samples, sampling rate and precision from file
[ speech, fs, nbits ] = wavread( 'sp10.wav' );

% Feature extraction (feature vectors as columns)
[ MFCCs, FBEs, frames ] = ...
              mfcc( Profil1(:,2), fs, Tw, Ts, alpha, hamming, R, M,C, L );
[ MFCCs2, FBEs2, frames2 ] = ...
              mfcc( Profil2(:,2), fs, Tw, Ts, alpha, hamming, R, M,C, L );

% Plot cepstrum over time
figure('Position', [30 100 800 200], 'PaperPositionMode', 'auto', ... 
     'color', 'w', 'PaperOrientation', 'landscape', 'Visible', 'on' ); 

imagesc( [1:size(MFCCs,2)], [0:C-1], MFCCs ); 
axis( 'xy' );
xlabel( 'Frame index' ); 
ylabel( 'Cepstrum index' );
title( 'Mel frequency cepstrum' );

dataTrainProfilogr = cell(2,1);
dataTestProfilogr = cell(2,1);

dataTrainProfilogr{1,1} = MFCCs;
dataTrainProfilogr{2,1} = MFCCs2;
dataTestProfilogr = dataTrainProfilogr;
save('dataTrainProfilogr.mat', 'dataTrainProfilogr','-v7.3');
save('dataTestProfilogr.mat', 'dataTestProfilogr','-v7.3');
fprintf('Stop form data');