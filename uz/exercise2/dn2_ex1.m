% (a, b) 
umbrellas = imread('umbrellas.jpg');
hist3 = myhist3(umbrellas, 8);
figure(1); clf; 
subplot(1,3,1); bar3(hist3(:,:,1));
subplot(1,3,2); bar3(hist3(:,:,2));
subplot(1,3,3); bar3(hist3(:,:,3));


% (d, e)
o1 = imread('images/object_01_1.png');
o2 = imread('images/object_02_1.png');
o3 = imread('images/object_03_1.png');

figure(2); clf; 
o1_ = myhist3(o1,8); o2_ = myhist3(o2,8); o3_ = myhist3(o3,8);
cmp1 = compare_histograms(o1_(:),o1_(:),'l2'); 
cmp2 = compare_histograms(o1_(:),o2_(:),'l2');
cmp3 = compare_histograms(o1_(:),o3_(:),'l2');

subplot(2,3,1); imshow(o1); subplot(2,3,4); bar(o1_(:)); title(cmp1);
subplot(2,3,2); imshow(o2); subplot(2,3,5); bar(o2_(:)); title(cmp2);
subplot(2,3,3); imshow(o3); subplot(2,3,6); bar(o3_(:)); title(cmp3);

% (f)
results = zeros(30 * 4, 2);
[histograms, files] = load_histogram_database('images', 8);
for i = 1:size(histograms,1)
    results(i, 1) = compare_histograms(histograms(20,:), histograms(i,:), 'l2'); 
    results(i, 2) = double(i);
end
figure(3); clf;
plot(results(:,1)); hold on
[sorted, idx] = sortrows(results, 1);
plot(results(idx(1:5),2), results(idx(1:5),1), 'o'); hold off
figure(4); clf
plot(sorted(:,1));  hold on
plot(sorted(1:5), 'o'); hold off
figure(5); clf;
for i = 1:6
    subplot(2,6,i); imshow(imread(char(files(sorted(i,2)))));axis tight; axis equal; %title(char(files(results(i,2))));
    subplot(2,6,i + 6);bar(histograms(sorted(i,2),:)); title(sprintf('%.4f', results(i,1)))
end