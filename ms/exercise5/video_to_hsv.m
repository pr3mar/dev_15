function [ converted ] = video_to_hsv( video )
    [h, w, c, frames] = size(video);
    converted = zeros(h, w, c, frames);
    for i = 1:frames
        converted(:,:,:,i) = rgb2hsv(video(:,:,:,i));
    end
end

