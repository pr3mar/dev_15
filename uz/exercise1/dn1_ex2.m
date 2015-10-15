A = rgb2gray(imread('bird.jpg'));
figure (3); imagesc(imread('bird.jpg')); 
r = myhist(A, 10);
% c = hist(double(A), 10);
figure ; bar(r);
% figure ; bar(c);

M = A > 65;
figure ; imagesc(M); colormap gray
