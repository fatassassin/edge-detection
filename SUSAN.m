function imgEdge = SUSAN(img,threshold)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% 7*7
%----------------------------------------------
d=length(size(img));
if d==3
    image=double(rgb2gray(img));
elseif d==2
    image=double(img);
end
mask=([ 0 0 1 1 1 0 0;
       0 1 1 1 1 1 0;
       1 1 1 1 1 1 1;
       1 1 1 1 1 1 1;
       1 1 1 1 1 1 1;
       0 1 1 1 1 1 0;
       0 0 1 1 1 0 0 ]);
   R=zeros(size(image));
   nmax=3*37/4;% Nmax
   [a,b]=size(image);
   new=zeros(a+7,b+7);
   [c,d]=size(new);
   new(4:c-4,4:d-4)=image;
   for i=4:c-4
       for j=4:d-4
           current_image=new(i-3:i+3,j-3:j+3);%7*7
           current_masked=mask.*current_image;
           %current_thresholded=susan_threshold(current_masked,threshold);
           current_thresholded=current_masked; 
           center_threshold=current_masked(4,4);
           for m=1:7
               for n=1:7
                   compareValue=abs(current_masked(m,n)-center_threshold);
                   if compareValue>threshold
                       current_thresholded(m,n)=0;
                   else
                       current_thresholded(m,n)=1;
                   end
               end
           end
           g=sum(current_thresholded(:));
           if nmax>g
               R(i-3,j-3)=nmax-g;
           else
               R(i-3,j-3)=0;
           end
       end
   end
   imgEdge=R;
  
end
%------------------------
% function current_thresholded=susan_threshold(masked_image,threshold)
% current_thresholded=masked_image; 
% center_threshold=masked_image(4,4);
% for i=1:7
%     for j=1:7
%         compareValue=abs(masked_image(i,j)-center_threshold);
%         if compareValue>threshold
%             current_thresholded(i,j)=0;
%         else
%             current_thresholded(i,j)=1;
%         end
%     end
% end
% end
