% % RANSAC implementation.
% dir = 'epipolar';
% % matches_loaded = load(fullfile(dir, 'house_matches.txt'))';
% sigma = 3; tsh = 50; bins = 50; m = 50;
% pic_left = rgb2gray(imread(fullfile(dir, 'library1.jpg')));
% pic_right = rgb2gray(imread(fullfile(dir, 'library2.jpg')));
% camera1 = load(fullfile(dir, 'library1_camera.txt'));
% camera2 = load(fullfile(dir, 'library2_camera.txt'));
% matches_loaded = find_matches(pic_left, pic_right, sigma, tsh, bins, m)';
% zeros_ = all(matches_loaded(1:4, :) == 0);
% matches_loaded = matches_loaded(:, ~zeros_);
% [~, length] = size(matches_loaded);
% [h, w, ~] = size(pic_left);
% matches_left = [matches_loaded(1:2,:); ones(1, length)];
% matches_right = [matches_loaded(3:4,:); ones(1, length)];
% 
% 
[F, e1, e2, x1, x2] = ransac_fundamental(matches_left, matches_right, 5, 100);
line_index = randperm(size(x1,2) - 10,1)
l2 = F * x1(:,line_index);
l1 = F' * x2(:,line_index);

[~, length] = size(matches_left);
error = 0;
errs = zeros(length,1);
for i = 1:length
    [tmp, ~, ~] = reprojection_error(matches_left(:,i), matches_right(:,i), F);
    errs(i) = tmp;
    error = error + tmp;
end
inliers = size(x1,2)/length;
avg_error = error / length;

figure(1); clf;
[~,len] = size(x1);
% left image
subplot(1,3,1); imagesc(pic_left); axis equal; axis tight; hold on; colormap gray;
plot(matches_left(1,:), matches_left(2,:), 'rx');
plot(x1(1,:), x1(2,:), 'bx');
plot(x1(1,line_index), x1(2,line_index), 'go');
draw_line(-l2, w, h, 'g');
title(sprintf('error(global) = %.2f', avg_error));
for i = 1 : len
   text(x2(1,i), x2(2,i), num2str(i)) ;
end;

% right image 
subplot(1,3,2); imagesc(pic_right); axis equal; axis tight; hold on; colormap gray;
plot(matches_right(1,:), matches_right(2,:), 'rx');
plot(x2(1,:), x2(2,:), 'bx');
plot(x2(1,line_index), x2(2,line_index), 'go');
draw_line(l1, w, h, 'g');
title(sprintf('inliers= %.2f %%\n error = %.2f', (inliers * 100), reprojection_error(x1(:,line_index), x2(:,line_index),F)));
for i = 1 : len
   text(x2(1,i), x2(2,i), num2str(i)) ;
end;

X = triangulate(x1, x2, camera1, camera2);

subplot(1,3,3);
show_triangulation(X);