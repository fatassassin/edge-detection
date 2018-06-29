function imagBW = kapur(imag)
% Kapur方法计算二值化阈值
%	通过定义前景类别和背景类别的熵，求使熵最大对应的灰度。这是一种全局阈值的二值化方法。
% 输入：
%   imag: 灰度图像（256级）
% 输出：
%   imagBW: 二值化图像
% 参考文献：
%	陈爱军，李金宗. 卫星遥感图像中类圆形油库的自动识别方法. 光电工程. 2006, 33(9):96-100
%   J.N. Kapur, P.K. Sahoo, A.K.C. Wong. A New Method for Gray-Level
%   Picture Thresholding Using the Entropy of the Histogram. Computer
%   Vision, Graphics, and Image Processing. 29(1985):273-285
% 注意：
%   No median filtering for postprocessing.
% Assumption: 
%   the original image is not a two-valued image.
% 修改记录：
%   by Liang XU. 2009/10/17. 去掉了一些注释。

imag = imag(:, :, 1); % gray image
counts = imhist(imag);  % counts are the histogram
GradeI = 256;    % the resolusion of the intensity. i.e. 256 for uint8.
% MIN = 1e-7;

prob = counts ./ sum(counts);  % Probability distribution

psai = zeros(GradeI, 1);    % 即里面的目标函数
prob_t = 0;
entropy_t = 0;              % 即文章中的Ht

ind = find(prob);
entropy_L = sum( prob(ind) .* log(prob(ind)) ) * (-1); % 即文章中的H_L-1

for i = 0 : GradeI-1
    prob_t = prob_t + prob(i+1);
    
    if prob(i+1) > 0 && prob_t < 1
        entropy_t = entropy_t - prob(i+1) * log(prob(i+1));
        psai(i+1) = log(prob_t * (1-prob_t)) + entropy_t / prob_t + ...
            (entropy_L-entropy_t) / (1-prob_t);
    elseif (prob(i+1) == 0 && i > 0) 
        psai(i+1) = psai(i);
    end
end

[maxPsai, ind] = max(psai);
th = (ind - 1) / (GradeI -1);
imagBW = im2bw(imag, th);

        


