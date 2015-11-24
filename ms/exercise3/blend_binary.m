function [ blended ] = blend_binary( img1, img2, mask )
    [coord_x, coord_y] = find(mask > 0);
    blended = img1;
    for i = 1:numel(coord_y)
        blended(coord_x(i),coord_y(i), :) = img2(coord_x(i),coord_y(i), :);
    end
end

