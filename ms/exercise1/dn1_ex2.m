% % (a) --> manual treshold (65)
% A = rgb2gray(imread('bird.jpg'));
% treshold = 65;
% M = A > treshold;
% figure(1) ; imagesc(M); colormap gray
% figure ; imagesc(imread('bird.jpg')); 


% (b) --> histogram (provided code)
% I = double(rgb2gray(imread('umbrellas.jpg')));
% nbins = 20;
% [H, bins] = myhist(I, nbins);
% figure(2) ; bar(bins, H);
% razlicno dolocita prag.
% [H, bins] = hist(I(:), nbins);
% H = H/sum(H);
% figure (3); bar(bins, H);

% (c) --> embedded histogram function
% P = I(:); % 2d to 1d vector
% figure(3); clf;
% 
% bins = 10;
% H = hist(P, bins);
% H = H/sum(H); % normalize
% subplot(1,3,1); bar(H, 'b');
% 
% bins = 20;
% H = hist(P, bins);
% H = H/sum(H); % normalize
% subplot(1,3,2); bar(H, 'b');
% 
% bins = 30;
% H = hist(P, bins);
% H = H/sum(H); % normalize
% subplot(1,3,3); bar(H, 'b');

% (d) --> histogram stretching
I = imread('phone.jpg');
nbins = 10;
[H, bins] = myhist(I, nbins);
figure(4); subplot(1,2,1); axis equal; axis tight; imshow(I);
figure(5);  subplot(1,2,1); axis equal; axis tight; bar(bins, H);
stretched = histstretch(I);
figure(4); subplot(1,2,2); axis equal; axis tight; imshow(stretched);
nbins = 10;
[H, bins] = myhist(stretched, nbins);
figure(5);  subplot(1,2,2); axis equal; axis tight; bar(bins, H);

