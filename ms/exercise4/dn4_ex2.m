img = rgb2gray(imread('zebra.jpg'));
R = 20;
patches = toPatches(img, R);

% figure; imshow(uint8(patches(:,:,end - 1)));