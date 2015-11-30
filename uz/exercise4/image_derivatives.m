function [ Ix, Iy ] = image_derivatives( I, sigma )
    G = double(gauss(sigma));
    D = double(gaussdx(sigma));
    Ix = conv2(conv2(double(I), G', 'same'), D, 'same'); % valid
    Iy = conv2(conv2(double(I), D', 'same'), G, 'same'); % valid
    
%     Ix = Ix((1 + sigma*3):(end-sigma*3), (1 + sigma*3):(end-sigma*3));
%     Iy = Iy((1 + sigma*3):(end-sigma*3), (1 + sigma*3):(end-sigma*3));
end

