% read images
monitor = imread('monitor.jpg');
truck = imread('truck.jpg');
transform_truck = imread('monitor.jpg');

% get the height/width
[h, w, ~] = size(truck);

% get the input from the user (counter clockwise)
imshow(monitor);
[x_camera, y_camera] = ginput(4);
close(1);

% preprogrammed input for testing purposes
% x_camera = [359, 515, 493, 346]';
% y_camera = [272, 242, 394, 446]';

% homography calculating coordinates
x_view = [1, w, w, 1]';
y_view = [1, 1, h, h]';

%estimate homography
H = estimate_homography(x_view, y_view, x_camera, y_camera);
% points = [x_view, y_view, ones(4,1)];
% % display the preliminary dots
% figure(1);
% subplot(1,2,1); imshow(monitor); hold on;
% plot(x_camera, y_camera, 'yo');
% plot(x_view, y_view, 'rx');
% axis tight; axis equal;
% hold off;
% 
% % apply homography
% points = H * points';
% % normalize the dots
% for i = 1:3
%     points(:,i) = points(:,i) / points(end,i);
% end
% 
% % display the calculated dot
% subplot(1,2,2); 
% imshow(monitor); hold on; hold on;
% plot(x_camera, y_camera, 'yo');
% plot(points(1,:), points(2,:), 'rx');
% axis tight; axis equal;

% insert the truck picture into the monitor picture
% meshgrid!!!
for i = 1:size(truck, 1)
    for j = 1:size(truck, 2)
        tmp_xy = [j, i, 1] * H';
        tt = round(tmp_xy / tmp_xy(end));
        transform_truck(tt(2), tt(1), :) = truck(i,j,:);
    end
end
% show the image
figure(2); clf;
imshow(transform_truck); axis tight; axis equal; hold on;
plot(x_camera, y_camera, 'yo');

% load the video
video = read_video('bigbuck');
transform_video = zeros(size(monitor));
[h, w, ~] = size(video);
x_view = [1, w, w, 1]';
y_view = [1, 1, h, h]';
H = estimate_homography(x_view, y_view, x_camera, y_camera);
% transform the video
for frame = 1:size(video,4)
    transform_video = monitor(:,:,:);
    for i = 1:size(video, 1)
        for j = 1:size(video, 2)
            tmp_xy = [j, i, 1] * H';
            tt = round(tmp_xy / tmp_xy(end));
            transform_video(tt(2), tt(1), :) = video(i,j,:, frame);
        end
    end
    %figure; imshow(transform_video);
    imwrite(transform_video, fullfile('bigbuck_monitor', sprintf('%08d.jpg', frame)));
end