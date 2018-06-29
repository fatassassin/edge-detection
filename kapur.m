function imagBW = kapur(imag)
% Kapur���������ֵ����ֵ
%	ͨ������ǰ�����ͱ��������أ���ʹ������Ӧ�ĻҶȡ�����һ��ȫ����ֵ�Ķ�ֵ��������
% ���룺
%   imag: �Ҷ�ͼ��256����
% �����
%   imagBW: ��ֵ��ͼ��
% �ο����ף�
%	�°����������. ����ң��ͼ������Բ���Ϳ���Զ�ʶ�𷽷�. ��繤��. 2006, 33(9):96-100
%   J.N. Kapur, P.K. Sahoo, A.K.C. Wong. A New Method for Gray-Level
%   Picture Thresholding Using the Entropy of the Histogram. Computer
%   Vision, Graphics, and Image Processing. 29(1985):273-285
% ע�⣺
%   No median filtering for postprocessing.
% Assumption: 
%   the original image is not a two-valued image.
% �޸ļ�¼��
%   by Liang XU. 2009/10/17. ȥ����һЩע�͡�

imag = imag(:, :, 1); % gray image
counts = imhist(imag);  % counts are the histogram
GradeI = 256;    % the resolusion of the intensity. i.e. 256 for uint8.
% MIN = 1e-7;

prob = counts ./ sum(counts);  % Probability distribution

psai = zeros(GradeI, 1);    % �������Ŀ�꺯��
prob_t = 0;
entropy_t = 0;              % �������е�Ht

ind = find(prob);
entropy_L = sum( prob(ind) .* log(prob(ind)) ) * (-1); % �������е�H_L-1

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

        


