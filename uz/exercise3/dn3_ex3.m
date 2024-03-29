% E = zeros(100);
% E(10,10) = 1;
% E(20,20) = 1;
% [rho, theta] = hough_(E, 300, 400, 1);
% figure(1); clf;draw_hough_lines(E,rho, theta);
% 
% oneline = rgb2gray(imread('oneline.png'));
% oneline_edges = findEdges(oneline, 1, 1); colormap gray;
% tic
% [rho, theta] = hough_(oneline_edges, 300, 200, 200);
% toc
% figure(2); clf; draw_hough_lines(oneline, rho, theta);
% 
% rectangle = rgb2gray(imread('rectangle.png'));
% rectangle_edges = findEdges(rectangle, 1, 1); %colormap gray;
% [rho, theta] = hough_(rectangle_edges, 300, 200, 200);
% figure(3); clf; draw_hough_lines(rectangle, rho, theta);

pier = rgb2gray(imread('pier.jpg'));
pier_edges = findEdges(pier, 3, 10);
figure(4); clf;%subplot(1,2,1); imagesc(pier); colormap default;
subplot(1,2,1); imagesc(pier_edges); colormap gray;
[rho, theta] = hough_(pier_edges, 600, 500, 320);
figure(4); subplot(1,2,2); draw_hough_lines(pier, rho, theta);

skyscraper = rgb2gray(imread('skyscraper.jpg'));
skyscraper_edges = findEdges(skyscraper, 4, 10);
figure(5); clf; subplot(1,2,1); imagesc(skyscraper_edges); colormap default;
subplot(1,2,2); imagesc(skyscraper_edges); colormap gray
[rho, theta] = hough_(skyscraper_edges, 600, 500, 90);
figure(5); subplot(1,2,2); draw_hough_lines(skyscraper, rho, theta);