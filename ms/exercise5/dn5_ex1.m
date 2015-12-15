video = read_video('bigbuck');
% view the video
vf = figure(1);
for i = 1:frames
    set(0, 'CurrentFigure', vf);
    imshow(video(:,:,:,i));
    pause(0.005);
end

bins = 8;
% [h, w, c, frames] = size(video);
histograms = zeros(bins, (3*size(video,2)), size(video,4));
% size(histograms)
for i = 1:frames
    histograms(:,:,i) = generate_histograms(video(:,:,:,i), bins);
end

dists = zeros(size(video,4), 1);
dist_type = 'hellinger';
for i = 1:(frames - 1)
    dists(i) = distance(histograms(:,:,i), histograms(:,:,i + 1), dist_type);
end

figure(1); plot(dists); title(sprintf('distance = ''%s'', bins = %d', dist_type, bins));

[max_val, max_ind] = max(dists);
tsh = max_val * 0.3;
[results] = find(dists > tsh);
count = 1;
for i = 1:numel(results)
    start = (results(i) - 2);
    finish = (results(i) + 2);
    for j = start:finish
         subplot(numel(results), 5, count); imshow(video(:,:,:,j));
        count = count + 1;
    end
end
