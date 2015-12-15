video = read_video('sintel');
[h, w, c, frames] = size(video);
bins = 8;
hsv_video = video_to_hsv(video);
histograms = generate_histograms(hsv_video, bins);
dist_type = 'chi2';
dist_mat = dist_matrix(histograms, dist_type);
figure(1); clf; imagesc(dist_mat); title(dist_type); colormap jet;

clusters = apcluster(dist_mat, min(dist_mat(:)));

uni = unique(clusters);
n_uni = numel(uni);
h_plot = 2;
w_sub = ceil(n_uni/h_plot);

h_thumb = 40;
w_thumb = 60;
thumbs = zeros(h_thumb, w_thumb, 3,n_uni);

figure(2); clf;
for i = 1:n_uni
    subplot(h_plot,w_sub,i);
    thumbs(:,:,:,i) = imresize(video(:,:,:,uni(i)), [h_thumb, w_thumb], 'bilinear');
    imshow(video(:,:,:,uni(i))); title(sprintf('%.0f', uni(i)));
end

map = containers.Map(uni, 1:n_uni);

for i = 1:frames
     video(1:h_thumb,1:w_thumb,:,i) = thumbs(:,:,:,map(clusters(i)));
end

% view the video
vf = figure(1);
mask = '%08d.jpg';
directory = 'sintel_thumb';
for i = 1:frames
    set(0, 'CurrentFigure', vf);
    imshow(video(:,:,:,i));
%     imwrite(video(:,:,:,i),fullfile(directory, sprintf(mask, i)));
    pause(0.005);
end