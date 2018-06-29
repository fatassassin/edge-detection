function imagBW = kittlerMet(imag)

% KITTLERMET binarizes a gray scale image 'imag' into a binary image

% Input:

%   imag: the gray scale image, with black foreground(0), and white

%   background(255).

% Output:

%   imagBW: the binary image of the gray scale image 'imag', with kittler's

%   minimum error thresholding algorithm.

 

% Reference:

%   J. Kittler and J. Illingworth. Minimum Error Thresholding. Pattern

%   Recognition. 1986. 19(1):41-47

 

MAXD = 100000;

imag = imag(:,:,1);     %将图片存为一个三维数组

[counts, x] = imhist(imag);  % 获取直方图信息（向量） count为每一级灰度像素个数，x为灰度级

GradeI = length(x);   % GradeI为灰度级数 i.e.unit8时为256

J_t = zeros(GradeI, 1);  % 全0的256*1数组 用于存储最小误差函数

prob = counts ./ sum(counts);  % 获取不同灰度级的像素分布（向量）

meanT = x' * prob;  % 图片的平均灰度级 x'表示x转置

% Initialization

w0 = prob(1);   % 第一个灰度级的概率

miuK = 0;   % First-order cumulative moments of the histogram up to the kth level.

J_t(1) = MAXD;

n = GradeI-1;   %计数用

for i = 1 : n

    w0 = w0 + prob(i+1);

    miuK = miuK + i * prob(i+1); 

    if (w0 < eps) || (w0 > 1-eps)    %当灰度级概率累加出错时的操作

        J_t(i+1) = MAXD;    % T = i

    else

        miu1 = miuK / w0;

        miu2 = (meanT-miuK) / (1-w0);

        var1 = (((0 : i)'-miu1).^2)' * prob(1 : i+1);

        var1 = var1 / w0;  % 方差

        var2 = (((i+1 : n)'-miu2).^2)' * prob(i+2 : n+1);

        var2 = var2 / (1-w0);%方差

        if var1 > eps && var2 > eps   

            J_t(i+1) = 1+w0 * log(var1)+(1-w0) * log(var2)-2*w0*log(w0)-2*(1-w0)*log(1-w0); %最小误差函数

        else

            J_t(i+1) = MAXD;

        end

    end

end

minJ = min(J_t); %取最小误差函数的最小值作为阈值

index = find(J_t == minJ);

th = mean(index);

th = (th-1)/n;

imagBW = im2bw(imag, th);

 

% figure, imshow(imagBW), title('kittler binary');