% A1 = [0 0 3 3; 0 0 3 3; 2 2 1 1; 2 2 1 1];
% A2 = [2 2 1 1; 2 2 1 1; 0 0 3 3; 0 0 3 3];
% A3 = [0 3 0 3; 3 0 3 0; 1 2 1 2; 2 1 1 2];
% 
% [Ca1, dot1] = getDot(A1, [-1,2]);
% [Ca2, dot2] = getDot(A2, [-1,2]);
% [Ca3, dot3] = getDot(A3, [-1,2]);
% 
% [dot1(3), dot2(3), dot3(3)]
% figure(1); plot3(dot1(1),dot1(2), dot1(3), 'rx'); grid on; hold on;
% plot3(dot2(1),dot2(2), dot2(3), 'rx');
% plot3(dot3(1),dot3(2), dot3(3), 'rx'); hold off;

img1 = rgb2gray(imread('board.png')); 
img2 = rgb2gray(imread('sinusoidal.png')); 
img3 = rgb2gray(imread('uniform_noise.png')); 
figure(2); colormap gray;
maxLevel = 10;
red1 = reduceLevels(img1, maxLevel);
red2 = reduceLevels(img2, maxLevel);
red3 = reduceLevels(img3, maxLevel);
subplot(2,3,1); imagesc(img1); axis equal; axis tight;
subplot(2,3,2); imagesc(img2); axis equal; axis tight;
subplot(2,3,3); imagesc(img3); axis equal; axis tight;
[Ca_img1, dot_img1] = getDot(red1, [-1,2]);
subplot(2,3,4); imagesc(Ca_img1); axis equal; axis tight;
[Ca_img2, dot_img2] = getDot(red2, [-1,2]);
subplot(2,3,5); imagesc(Ca_img2); axis equal; axis tight;
[Ca_img3, dot_img3] = getDot(red3, [-1,2]);
subplot(2,3,6); imagesc(Ca_img3); axis equal; axis tight;

figure(3); plot3(dot_img1(1),dot_img1(2), dot_img1(3), 'rx'); grid on; hold on;
plot3(dot_img2(1),dot_img2(2), dot_img2(3), 'rx');
plot3(dot_img3(1),dot_img3(2), dot_img3(3), 'rx'); hold off;