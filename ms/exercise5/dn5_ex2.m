% video = read_video('sintel');
bins = 8;
% hsv_video = video_to_hsv(video);
% histograms = generate_histograms(hsv_video, bins);
dist_type = 'chi2';
dist_mat = dist_matrix(histograms);
figure(1); clf; imagesc(dist_mat); title(dist_type); colormap jet;