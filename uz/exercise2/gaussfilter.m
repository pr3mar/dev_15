function [result] = gaussfilter(img, sigma)
    kernel = gauss(sigma);
    result = conv2(img, kernel, 'same');
    result = conv2(result, kernel', 'same');
end