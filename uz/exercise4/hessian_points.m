function [px, py] = hessian_points(I, sigma, threshold)
    [Ixx, Iyy, Ixy] = image_derivatives2(I,sigma);
    I_h = sigma^2 * ( Ixx .* Iyy - Ixy.^2 );
%     figure; colormap gray; imagesc(I_h); title(sprintf('sigma %d', sigma));
    I_h = nonmaxima_suppression_box(I_h, threshold);
    [py, px] = find(I_h > threshold);
end