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

% b - bird mask
bird = rgb2gray(imread('bird.jpg'));
threshold = threshold_otsu(bird);
bird_mask = bird > threshold;
% bird_se = strel('disk', 50); % 19
% bird_se = strel('octagon', 18); % 19
bird_se = strel('square', 19); % 19
figure(2); subplot(2,3,1); imagesc(bird_mask); colormap gray; axis equal; axis tight; title('original ');
figure(2); subplot(2,3,2); imagesc(imerode(imdilate(bird_mask, bird_se),bird_se)); axis equal; axis tight; title('closed');
figure(2); subplot(2,3,3); imagesc(imdilate(imerode(bird_mask, bird_se),bird_se)); axis equal; axis tight; title('opened');
