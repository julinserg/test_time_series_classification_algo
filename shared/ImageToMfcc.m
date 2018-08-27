function [ MFCCs ] = ImageToMfcc( path )
Z = imread(path);
N = 32;
info = repmat(struct, ceil(size(Z, 1) / N), ceil(size(Z, 2) / N)); 
i = 1;
for row = 1:N:size(Z, 1)%loop through each pixel in the image matrix
   for col = 1:N:size(Z, 2)
     r = (row - 1) / N + 1;
     c = (col - 1) / N + 1;
     imgWindow = Z(row:min(end,row+N-1), col:min(end,col+N-1));
    average = mean(imgWindow(:)) %calculate the mean intensity of pixels within each window
    result(i) = average;
    i = i+1;
   end
end

Tw = 25; %analysis frame duration (ms)
Ts = 10;           % analysis frame shift (ms)
alpha = 0.97;      % preemphasis coefficient
R = [ 1 700 ];  % frequency range to consider
M = 20;            % number of filterbank channels 
C = 13;            % number of cepstral coefficients
L = 22;            % cepstral sine lifter parameter
fs = 2000;

% hamming window (see Eq. (5.2) on p.73 of [1])
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));

% Feature extraction (feature vectors as columns)
[ MFCCs, FBEs, frames ] = ...
              mfcc( result, fs, Tw, Ts, alpha, hamming, R, M,C, L );