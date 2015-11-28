function [ Ixx, Iyy, Ixy ] = image_derivatives2( I, sigma )
    G = double(gauss(sigma));
    D = double(gaussdx(sigma));
    [Ix, Iy] = image_derivatives(I,sigma);
    Ixx = conv2(conv2(double(Ix), G'), D);
    Iyy = conv2(conv2(double(Iy), D'), G);
%     Ixy = conv2(conv2(double(I), D), D');

    Ixx = Ixx((1 + sigma*3):(end-sigma*3), (1 + sigma*3):(end-sigma*3));
    Iyy = Iyy((1 + sigma*3):(end-sigma*3), (1 + sigma*3):(end-sigma*3));
    Ixy = Ix + Iy;
end

