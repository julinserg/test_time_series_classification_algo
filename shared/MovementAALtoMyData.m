clear;
clc;
display('Start');
pathL = 'c:\Users\sergey\Downloads\MovementAAL\MovementAAL_target.csv';
TargetLable = csvread(pathL,1,0);

path = 'c:\Users\sergey\Downloads\MovementAAL\dataset\';
list = dir(path);
dataMovementAAL = cell(1,1);
inst0 = 0;
inst1 = 0;
for i=1:length(list)
    if list(i).isdir() == 0
        disp(list(i).name);        
        Seq = csvread([path list(i).name],1,0);       
        index_line = findstr(list(i).name,'_');
        index_dot = findstr(list(i).name,'.');        
        instansStr = list(i).name(index_line(2)+1:index_dot(1)-1);       
        inst = str2num(instansStr);
        if TargetLable(inst,2) == 1           
            inst0 = inst0 + 1;
            dataMovementAAL{1,inst0} = Seq';
        else           
            inst1 = inst1 + 1;
            dataMovementAAL{2,inst1} = Seq';
        end;                        
    end
end

%save('dataMovementAAL.mat', 'dataMovementAAL','-v7.3');

display('Stop');