function []=plt(jpg_file)


G2=imread(jpg_file);%��ȡjpg��ʽ��ͼ���ļ���matlab��������ʽ�������ڴ���
%G2=rgb2gray(G1);%����ɫͼ��תΪ�Ҷ�ͼ��

%level=graythresh(G2);%�������im2bw�������ã��ȷ���ͼ�����һ���Ҷȷֽ���ֵ
%Gbw=im2bw(G2,level);%����ֵ���Ҷ�ͼתΪ��ֵͼ�񣨺ڰף�

%G3=kittlerMet(G2);                   %���ֶ�ֵ��

%imakapur=kapur(G2);                  %kapur  ����
%se=strel('disk',1);        
%G3=imdilate(imakapur,se);  

%imaniblack=double(G2);      %niblack
%G3=niblack(imaniblack,16,0);%niblack

G3=otsu(G2);     %OTSU

%G3=medfilt2(Gbw);%��ֵ�˲�
[rows, clmns]=size(G3);%ͼ��ߴ�
%G3(1,1)=(G3(1,2)+G3(2,1)+G3(2,2))/3;%����4��Ϊ��ֵ�˲�����
%G3(1,clmns)=(G3(1,clmns-1)+G3(2,clmns)+G3(2,clmns-1))/3;
%G3(rows,1)=(G3(rows-1,1)+G3(rows,2)+G3(rows-1,2))/3;
%G3(rows,clmns)=(G3(rows,clmns-1)+G3(rows-1,clmns)+G3(rows-1,clmns-1))/3;
%G4=bwcontur(G3);
%figure(5);
%imshow(conturIm)
[fitlines, conturIm] = bwCt_LFt(G3, 20, 1);%��Ҫ�㷨ʵ�ֵ��Ӻ���������ֵconturImΪ����ͼ��fitlines���������ߵ�����߶εļ��ϣ�
%����һ��n��4�еľ�������n�������������߶�������ÿ�е���������������ݡ������꣬�յ��ݡ�������
fNameLen=size(jpg_file,2);%����3����ָ������ļ�������ͼ���ļ����ļ������ǣ�ֻ�Ǹ�����չ��Ϊ��plt��
plt_file=jpg_file;
plt_file(fNameLen-2:fNameLen)='plt';
fid=fopen(plt_file,'wt');
fprintf(fid,'IN;\nSP1;\n');%plt�ļ��̶���ʽ
lines=size(fitlines,1);%���������߶�����
fprintf(fid,'PU;PA%i,%i;\n',(fitlines(1,2)-1),(rows-fitlines(1,1)));%fitlines�����������Ǵ�1����ģ���plt�������Ǵ�0��ģ��������ߵ��������Ƿ����
for i=2:lines
    if fitlines(i,1)==fitlines(i-1,3)&fitlines(i,2)==fitlines(i-1,4)%��������������߶��Ƿ���λ����
        fprintf(fid,'PD;PA%i,%i;\n',(fitlines(i,4)-1),(rows-fitlines(i,3)));%�ǣ����������
    else
        fprintf(fid,'PU;PA%i,%i;\n',(fitlines(i,2)-1),(rows-fitlines(i,1)));%�������������
    end
end
fprintf(fid,'SP0');%plt�ļ��̶���ʽ
fclose(fid);