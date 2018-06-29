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

bgColr=bwIm(1,1);%���������Ͻǵ����ص�һ���Ǳ���ɫ
[rows, clmns]=size(bwIm);
%�Ƚ�ͼ���������Ҹ�����һ��
Iext(rows+2,clmns+2)=bgColr;
Iext(1,:)=bgColr;
Iext(rows+2,:)=bgColr;
Iext(:,1)=bgColr;
Iext(:,clmns+2)=bgColr;
Iext(2:rows+1,2:clmns+1)=bwIm;
IsCturEx(1:rows+2,1:clmns+2)=bgColr;%���ͼ��׸壬ȫ����ɫ
cturIdx=0;%�����ߵ���������ֵ��Ϊ0
SumIdx=0;%fitlines������߶��������ѷ��ֲ���ȫ��ϵ������ߵ��ۼƣ���ֵ��Ϊ0

for i=2:(rows+1)
    for j=2:(clmns+1)
        if (Iext(i,j)~=Iext(i,j-1))&&(IsCturEx(i,j)==IsCturEx(i,j-1))%����ڰױ�ɫ����δ�����
            if Iext(i,j)==bgColr
                theta=pi;%�����
                j0=j-1;%�������Ӧ����ǰ��ɫ
                i0=i;
            else
                theta=0;
                j0=j;
                i0=i;
            end
            ptsIdx=1;%�����������ص�ĸ�������ֵ
            cturPnts(ptsIdx,1:2)=[i0 j0];%�þ���������¼��ǰ���������������ص�����꣬��������������߰��������ص���
            IsCturEx(i0,j0)=1-bgColr;%�����ͼ���ϱ�ǣ���ǰ������
            iend=i+1;%�����յ㣻��ֵ�����壬ֻҪ�������������ͬ����
            jend=j;%��Ϊ����ἴʱ�޸ĵ�
            inext=i0;%�������whileѭ������ֵ
            jnext=j0;
            while (i0~=iend)||(j0~=jend)%ֻҪ����δ���
                for direct=0:7%�ܱߵİ˸���
                    ipt=inext-round(cos(direct*pi/4-theta));
                    jpt=jnext+round(sin(direct*pi/4-theta));%�������Ǹ��ݵ�ǰ�ķ��򣨽Ƕ�theta����ȷ���˸��������˳��
                    if (Iext(ipt,jpt)~=bgColr&&(IsCturEx(ipt,jpt)==bgColr))||(ipt==i0&&jpt==j0)
                        theta=theta+pi/2-direct*pi/4;%ȷ������
                        inext=ipt;
                        jnext=jpt;
                        iend=ipt;
                        jend=jpt;
                        IsCturEx(ipt,jpt)=1-bgColr;
                        ptsIdx=ptsIdx+1;
                        cturPnts(ptsIdx,1:2)=[ipt jpt];
                        break;%����break����forѭ��
                    end
                end
                if inext~=ipt||jnext~=jpt
                    break;%contour endpoint process, break����whileѭ��
                end
            end
            if ptsIdx>=minline%�������ص�̫�ٵ������߱���Ϊ������
                cturIdx=cturIdx+1;%�����ߵ���Ŀ
                lineIdx(cturIdx)=1;%�������ߵĵ�1�����ֱ�߶�
                fLineIdx=SumIdx+lineIdx(cturIdx);%����ܵ�fitlines���������±꣩
                fitlines(fLineIdx,1:2)=cturPnts(1,1:2);%�������ߵĵ�1�����ֱ�߶ε��������
				subPnts=cturPnts;%subPnts�Ǽ��������߽����˲��ʱ��ǰһ�������ߵ����ص�����꼯�ϣ��ڴ����ֵ
				suBpIdx=ptsIdx;%suBpIdx�Ǽ��������߽����˲��ʱ��ǰһ�������ߵĵ������ڴ������ֵ
                if (i0==iend)&&(j0==jend)%����Ƿ�յ�������
                    if ptsIdx>(2*maxdist+2)%���������߷�����ֻ�����ص�����������½�ʱ���ſ�����ĳ�����ص㵽ʼĩ�����ߵľ������maxdist
                        fitlines(fLineIdx,3:4)=cturPnts(2*maxdist+2,1:2);%����������߲�֣�ǰһ�ι̶�ʼĩ�㣬ȷ��������
                        SumIdx=SumIdx+lineIdx(cturIdx);
                        cturIdx=cturIdx+1;
                        lineIdx(cturIdx)=1;
                        fLineIdx=SumIdx+lineIdx(cturIdx);
                        fitlines(fLineIdx,1:2)=cturPnts(2*maxdist+2,1:2);%��һ�������ǰһ���յ�
                        %fitlines(cturIdx,3:4)=[iend jend];%��ע�͵�����Ϊ���ڻ�����ȷ����������ߵ��յ�
                        cturPnts(1:ptsIdx-2*maxdist-1,:)=cturPnts(2*maxdist+2:ptsIdx,:);%��Ӧ�����ص㼯��Ҫ������
                        ptsIdx=ptsIdx-2*maxdist-1;%���ص����ҲҪ����������������������Ϊ��һ�ηǷ�������߻���������϶������
                        subPnts=cturPnts;
                        suBpIdx=ptsIdx;
                    else%�����ص���ٵķ��������
                        fitlines(fLineIdx,3:4)=cturPnts(floor(ptsIdx/2),1:2);%ֱ�����������е�����֣���������Ͻ��
                        SumIdx=SumIdx+lineIdx(cturIdx);
                        cturIdx=cturIdx+1;
                        lineIdx(cturIdx)=1;
                        fLineIdx=SumIdx+lineIdx(cturIdx);
                        fitlines(fLineIdx,1:2)=cturPnts(floor(ptsIdx/2),1:2);
                        %fitlines(fLineIdx,3:4)=[i0 j0];%��ʵ��������¾��Ǳ���ϳ�����������ֱ��
                        %SumIdx=SumIdx+lineIdx(cturIdx);
                        %����������Ϊ�������whileѭ����������ظ�����˱�ע�͵���
                    end
                end
				while ptsIdx>(2*maxdist+2)%ֻ�����ص���������½�(2*maxdist+2)ʱ���ſ�����ĳ�����ص㵽ʼĩ�����ߵľ������maxdist
                    dist(1:ptsIdx)=0;
                    for pIdx=maxdist+2:(suBpIdx-maxdist-1)
					%for pIdx=2:(suBpIdx-1)
                        dist(pIdx)=tpHeight(subPnts(1,1:2),subPnts(suBpIdx,1:2),subPnts(pIdx,1:2));
					end
                    [distmax, maxpIdx]=max(dist);%ȷ�����������Ӧ���λ��
                    dist=0;%���㸴λ�Ա���Գ���������в�������
                    if distmax>maxdist%ֻҪ���г�������
                        subPnts=subPnts(1:maxpIdx,:);%���轫�����߲�֣���㲻��
                        suBpIdx=maxpIdx;%�Գ������Ϊ�µ��յ�
                    else
                        fitlines(fLineIdx,3:4)=subPnts(suBpIdx,1:2);%��ǰ�������յ����Ϊ���ֱ�߷ֶ��յ�
                        if suBpIdx~=ptsIdx%�ų�������������������ߵ����һ����ȷ���
                            lineIdx(cturIdx)=lineIdx(cturIdx)+1;
                            fLineIdx=fLineIdx+1;
                            fitlines(fLineIdx,1:2)=subPnts(suBpIdx,1:2);%����������߶ε�������꣬����ǰ�ε��յ�����
                        end
                        cturPnts=cturPnts(suBpIdx:ptsIdx,:);%��������������ȥ���ѱ����Ϊֱ�߶ε����ص�
                        ptsIdx=ptsIdx-suBpIdx+1;%���ص����ҲҪ������
                        subPnts=cturPnts;%���¸���ֵ
                        suBpIdx=ptsIdx;%���¸���ֵ
                    end
				end
				fitlines(fLineIdx,3:4)=cturPnts(ptsIdx,1:2); %�յ�
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