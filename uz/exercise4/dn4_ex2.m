% % (a, b)
% img = rgb2gray(imread('test_points.png'));
% sigma = 3; tsh = 100; bins = 16; m = 41;
% [px, py] = hessian_points(img, sigma, tsh);
% D1 = descriptors_maglap(img, px, py, m, sigma, bins);
% D2 = D1;
% [indices, distance] = find_correspondences(D1, D2);
% px2 = px(indices);
% py2 = py(indices);
% displaymatches(img, px, py, img, px2, py2);
% figure; clf; colormap gray;
% imagesc(img); hold on;
% plot(px2, py2,'rx'); hold off;

% % (b)
% img1 = rgb2gray(imread('graf/graf1_small.png')); %'test_points.png'));
% img2 = rgb2gray(imread('graf/graf2_small.png')); %'test_points.png'));
% sigma = 3; tsh = 100; bins = 100; m = 50;
% [px1, py1] = hessian_points(img1, sigma, tsh);
% [px2, py2] = hessian_points(img2, sigma, tsh);
% % figure; clf; imagesc(img1); colormap gray; hold on; plot(px1, py1, 'rx'); hold off; title('1');
% % figure; clf; imagesc(img2); colormap gray; hold on; plot(px2, py2, 'rx'); hold off; title('2');
% D1 = descriptors_maglap(img1, px1, py1, m, sigma, bins);
% D2 = descriptors_maglap(img2, px2, py2, m, sigma, bins);
% [indices, distance] = find_correspondences(D1, D2);
% px2 = px2(indices);
% py2 = py2(indices);
% displaymatches(img1, px1, py1, img2, px2, py2);

% (c)
img1 = rgb2gray(imread('graf/graf1.png'));  
img2 = rgb2gray(imread('graf/graf2_small.png'));
sigma = 3; tsh = 100; bins = 100; m = 50;
M = find_matches(img1, img2, sigma, tsh, bins, m);
displaymatches(img1, M(:,1), M(:,2), img2, M(:,3), M(:,4));
