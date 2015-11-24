function [ pyramid ] = gauss_pyramid( img, sigma, level )
    pyramid = cell(level, 1);
    filter = gauss(sigma);
    pyramid{1} = double(img);
    for i = 2:level
        pyramid{i} = conv2(conv2(pyramid{i-1}, filter, 'same'), filter', 'same');
    end
end

