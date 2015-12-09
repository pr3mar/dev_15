function [Ix, Iy] = image_derivatives(I, sigma)
% Get image derivatives

if size(I, 3) ~= 1
    error('Only grayscale image accepted');
end;

I = double(I);

% Compute gaussian kernel
x = -round(3.0*sigma):round(3.0*sigma);
G = exp(-x .^ 2 / (2 * sigma ^ 2));
G = G / sum(G);

% Compute gaussian derivative kernel
x = -round(3.0 * sigma):round(3.0 * sigma);
D = -2 * (x .* exp(-x.^2/(2 * sigma ^ 2))) / (sqrt(2 * pi) * sigma ^ 3);
D = D / (sum(abs(D)) / 2) ;

% Compute image deriviatives
Ix= conv2(conv2(I, D, 'same'), G', 'same');
Iy= conv2(conv2(I, G, 'same'), D', 'same');

