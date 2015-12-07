function [ px, py ] = harris_points( I, sigma, tsh)
    alpha = 0.06; sigma_t = 1.6 * sigma;
    [Ix, Iy] = image_derivatives(I, sigma); Ixy = Ix .* Iy;
    Ix = Ix .^ 2; Iy = Iy .^ 2;
    G = gauss(sigma_t);
    Igx = conv2(Ix, G, 'same'); Igy = conv2(Iy, G, 'same'); Igxy = conv2(Ixy, G, 'same');
    figure(24); clf; colormap gray;  
%     subplot(1,3,1); imshow(Igx);
%     subplot(1,3,2); imshow(Igy);
%     subplot(1,3,3); imshow(Igxy);
    tmp = Igx .* Igy - Igxy - alpha * ( Igx + Igy ).^2;
    tmp = nonmaxima_suppression_box(tmp, tsh, sigma);
    imagesc(tmp);
    [py, px] = find(tmp > tsh);
end
