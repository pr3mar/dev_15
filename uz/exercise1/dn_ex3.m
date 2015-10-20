% % (a) - morphological operations
% mask = logical(imread('mask.png'));
% structuring_element = ones(3);
% structuring_element = strel('disk', 1);
% structuring_element = strel('line', 5, 45);
% figure(1); subplot(1,5,1); imagesc(mask); axis equal; axis tight; title('original');
% % erode
% figure(1); subplot(1,5,2);
% imagesc(imerode(mask, structuring_element)); axis equal; axis tight; title('erode');
% % dilage
% figure(1); subplot(1,5,3);
% imagesc(imdilate(mask, structuring_element)); axis equal; axis tight; title('dilate');
% % dilate && erode (closing)
% figure(1); subplot(1,5,4);
% imagesc(imerode(imdilate(mask, structuring_element),structuring_element)); axis equal; axis tight; title('dilate & erode');
% % erode && dilate (opening)
% figure(1); subplot(1,5,5);
% imagesc(imdilate(imerode(mask, structuring_element),structuring_element)); axis equal; axis tight; title('erode & dilate');

% % (b) - bird mask
% bird = rgb2gray(imread('bird.jpg'));
% threshold = threshold_otsu(bird);
% bird_mask = bird > threshold;
% % bird_se = strel('disk', 50); % 19
% % bird_se = strel('octagon', 18); % 19
% bird_se = strel('square', 19); % 19
% figure(2); subplot(2,3,1); imagesc(bird_mask); colormap gray; axis equal; axis tight; title('original ');
% closed = imerode(imdilate(bird_mask, bird_se),bird_se);
% figure(2); subplot(2,3,2); imagesc(closed); axis equal; axis tight; title('closed');
% opened = imdilate(imerode(bird_mask, bird_se),bird_se);
% figure(2); subplot(2,3,3); imagesc(opened); axis equal; axis tight; title('opened');
% 
% % (c) - display masked image
% bird = imread('bird.jpg');
% masked = immask(bird, closed);
% figure(3); imshow(masked); colormap default;  axis equal; axis tight; title('masked image');

% (d) - eagle mask
eagle = imread('eagle.jpg');
eagle_gray = rgb2gray(eagle);
threshold = threshold_otsu(eagle_gray);
eagle_mask = eagle_gray > threshold;
eagle_se = strel('diamond', 6);
% open image, negate the result
eagle_mask = not(imdilate(imerode(eagle_mask, eagle_mask), eagle_se));
% eagle_mask = imerode(imdilate(eagle_mask, eagle_mask),eagle_mask);
figure(4); imagesc(eagle_mask); axis equal; axis tight; title('closed');
eagle_masked = immask(eagle, eagle_mask);
figure(5); imshow(eagle_masked);