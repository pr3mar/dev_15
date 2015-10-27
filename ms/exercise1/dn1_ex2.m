% (b) --> histogram (provided code)
I = double(rgb2gray(imread('umbrellas.jpg')));
nbins = 20;
[H, bins] = myhist(I, nbins);
figure(2) ; subplot(1,2,1); bar(bins, H);
% razlicno dolocita prag.
[H, bins] = hist(I(:), nbins);
H = H/sum(H);
figure (2);subplot(1,2,2);  bar(bins, H);

% (c) --> other images
% I = double(rgb2gray(imread('umbrellas.jpg')));
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
figure(4); subplot(1,2,1); imshow(I); axis equal; axis tight;
figure(5);  subplot(1,2,1);  bar(bins, H); %axis equal; axis tight;
stretched = histstretch(I);
figure(4); subplot(1,2,2); imshow(stretched);  axis equal; axis tight;
nbins = 10;
[H, bins] = myhist(stretched, nbins);
figure(5);  subplot(1,2,2); bar(bins, H);  %axis equal; axis tight;

