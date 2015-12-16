function [ resized ] = seam_carving( img, w_resize )
    [img_x, img_y] = image_derivatives(img, 1);
    img_energy = abs(img_x) + abs(img_y);
    for i = 1:w_resize
        cumulative = cumulative_energy(img_energy);
        s = seam(cumulative)';
        img = cut_col(img, s);
        img_energy = cut_col(img_energy, s);
%         figure; imagesc(img);
%         figure; imagesc(img_energy);
    end
    resized = img;
end