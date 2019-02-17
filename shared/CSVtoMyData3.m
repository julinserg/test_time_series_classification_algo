clear;
clc;
display('Start');

% path_train = 'd:\scienceProject\seq_from_image\train\';
% list = dir(path_train);
% dataTrainTelem = cell(1,1);
% for i=1:length(list)
%     if list(i).isdir() == 0
%         Data = fileread([path_train list(i).name]);
%         Data = strrep(Data, ';', ',');
%         FID = fopen([path_train list(i).name], 'w');
%         fwrite(FID, Data, 'char');
%         fclose(FID);       
%     end
% end

%% толстые  и тонкие полоски
% Tw = 40; %analysis frame duration (ms)
% Ts = 5;           % analysis frame shift (ms)
% fs = 4000;
%% черные и серые полоски
% Tw = 20; %analysis frame duration (ms)
% Ts = 2;           % analysis frame shift (ms)
% fs = 16000;
%% текстуры
Tw = 40; %analysis frame duration (ms)
Ts = 5;           % analysis frame shift (ms)
fs = 4000;
%%
alpha = 0.97;      % preemphasis coefficient
R = [ 1 700 ];  % frequency range to consider
M = 20;            % number of filterbank channels 
C = 13;            % number of cepstral coefficients
L = 22;            % cepstral sine lifter parameter

% hamming window (see Eq. (5.2) on p.73 of [1])
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));


% Feature extraction (feature vectors as columns)

          
path_train = 'd:\scienceProject\seq_from_image\train\';
list = dir(path_train);
dataTrainTelem = cell(1,1);
for i=1:length(list)
    if list(i).isdir() == 0
        disp(list(i).name);
        index_line = findstr(list(i).name,'_');
        index_dot = findstr(list(i).name,'.');
        classStr = list(i).name(index_line(1)+1:index_line(2)-1);
        instansStr = list(i).name(index_line(3)+1:index_dot(1)-1);
        class = str2num(classStr);
        inst = str2num(instansStr);
        Profil = csvread([path_train list(i).name]);
        Profil = Profil';        
        [ MFCCs, FBEs, frames ] = ...
              mfcc( Profil(:,1), fs, Tw, Ts, alpha, hamming, R, M,C, L );
        dataTrainTelem{class,inst} = MFCCs;
    end
end

path_test = 'd:\scienceProject\seq_from_image\test\';
list = dir(path_test);
dataTestTelem = cell(1,1);
for i=1:length(list)
    if list(i).isdir() == 0
        disp(list(i).name);
        index_line = findstr(list(i).name,'_');
        index_dot = findstr(list(i).name,'.');
        classStr = list(i).name(index_line(1)+1:index_line(2)-1);
        instansStr = list(i).name(index_line(3)+1:index_dot(1)-1);
        class = str2num(classStr);
        inst = str2num(instansStr);
        Profil = csvread([path_test list(i).name]);
        Profil = Profil';       
        [ MFCCs, FBEs, frames ] = ...
              mfcc( Profil(:,1), fs, Tw, Ts, alpha, hamming, R, M,C, L );
        dataTestTelem{class,inst} = MFCCs;
    end
end

save('dataTrainSeqFromImage.mat', 'dataTrainTelem','-v7.3');
save('dataTestSeqFromImage.mat', 'dataTestTelem','-v7.3');

display('Stop');