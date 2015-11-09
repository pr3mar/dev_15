monitor = imread('monitor.jpg');
video = imread('truck.jpg');
transform = imread('monitor.jpg');
[h, w, ~] = size(video);
monitor = imread('monitor.jpg');
imshow(monitor);
[x_camera, y_camera] = ginput(4);
close(1);
% x_camera = [359, 515, 493, 346]';
% y_camera = [272, 242, 394, 446]';
x_view = [1, w, w, 1]';
y_view = [1, 1, h, h]';

points = [x_view, y_view, ones(4,1)];

xy_camera = [x_camera, y_camera];

figure(1);
subplot(1,2,1); imshow(monitor); hold on;
plot(x_camera, y_camera, 'yo');
plot(x_view, y_view, 'rx');
axis tight; axis equal;
hold off;

H = estimate_homography(x_view, y_view, x_camera, y_camera);
% H = abs(H);
points = H * points';
for i = 1:3
    points(:,i) = points(:,i) / points(end,i);
end
subplot(1,2,2); 
imshow(monitor); hold on; hold on;
plot(x_camera, y_camera, 'yo');
plot(points(1,:), points(2,:), 'rx');

axis tight; axis equal;
figure(2); clf;
round(points)
for i = 1:size(video,1)
    for j = 1:size(video,2)
        tmp_xy = H * [j, i, 1]';
        tt = round(tmp_xy / tmp_xy(end));
        transform(tt(2), tt(1), :) = video(i,j,:);
    end
end

imshow(transform); axis tight; axis equal; hold on;
plot(x_camera, y_camera, 'yo');