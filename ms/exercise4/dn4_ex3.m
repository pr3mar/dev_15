addpath('grabcut');

% P = rand(100,100,2); % initializesomerandomdata
% P(:,:,2) = 1 - P(:,:,1);
% figure(1); imagesc(P(:,:,1));
% figure(2); imagesc(P(:,:,2));
% cost = (ones(2) - eye(2))*10; % define cost(experiment with scaling)
% gch = GraphCut('open',P, cost);% initialize GraphCut context : P is probability matrix
% [gch, L] = GraphCut('expand', gch);% perform graph?cut and retreive result
% gch = GraphCut('close', gch);% release memory
% S = L ~= 0;
% figure(3); imagesc(S);

img = imread('parrot2.jpg');
mask = imread('parrot2_mask.png');
% figure(1); clf; imagesc(img);
% mask = roipoly();
% figure(1); imagesc(mask); colormap gray;
res = grab_cut(img, mask, 17, 0.03, 2); % parrot 1
% res = grab_cut(img, mask, 25, 0.001, 2); % parrot 1
figure(2); colormap gray;
imagesc(immask(img, res));
% res = grab_cut_metod(img, mask);
% figure(3); colormap gray;
% imagesc(immask(img, res));
