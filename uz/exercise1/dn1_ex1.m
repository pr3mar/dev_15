% (a) --> read the image and show it
A = imread('umbrellas.jpg');
figure(1) ; clf ; imagesc(A);
figure(2) ; clf ; imshow(A);

% (b) --> grayscale
Ad = double(A);
% [h, w, d] = size(A);
A_gray = uint8((Ad(:,:,1) + Ad(:,:,2) + Ad(:,:,3))/ 3.0);
figure(2) ; clf ; imagesc(A_gray); colormap gray ;

% (c) --> image rectangle
image_rect_whole = A;
image_rect_whole(1:100,200:400, 3) = 0;
image_rect_part = A(1:100,200:400, 1);
figure(3); subplot(1,2,1); imshow(image_rect_whole);
subplot(1,2,2); imshow(image_rect_part);

% (d) --> inverted gray
inverted_gray = A_gray;
% [h, w, d] = size(inverted_gray);
inverted_gray(1:100,200:400, 1) = 255 - inverted_gray(1:100,200:400, 1);
figure(4) ; clf ; imagesc(inverted_gray); colormap gray ;

% (e) --> reduced gray levels
max_level = 64.0;
reduced_gray = double(A_gray);
maxVal = max(max(reduced_gray));
devisor = maxVal/max_level;
reduced_gray = uint8(round(reduced_gray ./ devisor));
figure(5) ; clf ; imagesc(reduced_gray); colormap gray;
figure(6) ; clf ; imshow(reduced_gray); colormap gray;



