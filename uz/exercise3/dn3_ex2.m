% (a), (b)
museum = rgb2gray(imread('museum.jpg'));
sigma = 1;
theta = 20;
figure(1); clf
imagesc(findEdges(museum, sigma, theta)); 
axis tight equal; colormap gray;