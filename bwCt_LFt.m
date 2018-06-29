function [fitlines, conturIm] = bwCt_LFt(bwIm, minline, maxdist)
%bwCt_LFt finds foreground object contours only in binary image, and fits
%them into lines
%   bwCt_LFt takes a binary image I as its input, and returns a 
%   binary image BW of the same size as I, denoting only the contours
%   of the foreground objects in I, and an array denoting the coordinates 
%   of the start points and end points of the fitted lines. The 
%   algorithm applied is from the master degree dissertation of 
%   Xie Liping of HUST. 
%   Two parameters minline and mindis are left to be determined 
%   by users. Minline is the lower limit of the number of pixels 
%   above which the single contour should contain so that it can 
%   be considered as a real contour, instead of just noises. 
%   Maxdist is the upper limit of the distance from any point of 
%   a contour to its fitted line.

bgColr=bwIm(1,1);%假设最左上角的像素点一定是背景色
[rows, clmns]=size(bwIm);
%先将图像上下左右各扩大“一格”
Iext(rows+2,clmns+2)=bgColr;
Iext(1,:)=bgColr;
Iext(rows+2,:)=bgColr;
Iext(:,1)=bgColr;
Iext(:,clmns+2)=bgColr;
Iext(2:rows+1,2:clmns+1)=bwIm;
IsCturEx(1:rows+2,1:clmns+2)=bgColr;%输出图像底稿，全背景色
cturIdx=0;%轮廓线的条数，初值设为0
SumIdx=0;%fitlines的拟合线段索引对已发现并完全拟合的轮廓线的累计，初值设为0

