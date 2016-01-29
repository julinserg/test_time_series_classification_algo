clear;
clc;
display('Start');
path_train = 'd:\bitbucket_proj\p_train\';
list = dir(path_train);
dataTrainProfilogr = cell(1,1);
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
        dataTrainProfilogr{class,inst} = Profil';
    end
end

path_test = 'd:\bitbucket_proj\p_test\';
list = dir(path_test);
dataTestProfilogr = cell(1,1);
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
        dataTestProfilogr{class,inst} = Profil';
    end
end

save('dataTrainProfilogr.mat', 'dataTrainProfilogr','-v7.3');
save('dataTestProfilogr.mat', 'dataTestProfilogr','-v7.3');

display('Stop');