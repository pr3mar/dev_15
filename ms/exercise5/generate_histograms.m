function [ histogram ] = generate_histograms( I, bins )
    red = hist(double(I(:,:,1)), bins);
    green = hist(double(I(:,:,2)), bins);
    blue = hist(double(I(:,:,3)), bins);
    histogram = [red green blue];
end

