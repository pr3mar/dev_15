img = rgb2gray(imread('tiger.jpg'));
R = 20;
reduce = reduceLevels(img, 10);
patches = toPatches(reduce, R);

d = [4 4];
features = zeros(size(patches,3),4);
for i = 1:size(patches,3)
    [~,features(i,:)] = getDot(patches(:,:,i), d);
end

% plot3(features(:,1), features(:,2), features(:,4), 'rx'); grid on;
features = [features(:,1), features(:,2), features(:,4)];
[idx, C] = kmeans(features, 2);
figure(1);
plot3(features((idx == 1),1), features((idx == 1),2), features((idx == 1),3), 'r.'); grid on; hold on;
plot3(features((idx == 2),1), features((idx == 2),2), features((idx == 2),3), 'b.'); grid on;
plot3(C(:,1), C(:,2), C(:,3), 'X', 'MarkerSize',20, 'LineWidth',3); hold off;