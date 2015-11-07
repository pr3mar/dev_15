% figure(1); clf;
monitor = imread('monitor.jpg');
imshow(monitor);
[x,y] = ginput(4);
x = uint32(x);
y = uint32(y);
polygon = zeros(1, size(x,2) * 2);
j = 1;
for i = 1:size(x)
    polygon(j) = x(i);
    polygon(j + 1) = y(i);
    j = j + 2;
end
figure(2);clf;
subplot(1,2,1); imshow(monitor);
% monitor = insertShape(monitor, 'Line', [x(1),y(1),x(2),y(2)], 'Color','green');
monitor = insertShape(monitor, 'FilledPolygon', polygon, 'Color','green', 'Opacity', 1);
subplot(1,2,2); imshow(monitor);
esitmate_homography(x,y);