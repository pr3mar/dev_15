% video = read_video('bigbuck');
bins = 8;
histograms = zeros(bins, (3*size(video,2)), size(video,4));
size(histograms)
for i = 1:size(video,4)
    histograms(:,:,i) = generate_histograms(video(:,:,:,i), bins);
end
