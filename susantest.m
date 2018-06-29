clear;clc;

I=imread('lena.tiff');
susanBW=SUSAN(I,20);
figure;
subplot(1,1,1);
imshow(susanBW);
title('SUSAN edge');
OUT=bwmorph(susanBW,'thin',inf);
figure;
subplot(1,1,1);
imshow(OUT);