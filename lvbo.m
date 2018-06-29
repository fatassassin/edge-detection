clear;clc;

ima=imread('lena.tiff');
%ima=imread('butterfly.jpg');
%ima=imread('xinxiaohui.jpg');
ima=rgb2gray(ima);
p1=imnoise(ima,'gaussian',0.05);
p2=imnoise(ima,'salt & pepper',0.05);

gausFilter = fspecial('gaussian',3, 1); %高斯模板
gaus1= imfilter(p1, gausFilter, 'replicate');
averFilter = fspecial('average',3);  %均值模板
aver1= imfilter(p1, averFilter, 'replicate');
med1=medfilt2(p1);

gaus2= imfilter(p2, gausFilter, 'replicate');
aver2= imfilter(p2, averFilter, 'replicate');
med2=medfilt2(p2);

figure;
subplot(2,3,1);
imshow(ima);
title('原图');
subplot(2,3,2);
imshow(p1);
title('加入高斯噪声图像');
subplot(2,3,3);
imshow(aver1);
title('均值滤波后');
subplot(2,3,4);
imshow(gaus1);
title('高斯滤波后');
subplot(2,3,5);
imshow(med1);
title('中值滤波后');

figure;
subplot(2,3,1);
imshow(ima);
title('原图');
subplot(2,3,2);
imshow(p2);
title('加入椒盐噪声图像');
subplot(2,3,3);
imshow(aver2);
title('均值滤波后');
subplot(2,3,4);
imshow(gaus2);
title('高斯滤波后');
subplot(2,3,5);
imshow(med2);
title('中值滤波后');

