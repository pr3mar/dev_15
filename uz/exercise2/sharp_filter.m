function [sharpened] = sharp_filter(img)
    filter = zeros(3);
    filter(2,2) = 2;
    filter = filter - 1/9 .* ones(3);
    sharpened = conv2(img, filter, 'same');
    sharpened = conv2(sharpened, filter', 'same');
end