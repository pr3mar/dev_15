% RANSAC implementation.
dir = 'epipolar';
matches_loaded = load(fullfile(dir, 'house_matches.txt'))';
[~, length] = size(matches_loaded);
pic_left = imread(fullfile(dir, 'house1.jpg'));
pic_right = imread(fullfile(dir, 'house2.jpg'));
matches_left = [matches_loaded(1:2,:); ones(1, length)];
matches_right = [matches_loaded(3:4,:); ones(1, length)];

figure(1); clf;
% left image
subplot(1,2,1); imagesc(pic_left); axis equal; axis tight; hold on;
plot(matches_left(1,:), matches_left(2,:), 'rx');

% right image
subplot(1,2,2); imagesc(pic_right); axis equal; axis tight; hold on;
plot(matches_right(1,:), matches_right(2,:), 'rx');

