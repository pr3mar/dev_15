function [ stretched ] = histstrech_hsv( image_hsv )
    stretched = image_hsv;
    for i = 1:3
        minimum = min(min(stretched(:,:,i)));
        stretched(:,:,i) = bsxfun(@minus, stretched(:,:,i), minimum);
        maximum = max(max(stretched(:,:,i)));
        mul = 1/maximum;
        stretched(:,:,i) = stretched(:,:,i) .* mul;
    end
end

