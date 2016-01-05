% triangulation

dir = 'epipolar';
house = load(fullfile(dir, 'house_points.txt'));
pic1 = imread(fullfile(dir, 'house1.jpg'));
pic2 = imread(fullfile(dir, 'house2.jpg'));
camera1 = load(fullfile(dir, 'house1_camera.txt'));
camera2 = load(fullfile(dir, 'house2_camera.txt'));
[len, ~] = size(house);

pts_1 = [house(:,1:2)'; ones(1, len)];
pts_2 = [house(:,3:4)'; ones(1, len)];

X = triangulate(pts_1, pts_2, camera1, camera2);

figure(1); clf;
subplot(1,3,1);
imagesc(pic1); axis equal; axis tight; hold on;
plot(pts_1(1,:), pts_1(2,:),'r.');
for i = 1 : len
   text(pts_1(1,i), pts_1(2,i), num2str(i)) ;
end;
hold off;
subplot(1,3,2);
imagesc(pic2); axis equal; axis tight; hold on;
plot(pts_2(1,:), pts_2(2,:),'r.');
for i = 1 : len
   text(pts_2(1,i), pts_2(2,i), num2str(i)) ;
end;
hold off;
subplot(1,3,3);
show_triangulation(X);