
x_speech = [50,100,150,200,250,300,350,400,450,500,550,600,650];
y_speech_train_hmm_5_0 = [0,0.0010,0.0133,0.0085,0.0080,0.0206,0.0340,0.0367,0.0524,0.0532,0.0527,0.0738,0.0695];
y_speech_test_hmm_5_0 = [0.4322,0.4295,0.3827,0.3495,0.3618,0.3350,0.1868,0.1536,0.1436,0.1254,0.1172,0.1177,0.1113];

y_speech_train_hcrf = [0,0.0010,0.0013,0.0015,0.0080,0.0106,0.0240,0.0267,0.0424,0.0332,0.0527,0.0738,0.0695];
y_speech_test_hcrf = [0.4322,0.4295,0.3827,0.3495,0.3618,0.3350,0.1868,0.1536,0.1436,0.1254,0.1172,0.1177,0.1113];


x1 = x_speech;
y1 = y_speech_train_hcrf;
y2 = y_speech_test_hcrf;
hold on;
plot(x1, y1,'r','LineWidth',3);
plot(x1, y2,'--','Color',[.1 .4 .1],'LineWidth',3);
axis([min(x1),max(x1),0,1])
legend('ERROR TRAIN','ERROR TEST', 2);
BX=get(gca,'XTick');
BY=get(gca,'YTick');
xlabel('Sample Size');
ylabel('Error');
hold off;