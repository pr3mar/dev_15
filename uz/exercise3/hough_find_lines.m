function [ out_rho, out_theta ] = hough_find_lines...
    ( Ie, bins_rho, bins_theta, threshold )
    
    D = lenght(diag(Ie));
    acc = zeros(bins_rho, bins_theta);
    
end

