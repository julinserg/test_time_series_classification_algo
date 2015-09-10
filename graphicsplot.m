
x_speech = [50,100,150,200,250,300,350,400,450,500,550,600,650];
y_speech_train_hmm_5_0 = [0,0.0010,0.0133,0.0085,0.0080,0.0206,0.0340,0.0367,0.0524,0.0532,0.0527,0.0738,0.0695];
y_speech_test_hmm_5_0 = [0.4322,0.4295,0.3827,0.3495,0.3618,0.3350,0.1868,0.1536,0.1436,0.1254,0.1172,0.1177,0.1113];

y_speech_train_hcrf_5_0 = [0,0.0010,0.0013,0.0015,0.0080,0.0106,0.0240,0.0267,0.0424,0.0332,0.0527,0.0738,0.0695];
y_speech_test_hcrf_5_0 = [0.4322,0.4295,0.3827,0.3495,0.3618,0.3350,0.1868,0.1536,0.1436,0.1254,0.1172,0.1177,0.1113];

y_speech_train_npmpgm_10_10 = [0 0 0 0 0.000400000000000000 0.000333333333333333 0.000571428571428572 0.00125000000000000 0.00133333333333333 0.00380000000000000 0.00200000000000000 0.00500000000000000 0.00584615384615385];
y_speech_test_npmpgm_10_10 = [0.330454545454545 0.326363636363636 0.328636363636364 0.360000000000000 0.360000000000000 0.374545454545455 0.164545454545455 0.155454545454545 0.155454545454545 0.133181818181818 0.146363636363636 0.149545454545455 0.146363636363636];
%%
x1 = x_speech;
y1 = y_speech_test_npmpgm_10_10;
y2 = y_speech_test_hmm_5_0;
%%
set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');
set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman');
%figure('Units', 'normalized', 'OuterPosition', [0 0 1 1]);
%title('Название');
hold on;
grid on;
plot(x1, y1,'r','LineWidth',3);
plot(x1, y2,'--','Color',[.1 .4 .1],'LineWidth',3);
plot(x1, repmat(min(y2),size(x1,1),size(x1,2)),'black','LineWidth',1);
axis([min(x1),max(x1),0,0.6])
legend('Ошибка на обучающей выборке','Ошибка на тестовой выборке', 1);
BX=get(gca,'XTick');
BY=get(gca,'YTick');

%xlabel('Количество обучающих данных','Position',[BX(size(BX,2)) BY(1)])
%ylabel('Ошибка классификации','Rotation',0,'Position',[BX(1) BY(size(BY,2))])
xlabel('Количество обучающих данных')
ylabel('Ошибка классификации')

XA=get(gca,'XTickLabel');%

for i=1:size(XA,1)

    z=rem(i,2);
    if z==0;
        if XA(i,1)~='0' && XA(i,2)~=0
            XA(i,:)=char(0);
        end
    end
    
end

XA(size(XA,1),:)=char(0);

set(gca,'XTickLabel',XA);

YA=get(gca,'YTickLabel');%

for i=1:size(YA,1)

    z=strfind(YA(i,:),'.');
    YA(i,z)=',';
    clear z;
    z=rem(i,2);
    if z~=0; 
        YA(i,:)=char(0);
    end
    
end

YA(size(YA,1),:)=char(0);

set(gca,'YTickLabel',YA);

%xlabel('Sample Size');
%ylabel('Error');
