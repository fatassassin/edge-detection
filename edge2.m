clear;clc;

I=imread('lena.tiff');
imagray=rgb2gray(I);
p1=imnoise(imagray,'salt & pepper',0.05);
p2=imnoise(imagray,'gaussian',0.02);
med1=medfilt2(p1);
med2=medfilt2(p2);
figure;
subplot(1,2,1);
imshow(I);
title('ԭͼ');
subplot(1,2,2);
imshow(imagray);
title('�Ҷ�ͼ');


%Edge Detection
%Sobel
sobelBW=edge(med1,'sobel');
figure;
subplot(1,1,1);
imshow(sobelBW);
title('sobel edge');

%roberts
robertsBW=edge(med1,'roberts');
figure;
subplot(1,1,1);
imshow(robertsBW);
title('roberts edge');

%prewitt
prewittsBW=edge(med1,'prewitt');
figure;
subplot(1,1,1);
imshow(prewittsBW);
title('prewitts edge');

%log
logBW=edge(med1,'log');
figure;
subplot(1,1,1);
imshow(logBW);
title('log Edge');

%canny
cannyBW=edge(med1,'canny');
imwrite(cannyBW,'lenaBW.jpg');
figure;
subplot(1,1,1);
imshow(cannyBW);
title('Canny Edge');

kirschBW=Kirsch(med1);
figure;
subplot(1,1,1);
imshow(kirschBW);
title('kirsch Edge');
