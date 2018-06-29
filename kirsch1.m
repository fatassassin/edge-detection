%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%读出要处理的图象
clear
clc
close all
I=imread('lena.tiff');
bw4=rgb2gray(I);
%bw4=imnoise(imagray,'salt & pepper',0.05);
%bw4=medfilt2(bw4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%画出原始图象
figure(1)
imshow(bw4)
title('原始图象')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%提取图象边缘
t=600 ;                        %设定阈值
%colormap(gray(256));          %设定调色板
bw5=double(bw4);             %把图变为十进制数
[m,n]=size(bw5);               %得到图像的大小（长和宽）
g=zeros(m,n);              %定义一个大小为S的零矩阵
%利用Sobel算子进行边缘提取
for i=2:m-1
  for j=2:n-1
       d1 =(5*bw5(i-1,j-1)+5*bw5(i-1,j)+5*bw5(i-1,j+1)-3*bw5(i,j-1)-3*bw5(i,j+1)-3*bw5(i+1,j-1)-3*bw5(i+1,j)-3*bw5(i+1,j+1))^2; %Sobel算子的dx(垂直梯度)
       d2 =((-3)*bw5(i-1,j-1)+5*bw5(i-1,j)+5*bw5(i-1,j+1)-3*bw5(i,j-1)+5*bw5(i,j+1)-3*bw5(i+1,j-1)-3*bw5(i+1,j)-3*bw5(i+1,j+1))^2;  %Sobel算子的dy(水平梯度)
       d3 =((-3)*bw5(i-1,j-1)-3*bw5(i-1,j)+5*bw5(i-1,j+1)-3*bw5(i,j-1)+5*bw5(i,j+1)-3*bw5(i+1,j-1)-3*bw5(i+1,j)+5*bw5(i+1,j+1))^2; 
       d4 =((-3)*bw5(i-1,j-1)-3*bw5(i-1,j)-3*bw5(i-1,j+1)-3*bw5(i,j-1)+5*bw5(i,j+1)-3*bw5(i+1,j-1)+5*bw5(i+1,j)+5*bw5(i+1,j+1))^2; 
       d5 =((-3)*bw5(i-1,j-1)-3*bw5(i-1,j)-3*bw5(i-1,j+1)-3*bw5(i,j-1)-3*bw5(i,j+1)+5*bw5(i+1,j-1)+5*bw5(i+1,j)+5*bw5(i+1,j+1))^2; 
       d6 =((-3)*bw5(i-1,j-1)-3*bw5(i-1,j)-3*bw5(i-1,j+1)+5*bw5(i,j-1)-3*bw5(i,j+1)+5*bw5(i+1,j-1)+5*bw5(i+1,j)-3*bw5(i+1,j+1))^2; 
       d7 =(5*bw5(i-1,j-1)-3*bw5(i-1,j)-3*bw5(i-1,j+1)+5*bw5(i,j-1)-3*bw5(i,j+1)+5*bw5(i+1,j-1)-3*bw5(i+1,j)-3*bw5(i+1,j+1))^2; 
       d8 =(5*bw5(i-1,j-1)+5*bw5(i-1,j)-3*bw5(i-1,j+1)+5*bw5(i,j-1)-3*bw5(i,j+1)-3*bw5(i+1,j-1)-3*bw5(i+1,j)-3*bw5(i+1,j+1))^2; 
       
      g(i,j)=round(sqrt(d1+d2+d3+d4+d5+d6+d7+d8)); %梯度模取整
%        max=d1;
%        if max<d2
%            max=d2;
%        end
%        if max<d3
%            max=d3;
%        end
%        if max<d4
%            max=d4;
%        end
%        if max<d5
%            max=d5;
%        end
%        if max<d6
%            max=d6;
%        end
%        if max<d7
%            max=d7;
%        end
%        if max<d8
%            max=d8;
%        end
%         g(i,j)=max;
    end
end 
figure(4)
imshow(g,[])

for i=1:m
  for j=1:n
  if g(i,j)>t
  bw5(i,j)=255;              %将梯度值与阈值比较 ，大于T则把图像的灰度变为255，小于T则把图像的灰度变为0
  else
  bw5(i,j)=0;
    end
  end
end
%显示边缘提取后的图象
figure(5)
imshow(bw5)
title('kirsch边缘检测')
bw6=bwmorph(bw5,'thin',inf);
figure(6)
imshow(bw6)
title('细化kirsch边缘检测')


