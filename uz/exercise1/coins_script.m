I = imread('coins.jpg');
th = threshold_otsu(rgb2gray(I));
coins_mask = rgb2gray(I) < th;
coins_se = strel('disk', 11);
closed = imerode(imdilate(coins_mask, coins_se),coins_se);
% closed = imdilate(imerode(coins_mask, coins_se),coins_se);
% figure(1) ; imagesc(closed); colormap gray
coins_masked = immask(I, closed);
% figure(2) ; imagesc(coins_masked); colormap gray
L = bwlabel(closed);
% figure(3) ; imagesc(L); colormap gray
label_max = max(L(:));
maxSum = 0; % minSum = intmax
maxI = 0;   % minI = 0
% % remove biggest portion / smallest 
% for i = 1: label_max
%     suma = sum(L(:) == i);
%     if suma > maxSum % if suma < maxSum
%         maxSum = suma
%         maxI = i % minI = i
%     end;
% end;
% L(L == maxI) = 0;

% remove random portion
rnd = randi([0,label_max]);
L(L == rnd) = 0;

figure(4)
subplot(1, 2, 1);
imshow(I); title('original');
subplot(1,2,2);
imshow(immask(I, L > 0)); title('processed');
colormap gray;

% could use opening (erode && dilate) instead of closing 
% when applying morphological operations,
% but it is very tricky to get the right amount