function edgeK=Kirsch(oimage)
[xlen, ylen] = size(oimage);
edge = zeros(xlen,ylen);
K = zeros(8,1);
t = zeros(8,1);
for i = 2:xlen-1
    for j = 2:ylen-1
        temp = sum(sum(oimage([i-1:i+1],[j-1:j+1])))-oimage(i,j);
        K(1) = oimage(i-1,j-1)+oimage(i-1,j)+oimage(i-1,j+1);  %North
        K(2) = oimage(i-1,j)+oimage(i-1,j+1)+oimage(i,j+1);    %Northeast
        K(3) = oimage(i-1,j+1)+oimage(i,j+1)+oimage(i+1,j+1);  %East
        K(4) = oimage(i,j+1)+oimage(i+1,j+1)+oimage(i+1,j);    %Southeast
        K(5) = oimage(i+1,j+1)+oimage(i+1,j)+oimage(i+1,j-1);  %South
        K(6) = oimage(i+1,j)+oimage(i+1,j-1)+oimage(i,j-1);    %Southweast
        K(7) = oimage(i+1,j-1)+oimage(i,j-1)+oimage(i-1,j-1);  %Weast
        K(8) = oimage(i,j-1)+oimage(i-1,j-1)+oimage(i-1,j);    %NorthWest
        for m = 1:8
            t(m) = temp-K(m);
        end
        edge(i,j) = max(abs(5*K-3*t));
    end
end

rsum=0;
counter=0;
for i = 2:xlen-1
    for j = 2:ylen-1 
        if(edge(i,j)>200)
            rsum=rsum+edge(i,j);
            counter=counter+1;
        end
    end
end
threshold=rsum/counter; 
for i = 2:xlen-1
    for j = 2:ylen-1
        if (edge(i,j)>threshold)
            edgeimage(i,j) = 255;
        else
            edgeimage(i,j) = 0;
        end
    end
end
edgeK=edgeimage;

    