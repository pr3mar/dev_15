function [ histograms ] = generate_histograms( video, bins )
    [~, w, ~, frames] = size(video);
    histograms = zeros(bins, (3 * w), frames);
    for i = 1:frames
        histograms(:,:,i) = pair_histogram(video(:,:,:,i), bins);
    end

end

