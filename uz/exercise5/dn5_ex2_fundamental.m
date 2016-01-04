dir = 'epipolar';
f_left = 'house1.jpg';
f_right = 'house2.jpg';
pic_left = imread(fullfile(dir, f_left));
[hl, wl, ~] = size(pic_left);
pic_right = imread(fullfile(dir, f_right));
[hr, wr, ~] = size(pic_right);

house_dots = load(fullfile(dir, 'house_points.txt'));
dots_left = house_dots(:,1:2)';
dots_right = house_dots(:, 3:4)';

test_left = [85 233 1]';
test_right = [67 219 1]';

f_loaded = load(fullfile(dir, 'house_fundamental.txt'));
l2_loaded = -f_loaded * test_left;
l1_loaded = f_loaded' * test_right;

f = fundamental_matrix(dots_left, dots_right);
l2 = f * test_left;
l1 = -f' * test_right;

figure(1); clf;
% left image
subplot(1,2,1); imagesc(pic_left); axis equal; axis tight; hold on;
plot(dots_left(1,:), dots_left(2,:), 'rx');
plot(test_left(1), test_left(2), 'go');
draw_line(l1_loaded, wl, hl, 'b');
draw_line(l1, wl, hl, 'g');

% right image
subplot(1,2,2); imagesc(pic_right); axis equal; axis tight; hold on;
plot(dots_right(1,:), dots_right(2,:), 'rx');
plot(test_right(1), test_right(2), 'go');
draw_line(l2_loaded, wr, hr, 'b');
draw_line(l2, wr, hr, 'g');

% reprojection error on test points
reprojection_error(test_left, test_right, f_loaded);
error_test = reprojection_error(test_left, test_right, f)

[~, length] = size(dots_left);
error = 0;
for i = 1:length
    [tmp, ~, ~] = reprojection_error([dots_left(:,i); 1], [dots_right(:,i); 1], f);
    error = error + tmp;
end
avg_error = error / length