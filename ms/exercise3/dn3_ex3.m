img1 = imread('underwater.jpg');
img2 = imread('eagle.jpg');
mask = rgb2gray(imread('eagle_mask.png'));
blended = blend_smooth(img1, img2, mask,5);

figure(1); clf; imagesc(blended);