% video = read_video('bigbuck');
bins = 8;
[h, w, c, frames] = size(video);
histograms = zeros(bins, (3*size(video,2)), size(video,4));
% size(histograms)
for i = 1:frames
    histograms(:,:,i) = generate_histograms(video(:,:,:,i), bins);
end

dists = zeros(size(video,4), 1);

for i = 1:2 % (frames - 1)
    distance(histograms(:,:,i), histograms(:,:,i + 1), 'chi2')
end

imhist(dists);