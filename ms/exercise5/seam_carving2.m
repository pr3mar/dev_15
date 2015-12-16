function [ resized ] = seam_carving2( img, w_resize, h_resize )
    [img_x, img_y] = image_derivatives(img, 1);
    img_energy = abs(img_x) + abs(img_y);
    for i = 1:w_resize
        cumulative = cumulative_energy(img_energy);
        s = seam(cumulative)';
        img = cut_col(img, s);
        img_energy = cut_col(img_energy, s);
    end
    
    for i = 1:h_resize
        cumulative = cumulative_energy(img_energy);
        s = seam(cumulative')';
        img = cut_row(img, s);
        img_energy = cut_row(img_energy, s);
    end
    
    resized = img;
end