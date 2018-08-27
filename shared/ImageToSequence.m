
A1 = ImageToMfcc( 'd:\scienceProject\texture\kamni\D23.gif' );
A2 = ImageToMfcc( 'd:\scienceProject\texture\kamni\D27.gif' );
A3 = ImageToMfcc( 'd:\scienceProject\texture\kamni\D28.gif' );
A4 = ImageToMfcc( 'd:\scienceProject\texture\kamni\D54.gif' );

B1 = ImageToMfcc( 'd:\scienceProject\texture\setka\D3.gif' );
B2 = ImageToMfcc( 'd:\scienceProject\texture\setka\D22.gif' );
B3 = ImageToMfcc( 'd:\scienceProject\texture\setka\D35.gif' );
B4 = ImageToMfcc( 'd:\scienceProject\texture\setka\D36.gif' );

C1 = ImageToMfcc( 'd:\scienceProject\texture\kirpich\D1.gif' );
C2 = ImageToMfcc( 'd:\scienceProject\texture\kirpich\D94.gif' );
C3 = ImageToMfcc( 'd:\scienceProject\texture\kirpich\D95.gif' );
C4 = ImageToMfcc( 'd:\scienceProject\texture\kirpich\D96.gif' );

dataTrain{1,1} = A1;
dataTrain{1,2} = A2;
dataTrain{2,1} = B1;
dataTrain{2,2} = B2;
dataTrain{3,1} = C1;
dataTrain{3,2} = C2;

dataTest{1,1} = A3;
dataTest{1,2} = A4;
dataTest{2,1} = B3;
dataTest{2,2} = B4;
dataTest{3,1} = C3;
dataTest{3,2} = C4;

save('dataTrainTextureImage.mat', 'dataTrain','-v7.3');
save('dataTestTextureImage.mat', 'dataTest','-v7.3');
