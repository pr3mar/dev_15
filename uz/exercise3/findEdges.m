function [ Ie ] = findEdges( I, sigma, theta )
    [Imag, Ideg] = gradient_magnitude(I, sigma);
    Imax = nonmaxima_suppression_line(Imag, Ideg);
    Ie = Imax > theta;
    %velikost jedra 3*sigma + xx...
end

