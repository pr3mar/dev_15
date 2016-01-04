% RANSAC implementation.
% dir = 'epipolar';
% matches_loaded = load(fullfile(dir, 'house_matches.txt'))';
% [~, length] = size(matches_loaded);
% pic_left = imread(fullfile(dir, 'house1.jpg'));
% pic_right = imread(fullfile(dir, 'house2.jpg'));
% [h, w] = size(pic_left);
% matches_left = [matches_loaded(1:2,:); ones(1, length)];
% matches_right = [matches_loaded(3:4,:); ones(1, length)];
% 
% 
[F, e1, e2, x1, x2] = ransac_fundamental(matches_left, matches_right, 1, 100);
l2 = F * x1(:,2);
l1 = F' * x2(:,2);

size(x1)
figure(1); clf;
% left image
subplot(1,2,1); imagesc(pic_left); axis equal; axis tight; hold on;
plot(x1(1,:), x1(2,:), 'bx');
plot(x1(1,1), x1(2,1), 'go');
draw_line(l2, w, h, 'g');

% right image
subplot(1,2,2); imagesc(pic_right); axis equal; axis tight; hold on;
plot(x2(1,:), x2(2,:), 'bx');
plot(x2(1,1), x2(2,1), 'go');
draw_line(-l1, w, h, 'g');

reprojection_error(x1(:,2), x2(:,2),F)