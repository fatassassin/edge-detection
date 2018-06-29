clear all;
close all;
clc;

img=imread('lena.tiff');
img=rgb2gray(img);
imshow(img);
[m n]=size(img);
img=double(img);

t=45;   %模板中心像素灰度和周围灰度差别的阈值，自己设置
usan=[]; %当前像素和周围在像素差别在t以下的个数
%这里用了37个像素的模板
for i=4:m-3         %没有在外围扩展图像，最终图像会缩小
   for j=4:n-3 
        tmp=img(i-3:i+3,j-3:j+3);   %先构造7*7的模板，49个像素
        c=0;
        for p=1:7
           for q=1:7
                if (p-4)^2+(q-4)^2<=12  %在其中筛选，最终模板类似一个圆形
                   %   usan(k)=usan(k)+exp(-(((img(i,j)-tmp(p,q))/t)^6)); 
                    if abs(img(i,j)-tmp(p,q))<t  %判断灰度是否相近，t是自己设置的
                        c=c+1;
                    end
                end
           end
        end
        usan=[usan c];
   end
end

g=2*max(usan)/3; %确定角点提取的数量，值比较高时会提取出边缘，自己设置
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

%非极大抑制
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