function imagBW = iteration(imag)

zmax=max(max(imag));%取出最大灰度值  
zmin=min(min(imag));%取出最小灰度值  
tk=(zmax+zmin)/2;  
bcal=1;  
[m,n]=size(imag);  
while(bcal)  
    %定义前景和背景数  
    iforeground=0;  
    ibackground=0;  
    %定义前景和背景灰度总和  
    foregroundsum=0;  
    backgroundsum=0;  
    for i=1:m  
        for j=1:n  
            tmp=imag(i,j);  
            if(tmp>=tk)  
                %前景灰度值  
                iforeground=iforeground+1;  
                foregroundsum=foregroundsum+double(tmp);  
            else  
                ibackground=ibackground+1;  
                backgroundsum=backgroundsum+double(tmp);  
            end  
        end  
    end  
    %计算前景和背景的平均值  
    z1=foregroundsum/iforeground;  
    z2=foregroundsum/ibackground;  
    tktmp=uint8((z1+z2)/2);  
    if(tktmp==tk)  
        bcal=0;  
    else  
        tk=tktmp;  
    end  
    %当阈值不再变化时,说明迭代结束  
end  
disp(strcat('迭代的阈值:',num2str(tk)));%在command window里显示出 :迭代的阈值:阈值  
imagBW=im2bw(imag,double(tk)/255);%函数im2bw使用阈值（threshold）变换法把灰度图像（grayscale image）  