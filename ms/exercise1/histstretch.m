function [ stretched ] = histstretch( image )
    minimum = min(image(:));
    image = bsxfun(@minus, image, minimum);
    maximum = max(image(:));
    mul = 255/maximum;
    stretched = image .* mul;
end

