% 1 ¬ариант
% а. ѕоказываем что смм лучше оценивают рспредление в отсутсвии коррел€ции между 
%    случайными величинами (ссылаемс€ на таблицу с качеством классикации)
% б. ѕоказываем что оцененные параметры распредлени€ в меньшей степени соответсвуют
%    наблюадемым данным. ƒл€ этого считаем правдободобие (log likelihood) дл€ всех данных
%    всех распределений
% в. √оворим, что это происходит в результате зависмости случайных переменных
%    (показываем зависимость счита€ тау кендала и п спирмена)
% г. √оврим что в результате зависимости  совместное распределение перестает быть
%     распредленным по гаусовскому закону даже если маргинальные распределени€ гаусовы.
% д. ѕоказываем не нормальность ( не гаусовость )  распрделени€ оценива€ данные
%     на нормальность по критерию Henze-Zirkler's  и критерию Royston's

function main()
clear;
clc;

% load iris_dataset
% for i=10:size(irisInputs,2)
%     irisInputs(5,i) = sum(irisInputs(:,i))/size(irisInputs,1);
%     irisInputs(5,i) = sqrt(irisInputs(1,i) + irisInputs(2,i));
% %     irisInputs(7,i) = sqrt(irisInputs(3,i));
% %     irisInputs(8,i) = sqrt(irisInputs(4,i));
% end;
% irisInputs = irisInputs(1:5,10:20)';
% HZmvntest(irisInputs);
% Mskekur(irisInputs,1);

load pruf_data_koh
load pruf_data_pure
load pruf_model_koh
load pruf_model_pure

n_class = 2;
data_b = 8;
data_e = 10;
number_state = 1;
number_data = 2;

index = 1;
for b=1:size(pruf_data_pure{data_b},2)-1
    for e=(b+1):size(pruf_data_pure{data_b},2)
      if e-b > 1 && e-b < 60
       cur_p = HZmvntest(pruf_data_pure{data_b}(:,b:e)');
       if cur_p >=0.05
        listvalueP(index,1) = b;
        listvalueP(index,2) = e;
        listvalueP(index,3) = cur_p;
        index = index + 1;
       end; 
      end;
    end;
end;

max = 0;
be_max = 0;
end_max = 0;
for i=1:size(listvalueP,1)
    dist = listvalueP(i,2) - listvalueP(i,1); 
    if dist > max
       max = dist;
       be_max = listvalueP(i,1);
       end_max = listvalueP(i,2);
    end;
end;


Arr_data_koh = pruf_data_koh{data_b}(4:6,be_max:end_max);
Arr_data_pure = pruf_data_pure{data_b}(:,be_max:end_max);
h1 = jbtest(Arr_data_pure(1,:));
l1 = lillietest(Arr_data_pure(1,:));
k1 = kstest(Arr_data_pure(1,:));
h2 = jbtest(Arr_data_pure(2,:));
k1 = kstest(Arr_data_pure(2,:));
l2 = lillietest(Arr_data_pure(2,:));
h3 = jbtest(Arr_data_pure(3,:));
k3 = kstest(Arr_data_pure(3,:));
l3 = lillietest(Arr_data_pure(3,:));

k_k1 = kstest(Arr_data_koh(1,:));
k_k2 = kstest(Arr_data_koh(2,:));
k_k3 = kstest(Arr_data_koh(3,:));

%Roystest(Arr_data_koh');
%Roystest(Arr_data_pure');
t1 = HZmvntest(Arr_data_koh')
t2 = HZmvntest(Arr_data_pure')
%Mskekur(Arr_data_koh',1);
%Mskekur(Arr_data_pure',1);
% max = 0;
% i_emis = 0;
% for i=1:8
%    matCov_pur = pruf_model_pure.classConditionals{n_class}.emission.Sigma(:,:,i); 
%    p =  HZmvntest(Arr_data_pure',matCov_pur);
% end;

%Arr_data_koh = CreateDataPull(n_class,number_state,pruf_data_koh,pruf_model_koh,data_b,data_e);
%Arr_data_pure = CreateDataPull(n_class,number_state,pruf_data_pure,pruf_model_pure,data_b,data_e);

matCov_pur = pruf_model_pure.classConditionals{n_class}.emission.Sigma(:,:,number_state);

matCov_koh = pruf_model_koh.classConditionals{n_class}.emission.Sigma(:,:,number_state);

%data_pure = [pruf_data_pure{1}(:,1:9),pruf_data_pure{2}(:,1:9),pruf_data_pure{3}(:,1:9),pruf_data_pure{4}(:,1:9),pruf_data_pure{5}(:,1:9)];
%data_koh = [pruf_data_koh{1}(:,1:9),pruf_data_koh{2}(:,1:9),pruf_data_koh{3}(:,1:9),pruf_data_koh{4}(:,1:9),pruf_data_koh{5}(:,1:9)];
%data_pure = [pruf_data_pure{15}(:,1:10)];
%data_koh = [pruf_data_koh{15}(:,1:10)];
%HZmvntest(Arr_data_koh(:,1:15)',matCov_koh);
%HZmvntest(Arr_data_pure(:,1:15)',matCov_pur);
%HZmvntest(Arr_data_koh(:,1:15)');
%HZmvntest(Arr_data_pure(:,1:15)');
%Mskekur(data_pure',matCov_pur_1);
%Mskekur(data_koh',matCov_koh_1);
%HZmvntest(data_pure');
%HZmvntest(data_koh');

end


function ArrDat = CreateDataPull(n_class,number_state,pruf_data,pruf_model,data_b,data_e)
  patharrKoh = cell(1,1);
% вычисл€ем путь витерби, тем самым поулчаем разделение данных по
% распределени€м им соответствующим
for n_data=data_b:data_e
        logA = log(pruf_model.classConditionals{n_class}.A);
        logPi = log(pruf_model.classConditionals{n_class}.pi);
        logB = mkSoftEvidence(pruf_model.classConditionals{n_class}.emission, pruf_data{n_data});
        path = hmmViterbiMy(logPi,logA,logB);
        patharrKoh{n_data} = path;    
        i_min_begin = 0;
        i_min_end = 0;
        f_min_begin = 0;
        for i=1:size(path,2)
            if (path(1,i) == number_state && f_min_begin == 0)
               i_min_begin = i; 
               i_min_end = i; 
               f_min_begin = 1;
            end;
            if f_min_begin == 1
                if path(1,i) == number_state
                   i_min_end = i_min_end + 1;
                else
                   break;
                end;
            end;            
        end;
        Begins(n_data) = i_min_begin;
        Ends(n_data) = i_min_end;
    end;
    %avr_EndsVit = fix(sum(Ends)/size(Ends,2));
    %avr_BeginsVit = fix(sum(Begins)/size(Begins,2));
    MainArrayData = pruf_data{n_data}(:,1);
    for n_data=data_b:data_e
        MainArrayData = cat(2,MainArrayData,pruf_data{n_data}(:,Begins(n_data):Ends(n_data)));
    end;
    MainArrayData(:,1) = [];
    ArrDat = MainArrayData;
end





