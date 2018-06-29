clear all;
close all;
clc;

img=imread('lena.tiff');
img=rgb2gray(img);
imshow(img);
[m n]=size(img);
img=double(img);

t=45;   %ģ���������ػҶȺ���Χ�ҶȲ�����ֵ���Լ�����
usan=[]; %��ǰ���غ���Χ�����ز����t���µĸ���
%��������37�����ص�ģ��
for i=4:m-3         %û������Χ��չͼ������ͼ�����С
   for j=4:n-3 
        tmp=img(i-3:i+3,j-3:j+3);   %�ȹ���7*7��ģ�壬49������
        c=0;
        for p=1:7
           for q=1:7
                if (p-4)^2+(q-4)^2<=12  %������ɸѡ������ģ������һ��Բ��
                   %   usan(k)=usan(k)+exp(-(((img(i,j)-tmp(p,q))/t)^6)); 
                    if abs(img(i,j)-tmp(p,q))<t  %�жϻҶ��Ƿ������t���Լ����õ�
                        c=c+1;
                    end
                end
           end
        end
        usan=[usan c];
   end
end

g=2*max(usan)/3; %ȷ���ǵ���ȡ��������ֵ�Ƚϸ�ʱ����ȡ����Ե���Լ�����
for i=1:length(usan)
   if usan(i)<g 
       usan(i)=g-usan(i);
   else
       usan(i)=0;
   end
end
imgn=reshape(usan,[n-6,m-6])';
figure;
imshow(imgn)

%�Ǽ�������
[m n]=size(imgn);
re=zeros(m,n);
for i=2:m-1
   for j=2:n-1 
        if imgn(i,j)>max([max(imgn(i-1,j-1:j+1)) imgn(i,j-1) imgn(i,j+1) max(imgn(i+1,j-1:j+1))]);
            re(i,j)=1;
        else
            re(i,j)=0;
        end
   end
end

figure;
imshow(re==1);