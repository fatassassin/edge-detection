clear;clc;

ima=imread('lena.tiff');
%ima=imread('butterfly.jpg');
%ima=imread('xinxiaohui.jpg');
ima=rgb2gray(ima);
p1=imnoise(ima,'gaussian',0.05);
p2=imnoise(ima,'salt & pepper',0.05);

gausFilter = fspecial('gaussian',3, 1); %��˹ģ��
gaus1= imfilter(p1, gausFilter, 'replicate');
averFilter = fspecial('average',3);  %��ֵģ��
aver1= imfilter(p1, averFilter, 'replicate');
med1=medfilt2(p1);

gaus2= imfilter(p2, gausFilter, 'replicate');
aver2= imfilter(p2, averFilter, 'replicate');
med2=medfilt2(p2);

figure;
subplot(2,3,1);
imshow(ima);
title('ԭͼ');
subplot(2,3,2);
imshow(p1);
title('�����˹����ͼ��');
subplot(2,3,3);
imshow(aver1);
title('��ֵ�˲���');
subplot(2,3,4);
imshow(gaus1);
title('��˹�˲���');
subplot(2,3,5);
imshow(med1);
title('��ֵ�˲���');

figure;
subplot(2,3,1);
imshow(ima);
title('ԭͼ');
subplot(2,3,2);
imshow(p2);
title('���뽷������ͼ��');
subplot(2,3,3);
imshow(aver2);
title('��ֵ�˲���');
subplot(2,3,4);
imshow(gaus2);
title('��˹�˲���');
subplot(2,3,5);
imshow(med2);
title('��ֵ�˲���');

