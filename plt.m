function []=plt(jpg_file)


G2=imread(jpg_file);%读取jpg格式的图像文件，matlab以数组形式保存在内存中
%G2=rgb2gray(G1);%将彩色图像转为灰度图像

%level=graythresh(G2);%与下面的im2bw命令连用，先分析图像，算出一个灰度分界阈值
%Gbw=im2bw(G2,level);%用阈值将灰度图转为二值图像（黑白）

%G3=kittlerMet(G2);                   %换种二值化

%imakapur=kapur(G2);                  %kapur  不错
%se=strel('disk',1);        
%G3=imdilate(imakapur,se);  

%imaniblack=double(G2);      %niblack
%G3=niblack(imaniblack,16,0);%niblack

G3=otsu(G2);     %OTSU

%G3=medfilt2(Gbw);%中值滤波
[rows, clmns]=size(G3);%图像尺寸
%G3(1,1)=(G3(1,2)+G3(2,1)+G3(2,2))/3;%以下4句为中值滤波修正
%G3(1,clmns)=(G3(1,clmns-1)+G3(2,clmns)+G3(2,clmns-1))/3;
%G3(rows,1)=(G3(rows-1,1)+G3(rows,2)+G3(rows-1,2))/3;
%G3(rows,clmns)=(G3(rows,clmns-1)+G3(rows-1,clmns)+G3(rows-1,clmns-1))/3;
%G4=bwcontur(G3);
%figure(5);
%imshow(conturIm)
[fitlines, conturIm] = bwCt_LFt(G3, 20, 1);%主要算法实现的子函数，返回值conturIm为轮廓图像，fitlines是轮廓曲线的拟合线段的集合，
%它是一个n行4列的矩阵，行数n就是拟合所需的线段总数，每行的数据依次是起点纵、横坐标，终点纵、横坐标
fNameLen=size(jpg_file,2);%以下3句是指定输出文件与输入图像文件的文件名益智，只是更改扩展名为“plt”
plt_file=jpg_file;
plt_file(fNameLen-2:fNameLen)='plt';
fid=fopen(plt_file,'wt');
fprintf(fid,'IN;\nSP1;\n');%plt文件固定格式
lines=size(fitlines,1);%拟合所需的线段总数
fprintf(fid,'PU;PA%i,%i;\n',(fitlines(1,2)-1),(rows-fitlines(1,1)));%fitlines的坐标数据是从1记起的，而plt的坐标是从0起的，而且两者的纵坐标是反向的
for i=2:lines
    if fitlines(i,1)==fitlines(i-1,3)&fitlines(i,2)==fitlines(i-1,4)%连续的两条拟合线段是否首位相连
        fprintf(fid,'PD;PA%i,%i;\n',(fitlines(i,4)-1),(rows-fitlines(i,3)));%是，则连续落笔
    else
        fprintf(fid,'PU;PA%i,%i;\n',(fitlines(i,2)-1),(rows-fitlines(i,1)));%否，则需重新起笔
    end
end
fprintf(fid,'SP0');%plt文件固定格式
fclose(fid);