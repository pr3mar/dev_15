A = imread('umbrellas.jpg');
% figure(1) ; clf ; imagesc(A);
% figure(2) ; clf ; imshow(A);

Ad = double(A);
% [h, w, d] = size(A);
A_gray = uint8((Ad(:,:,1) + Ad(:,:,2) + Ad(:,:,3))/ 3.0);
% figure(2) ; clf ; imagesc(A_gray); colormap gray ;

image_rect = A(1:100,200:400, :);
A(1:100,200:400, 3) = 0;
% figure(1) ; clf ; imagesc(A);
% figure(3) ; clf ; imagesc(image_rect);

inverted_gray = A_gray;
% [h, w, d] = size(inverted_gray);
inverted_gray(1:100,200:400, 1) = 255 - inverted_gray(1:100,200:400, 1);
% figure(4) ; clf ; imagesc(inverted_gray); colormap gray ;

reduced_gray = double(A_gray);
maxVal = max(max(reduced_gray));
dev = maxVal/64.0;
reduced_gray = uint8(round(reduced_gray ./ dev));
figure(1) ; clf ; imagesc(reduced_gray); %colormap gray;
figure(2) ; clf ; imshow(reduced_gray); % colormap gray;