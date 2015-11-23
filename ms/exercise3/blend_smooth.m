function [ blended ] = blend_smooth( img1, img2, mask, sigma )
    img1 = double(img1); img2 = double(img2);
    mask = imgaussfilt(mask, sigma);
    mask = double(mask) / double(max(mask(:)));
%     figure(2); imagesc(mask);   
    [coord_x, coord_y] = find(mask ~= 0);
    blended = img1;
    for i = 3:numel(coord_y)
        intensity = mask(coord_x(i),coord_y(i));
        blended(coord_x(i),coord_y(i), :) = intensity * img2(coord_x(i),coord_y(i), :)  + ...
            (1 - intensity) * img1(coord_x(i),coord_y(i), :);
    end
    blended = uint8(blended);
end

