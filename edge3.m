clear;clc;

I=imread('lena.tiff');
imagray=rgb2gray(I);
figure;
subplot(1,2,1);
imshow(I);
title('ԭͼ');
subplot(1,2,2);
imshow(imagray);
title('�Ҷ�ͼ');


%Edge Detection
%Sobel
sobelBW=edge(imagray,'sobel');
figure;
subplot(1,1,1);
imshow(sobelBW);
title('sobel edge');

%roberts
robertsBW=edge(imagray,'roberts');
figure;
subplot(1,1,1);
imshow(robertsBW);
title('roberts edge');

%prewitt
prewittsBW=edge(imagray,'prewitt');
figure;
subplot(1,1,1);
imshow(prewittsBW);
title('prewitts edge');

%log
logBW=edge(imagray,'log');
figure;
subplot(1,1,1);
imshow(logBW);
title('log Edge');

%canny
cannyBW=edge(imagray,'canny');
imwrite(cannyBW,'lenaBW.jpg');
figure;
subplot(1,1,1);
imshow(cannyBW);
title('Canny Edge');
