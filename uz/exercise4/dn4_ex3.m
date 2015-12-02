% (a, b)
%new york
% img1 = imread('newyork/newyork1.png');
% img2 = imread('newyork/newyork2.png');
% points = csvread('newyork/newyork.txt');
% px1 = points(1,:); py1 = points(2,:);
% px2 = points(3,:); py2 = points(4,:);
% 
% H = estimate_homography(px1, py1, px2, py2);
% transformed = transform_homography(img1, H);
% 
% figure(1); colormap gray; 
% subplot(1,3,1); imagesc(img1); axis equal; axis tight;
% subplot(1,3,2); imagesc(img2); axis equal; axis tight;
% subplot(1,3,3); imagesc(transformed); axis equal; axis tight;

% % graffiti
% img1 = rgb2gray(imread('graf/graf1.png'));
% img2 = rgb2gray(imread('graf/graf2.png'));
% points = csvread('graf/graf.txt');
% px1 = points(1,:); py1 = points(2,:);
% px2 = points(3,:); py2 = points(4,:);
% 
% H_2 = estimate_homography(px1, py1, px2, py2);
% transformed_2 = transform_homography(img1, H_2);
% 
% figure(2); colormap gray; 
% subplot(1,3,1); imagesc(img1); axis equal; axis tight;
% subplot(1,3,2); imagesc(img2); axis equal; axis tight;
% subplot(1,3,3); imagesc(transformed_2); axis equal; axis tight;



% (c)
% img1 = imread('newyork/newyork1.png');
% img2 = imread('newyork/newyork2.png');
img1 = rgb2gray(imread('graf/graf1.png'));
img2 = rgb2gray(imread('graf/graf2.png'));

sigma = 3; tsh = 100; bins = 100; m = 50;
M = find_matches(img1, img2, sigma, tsh, bins, m);
dists = M(:, 5); [~, indDist] = sort(dists);
px1 = M(indDist, 1); py1 = M(indDist, 2);
px2 = M(indDist, 3); py2 = M(indDist, 4);
H_2 = estimate_homography(px1(1:10), py1(1:10), px2(1:10), py2(1:10));
transformed_2 = transform_homography(img1, H_2);

figure(3); colormap gray; 
subplot(1,3,1); imagesc(img1); axis equal; axis tight;
subplot(1,3,2); imagesc(img2); axis equal; axis tight;
subplot(1,3,3); imagesc(transformed_2); axis equal; axis tight;
