function [ Ix, Iy ] = image_derivatives( I, sigma )
    G = double(gauss(sigma));
    D = double(gaussdx(sigma));
    Ix = conv2(conv2(double(I), G'), D); % valid
    Iy = conv2(conv2(double(I), D'), G); % valid
    
end

