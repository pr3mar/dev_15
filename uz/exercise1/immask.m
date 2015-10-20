function masked = immask(image, mask)
    red = image(:,:,1) .* uint8(mask);
    green = image(:,:,2) .* uint8(mask);
    blue = image(:,:,3) .* uint8(mask);
    masked = cat(3, red, green, blue);
end
