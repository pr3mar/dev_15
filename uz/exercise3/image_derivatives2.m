function [ Ixx, Iyy, Ixy ] = image_derivatives( I, sigma )
    G = double(gauss(sigma));
    D = double(gaussdx(sigma));
    [Ix, Iy] = image_derivatives(I,sigma);
    Ixx = conv2(conv2(double(Ix), G'), D);
    Iyy = conv2(conv2(double(Iy), D'), G);
    Ixy = conv2(conv2(double(I), D), D');
end

