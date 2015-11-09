monitor = imread('monitor.jpg');
video = imread('truck.jpg');
transform = imread('monitor.jpg');
[h, w, ~] = size(video);

x_camera = [360, 512, 497, 348]'; %x_camera = circshift(x_camera, 1);
y_camera = [278, 244, 388, 447]'; %y_camera = circshift(y_camera, 1);
x_view = [1, w, w, 0]';
y_view = [1, 0, h, h]';
x_camera = [516, 360, 346, 494]';
y_camera = [247, 272, 445, 395]';
x_view = [w, 0, 0, w]'; x_view = circshift(x_view, 1);
y_view = [0, 0, h, h]'; y_view = circshift(y_view, 1);

points = [x_view, y_view, ones(4,1)];

xy_camera = [x_camera, y_camera];

figure(1);
subplot(1,2,1); imshow(monitor); hold on;
plot(x_camera, y_camera, 'yo');
plot(x_view, y_view, 'rx');
axis tight; axis equal;
hold off;

H = estimate_homography(y_view, x_view, y_camera, x_camera);
H = abs(H);
points = points * H';
for i = 1:4
    points(i,:) = points(i,:) / points(i,end);
end
subplot(1,2,2); 
imshow(monitor); hold on; hold on;
plot(x_camera, y_camera, 'yo');
plot(points(:,2), points(:,1), 'rx');

axis tight; axis equal;
figure(2); clf;
x_view'
y_view'
round(points)
for i = 1:size(video,1)
    for j = 1:size(video,2)
        tmp_xy = H * [i, j, 1]';
        tt = round(tmp_xy / tmp_xy(end));
        transform(tt(2), tt(1), :) = video(i,j,:);
    end
end

imshow(transform); axis tight; axis equal; hold on;
plot(x_camera, y_camera, 'yo');
plot(tt(1), tt(2), 'rx');