clear all;
close all;
clc;

img=imread('susanBW.jpg');
susanBW=bwmorph(img,'thin',inf);
figure;
subplot(1,1,1);
imshow(susanBW);
title('susan edge');