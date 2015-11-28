function [I_h] = hessian_points(I, sigma, threshold)
    [Ixx, Iyy, Ixy] = image_derivatives2(I,sigma);
    I_h = sigma^4 * ( Ixx .* Iyy - Ixy.^2 );
    I_hh = zeros(size(I_h,1), size(I_h,2));
    [yy,xx] = find(I_h > threshold);
    I_hh(yy, xx) = I_h(yy,xx);
    I_h = nonmaxima_suppression_box(I_hh, threshold);
%     [py, px] = find(I_h > threshold);
end