addpath('grabcut');

% P = rand(100,100,2); % initializesomerandomdata
% P(:,:,2) = 1 - P(:,:,1);
% cost = (ones(2) - eye(2))*10; % define cost(experiment with scaling)
% gch = GraphCut('open',P, cost);% initialize GraphCut context : P is probability matrix
% [gch, L] = GraphCut('expand', gch);% perform graph?cut and retreive result
% gch = GraphCut('close', gch);% release memory
% S = L ~= 0;

img = imread('fish.jpg');
% figure(1); clf; imagesc(img);
% mask = roipoly();
grab_cut(img, mask);