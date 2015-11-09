figure(1); clf;
monitor = imread('monitor.jpg');
imshow(monitor);
[x_camera,y_camera] = ginput(4);
close(1);
x_camera = uint32(x_camera);
y_camera = uint32(y_camera);
polygon = zeros(1, size(x_camera,2) * 2);
j = 1;
for i = 1:size(x_camera)
    polygon(j) = x_camera(i);
    polygon(j + 1) = y_camera(i);
    j = j + 2;
end
figure(2);clf;
subplot(1,2,1); imshow(monitor);
% monitor = insertShape(monitor, 'Line', [x(1),y(1),x(2),y(2)], 'Color','green');
monitor = insertShape(monitor, 'FilledPolygon', polygon, 'Color','green', 'Opacity', 1);
subplot(1,2,2); imshow(monitor);
[w, h] = size(monitor(:,:,:,1));
x_video = double([0, w, w, 0]);
y_video = double([0, 0, h, h]);
H = estimate_homography(double(x_camera), double(y_camera), x_video, y_video)
tocka = [x_video(1), y_video(1), 1]
H * tocka'