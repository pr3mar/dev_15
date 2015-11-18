E = zeros(100);
E(10,10) = 1;
E(20,20) = 1;

% figure; imagesc(imread('oneline.png'));

oneline = rgb2gray(imread('oneline.png'));
oneline_edges = findEdges(oneline, 1, 1); %colormap gray;
% figure(1); imagesc(oneline); colormap gray
% figure(2); imagesc(oneline_edges); colormap gray
[rho, theta] = hough_find_lines(oneline_edges, 500, 500, 0);
% imagesc(hough(oneline_edges));
% figure(1); imagesc(E); colormap gray;
% [rho, theta] = hough_find_lines(E, 300, 400, 0);
% imagesc(hough(oneline))
% figure; imagesc(imread('rectangle.png'))