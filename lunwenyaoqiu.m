clear;clc;

I=imread('xinxiaohui.jpg');
ima=rgb2gray(I); 

tic;
thresh=graythresh(ima);               %最大类间方差法
imathresh=im2bw(ima,thresh);         
BWthresh = bwperim(imathresh,8);
figure;
subplot(2,3,2);
imshow(BWthresh);
toc;
disp(['系统自带运行时间: ',num2str(toc)]);

tic; 
imakittler=kittlerMet(ima);           %kittlerMet 噪声多最小误差法
BWkittler = bwperim(imakittler,8);
subplot(2,3,3);
imshow(BWkittler);
toc;
disp(['kittler运行时间: ',num2str(toc)]);

tic;
imakapur=kapur(ima);                  %kapur  不错最大熵阈值分割法
se=strel('disk',1);        
imakapur=imdilate(imakapur,se);  
BWkapur = bwperim(imakapur,8);
subplot(2,3,4);
imshow(BWkapur);
toc;
disp(['kapur运行时间: ',num2str(toc)]);

tic;                             
imaniblack=double(ima);      %niblack 局部阈值
imaniblack=niblack(imaniblack,16,0);%niblack
BWniblack = bwperim(imaniblack,8);
subplot(2,3,5);
imshow(BWniblack);
toc;
disp(['niblack运行时间: ',num2str(toc)]);

tic;
imadiedai=iteration(I);                    %迭代
BWdiedai = bwperim(imadiedai,8);
subplot(2,3,6);
imshow(BWdiedai);
toc;
disp(['otsu运行时间: ',num2str(toc)]);

figure;
subplot(1,2,1);
imshow(I);
title('原图');

subplot(1,2,2);
imshow(imathresh);
title('matlab自带二值化');

figure;
subplot(1,2,1);
imshow(imakittler);
title('kittlerMet');

subplot(1,2,2);
imshow(imakapur);
title('kapur');

figure;
subplot(1,2,1);
imshow(imaniblack);
title('imaniblack');

subplot(1,2,2);
imshow(imadiedai);
title('imadiedai');