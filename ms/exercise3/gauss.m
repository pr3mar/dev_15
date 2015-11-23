function [g, x] = gauss(sigma)
x = -round(3.0*sigma):round(3.0*sigma);
g = exp(-x .^ 2 / (2 * sigma ^ 2));
g = g / sum(g);
end
