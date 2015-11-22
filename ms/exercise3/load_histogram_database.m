function [histograms, classes, files] = load_histogram_database(directory, bins)
    files = cell(30 * 4, 1);
    histograms = zeros( 30 * 4, bins ^3);
    classes = zeros(30 * 4, 1);
    for i = 1:30
        for j = 1:4
            image_idx = (i - 1) * 4 + j;
            files{image_idx} = fullfile(directory, sprintf('object_%02d_%d.png', i, j));
%             figure(1); clf; imshow(imread(files{image}));
            img = imread(files{image_idx});
            img_hist = myhist3(img, bins);
            histograms(image_idx, :) = img_hist(:);
            classes(image_idx) = i;
        end
    end
end