for i=2:(rows+1)
    for j=2:(clmns+1)
        if (Iext(i,j)~=Iext(i,j-1))&&(IsCturEx(i,j)==IsCturEx(i,j-1))%如果黑白变色，且未被标记
            if Iext(i,j)==bgColr
                theta=pi;%方向角
                j0=j-1;%轮廓起点应该是前景色
                i0=i;
            else
                theta=0;
                j0=j;
                i0=i;
            end
            ptsIdx=1;%轮廓包含像素点的个数，初值
            cturPnts(ptsIdx,1:2)=[i0 j0];%该矩阵用来记录当前轮廓线上所有像素点的坐标，行数代表该轮廓线包含的像素点数
            IsCturEx(i0,j0)=1-bgColr;%在输出图像上标记，是前景轮廓
            iend=i+1;%轮廓终点；初值无意义，只要不与轮廓起点相同即可
            jend=j;%因为后面会即时修改的
            inext=i0;%给下面的while循环赋初值
            jnext=j0;
            while (i0~=iend)||(j0~=jend)%只要轮廓未封闭
                for direct=0:7%周边的八个点
                    ipt=inext-round(cos(direct*pi/4-theta));
                    jpt=jnext+round(sin(direct*pi/4-theta));%这两句是根据当前的方向（角度theta），确定八个点的优先顺序
                    if (Iext(ipt,jpt)~=bgColr&&(IsCturEx(ipt,jpt)==bgColr))||(ipt==i0&&jpt==j0)
                        theta=theta+pi/2-direct*pi/4;%确定方向
                        inext=ipt;
                        jnext=jpt;
                        iend=ipt;
                        jend=jpt;
                        IsCturEx(ipt,jpt)=1-bgColr;
                        ptsIdx=ptsIdx+1;
                        cturPnts(ptsIdx,1:2)=[ipt jpt];
                        break;%这里break的是for循环
                    end
                end
                if inext~=ipt||jnext~=jpt
                    break;%contour endpoint process, break的是while循环
                end
            end
            if ptsIdx>=minline%包含像素点太少的轮廓线被认为是噪声
                cturIdx=cturIdx+1;%轮廓线的数目
                lineIdx(cturIdx)=1;%此轮廓线的第1条拟合直线段
                fLineIdx=SumIdx+lineIdx(cturIdx);%获得总的fitlines的索引（下标）
                fitlines(fLineIdx,1:2)=cturPnts(1,1:2);%此轮廓线的第1条拟合直线段的起点坐标
				subPnts=cturPnts;%subPnts是假设轮廓线进行了拆分时的前一段轮廓线的像素点的坐标集合，在此设初值
				suBpIdx=ptsIdx;%suBpIdx是假设轮廓线进行了拆分时的前一段轮廓线的点数，在此是设初值
                if (i0==iend)&&(j0==jend)%如果是封闭的轮廓线
                    if ptsIdx>(2*maxdist+2)%无论轮廓线封闭与否，只有像素点个数超过此下界时，才可能有某个像素点到始末点连线的距离大于maxdist
                        fitlines(fLineIdx,3:4)=cturPnts(2*maxdist+2,1:2);%将封闭轮廓线拆分，前一段固定始末点，确保不超距
                        SumIdx=SumIdx+lineIdx(cturIdx);
                        cturIdx=cturIdx+1;
                        lineIdx(cturIdx)=1;
                        fLineIdx=SumIdx+lineIdx(cturIdx);
                        fitlines(fLineIdx,1:2)=cturPnts(2*maxdist+2,1:2);%后一段起点是前一段终点
                        %fitlines(cturIdx,3:4)=[iend jend];%被注释掉，因为现在还不能确定是拟合折线的终点
                        cturPnts(1:ptsIdx-2*maxdist-1,:)=cturPnts(2*maxdist+2:ptsIdx,:);%相应的像素点集合要做调整
                        ptsIdx=ptsIdx-2*maxdist-1;%像素点个数也要做调整，这两个调整是因为后一段非封闭轮廓线还可能因拟合而被拆分
                        subPnts=cturPnts;
                        suBpIdx=ptsIdx;
                    else%对像素点较少的封闭轮廓线
                        fitlines(fLineIdx,3:4)=cturPnts(floor(ptsIdx/2),1:2);%直接在轮廓线中点做拆分，并给出拟合结果
                        SumIdx=SumIdx+lineIdx(cturIdx);
                        cturIdx=cturIdx+1;
                        lineIdx(cturIdx)=1;
                        fLineIdx=SumIdx+lineIdx(cturIdx);
                        fitlines(fLineIdx,1:2)=cturPnts(floor(ptsIdx/2),1:2);
                        %fitlines(fLineIdx,3:4)=[i0 j0];%其实这种情况下就是被拟合成往返的两条直线
                        %SumIdx=SumIdx+lineIdx(cturIdx);
                        %以上两句因为与下面的while循环外的两句重复，因此被注释掉了
                    end
                end
				while ptsIdx>(2*maxdist+2)%只有像素点个数超过下界(2*maxdist+2)时，才可能有某个像素点到始末点连线的距离大于maxdist
                    dist(1:ptsIdx)=0;
                    for pIdx=maxdist+2:(suBpIdx-maxdist-1)
					%for pIdx=2:(suBpIdx-1)
                        dist(pIdx)=tpHeight(subPnts(1,1:2),subPnts(suBpIdx,1:2),subPnts(pIdx,1:2));
					end
                    [distmax, maxpIdx]=max(dist);%确定最大距离和相应点的位置
                    dist=0;%置零复位以避免对程序后续运行产生干扰
                    if distmax>maxdist%只要还有超距现象
                        subPnts=subPnts(1:maxpIdx,:);%还需将轮廓线拆分，起点不变
                        suBpIdx=maxpIdx;%以超距点作为新的终点
                    else
                        fitlines(fLineIdx,3:4)=subPnts(suBpIdx,1:2);%当前轮廓段终点可作为拟合直线分段终点
                        if suBpIdx~=ptsIdx%排除特殊情况：整条轮廓线的最后一次正确拟合
                            lineIdx(cturIdx)=lineIdx(cturIdx)+1;
                            fLineIdx=fLineIdx+1;
                            fitlines(fLineIdx,1:2)=subPnts(suBpIdx,1:2);%给出新拟合线段的起点坐标，等于前段的终点坐标
                        end
                        cturPnts=cturPnts(suBpIdx:ptsIdx,:);%在完整轮廓线上去掉已被拟合为直线段的像素点
                        ptsIdx=ptsIdx-suBpIdx+1;%像素点个数也要做调整
                        subPnts=cturPnts;%重新赋初值
                        suBpIdx=ptsIdx;%重新赋初值
                    end
				end
				fitlines(fLineIdx,3:4)=cturPnts(ptsIdx,1:2); %终点
                SumIdx=SumIdx+lineIdx(cturIdx);
            end
        end
    end
end
conturIm=IsCturEx(2:rows+1,2:clmns+1);
fitlines=fitlines-1;
%sz=size(fitlines);
%figure(gcf+1);
%axis([1 clmns -1*rows -1]);
%hold on;
%for line=1:sz(1)
%    plot([fitlines(line,2) fitlines(line,4)],[-fitlines(line,1) -fitlines(line,3)]);
%end