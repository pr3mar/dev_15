function [ Ie ] = findEdges( I, sigma, theta )
    [Imag, Ideg] = gradient_magnitude(I, sigma);
    Imax = nonmaxima_suppression_line(Imag, Ideg);
    Ie = Imax > theta;
    %velikost jedra 3*sigma + xx...
    Ie(:,1:floor(4*sigma)) = 0;
    Ie(:,(end - floor(4*sigma)):end) = 0;
    Ie(1:floor(4*sigma),:) = 0;
    Ie((end - floor(4*sigma)):end,:) = 0;
end

