img = rgb2gray(imread('fish.jpg'));
R = 10;
reduce = reduceLevels(img, 10);
patches = toPatches(reduce, R);

d = [5 5];
features = zeros(size(patches,3),4);
for i = 1:size(patches,3)
    [~,features(i,:)] = getDot(patches(:,:,i), d);
end
% plot3(features(:,1), features(:,2), features(:,4), 'rx'); grid on;
features = [(features(:,1) - mean(features(:,1))) / std(features(:,1)),...
            (features(:,2) - mean(features(:,2))) / std(features(:,2)),...
            (features(:,3) - mean(features(:,3))) / std(features(:,3)),...
            (features(:,4) - mean(features(:,4))) / std(features(:,4))];
% figure(1); 
% subplot(1,4,1); energy = reshape(features(:,1),R, R); imagesc(energy); colormap gray; title('energy'); axis equal; axis tight;
% subplot(1,4,2); contrast = reshape(features(:,2),R, R); imagesc(contrast); colormap gray; title('contrast'); axis equal; axis tight;
% subplot(1,4,3); correlation = reshape(features(:,3),R, R); imagesc(correlation); colormap gray; title('correlation'); axis equal; axis tight;
% subplot(1,4,4); homogeneity = reshape(features(:,4),R, R); imagesc(homogeneity); colormap gray; title('homogeneity');axis equal; axis tight;

features = [features(:,2), features(:,4)];

[idx, C] = kmeans(features, 2);
% figure(5);
% plot3(features((idx == 1),1), features((idx == 1),2), features((idx == 1),3), 'r.'); grid on; hold on;
% plot3(features((idx == 2),1), features((idx == 2),2), features((idx == 2),3), 'b.');
% plot3(C(:,1), C(:,2), C(:,3), 'gX', 'MarkerSize',20, 'LineWidth',3); hold off;

label = reshape(idx, R, R);
[a, b] = hist(idx, unique(idx))
if a(1) > a(2)
    label = label == b(2);
else
    label = label == b(1);
end

figure(6); imagesc(label);
label = bwlabel(label);
[a, b] = hist(idx, unique(label));
[~, idx] = max(a);
label = label == b(idx);
label = imgaussfilt(double(label));
mask = imresize(label, [size(img,1), size(img,2)], 'bilinear');
masked = immask(img, mask);
imagesc(masked); colormap gray;


