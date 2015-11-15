function [ gauss_dx ] = gaussdx( sigma )
    x = -round(3.0 * sigma) : round(3.0 * sigma);
    gauss_dx = -1/(sqrt(2 * pi) * sigma ^ 3) * x .* exp(-x.^2 / (2 * sigma^2));
    gauss_dx = gauss_dx / sum(abs(gauss_dx)); % normalization
end

