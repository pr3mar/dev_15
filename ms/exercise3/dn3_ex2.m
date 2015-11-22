[histograms, classes, files] = load_histogram_database('images',8);
id_selected = 5;
selected = histograms(id_selected,:);
% bar(histograms(5,:));
% imagesc(imread(char(files(5))))
distances = zeros(size(histograms,1),1);
for i = 1:size(histograms,1)
    distances(i) = distance(selected, histograms(i,:), 'h');
end

[~, idx] = sort(distances, 'descend');
figure(1); clf;
subplot(1,11,1); 
imagesc(imread(char(files(id_selected))));
axis tight; axis equal;
for i = 2:11
    subplot(1,11,i); 
    imagesc(imread(char(files(idx(i))))); 
    axis tight; axis equal;
end

selected = rgb2gray(imread(char(files(id_selected))));
for i = 1:size(files,1)
    tmp = rgb2gray(imread(char(files(i))));
    distances(i) = distance(double(selected(:)), double(tmp(:)), 'ncc');
end

[sorted, idx] = sort(distances, 'descend');
figure(2); clf;
subplot(1,11,1); 
imagesc(imread(char(files(id_selected))));
axis tight; axis equal;
for i = 2:11
    subplot(1,11,i); 
    imagesc(imread(char(files(idx(i))))); 
    axis tight; axis equal;
end