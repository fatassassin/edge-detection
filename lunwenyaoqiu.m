clear;clc;

I=imread('xinxiaohui.jpg');
ima=rgb2gray(I); 

tic;
thresh=graythresh(ima);               %�����䷽�
imathresh=im2bw(ima,thresh);         
BWthresh = bwperim(imathresh,8);
figure;
subplot(2,3,2);
imshow(BWthresh);
toc;
disp(['ϵͳ�Դ�����ʱ��: ',num2str(toc)]);

tic; 
imakittler=kittlerMet(ima);           %kittlerMet ��������С��
BWkittler = bwperim(imakittler,8);
subplot(2,3,3);
imshow(BWkittler);
toc;
disp(['kittler����ʱ��: ',num2str(toc)]);

tic;
imakapur=kapur(ima);                  %kapur  �����������ֵ�ָ
se=strel('disk',1);        
imakapur=imdilate(imakapur,se);  
BWkapur = bwperim(imakapur,8);
subplot(2,3,4);
imshow(BWkapur);
toc;
disp(['kapur����ʱ��: ',num2str(toc)]);

tic;                             
imaniblack=double(ima);      %niblack �ֲ���ֵ
imaniblack=niblack(imaniblack,16,0);%niblack
BWniblack = bwperim(imaniblack,8);
subplot(2,3,5);
imshow(BWniblack);
toc;
disp(['niblack����ʱ��: ',num2str(toc)]);

tic;
imadiedai=iteration(I);                    %����
BWdiedai = bwperim(imadiedai,8);
subplot(2,3,6);
imshow(BWdiedai);
toc;
disp(['otsu����ʱ��: ',num2str(toc)]);

figure;
subplot(1,2,1);
imshow(I);
title('ԭͼ');

subplot(1,2,2);
imshow(imathresh);
title('matlab�Դ���ֵ��');

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