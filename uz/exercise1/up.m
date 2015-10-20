% up_rgb = imread('up.jpg');
% up_gray = rgb2gray(up_rgb);
% % multitresholding using otsu's method
% th = multithresh(up_gray, 2);
% up_mask = up_gray < th(1);
% up_se = strel('disk', 10);
% up_mask = imerode(imdilate(up_mask,up_se),up_se);
% figure(1) ; imagesc(up_mask); colormap gray
% up_masked = immask(up_rgb, up_mask);
% figure(1) ; imagesc(up_masked);

stones = imread('stones.jpg');
stones_gray = rgb2gray(stones);
th = multithresh(stones_gray, 4);
stones_mask = not(stones_gray < th(1));
b_se = strel('disk', 4);
stones_mask = imdilate(imerode(stones_mask, b_se), b_se);
% figure(2) ; imagesc(stones_mask); colormap gray

labels = bwlabel(stones_mask);

label_max = max(labels(:));
maxSum = 1000000; % minSum = intmax
maxI = 0;   % minI = 0
sums = zeros(1, label_max);
indices = (1:label_max);
% remove biggest portion / smallest 
for i = 1: label_max
    suma = sum(labels(:) == i);
    sums(i) = suma;
%     if suma < maxSum % if suma < maxSum
%         labels(labels == i) = 0;
% %         maxSum = suma;
% %         maxI = i; % minI = i
%     end;
end;
% labels(labels == maxI) = 255;
indices(sums > mean(sums)) = 0;
for i = 1 : length(indices)
    labels(labels(:) == indices(i)) = 0;    
end

% rnd = randi([0,label_max])
% labels(labels == rnd) = 0;

figure(3) ; imagesc(labels);
labels(labels > 1) = 1;
figure(4) ; imagesc(immask(stones, labels));