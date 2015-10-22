function [H, bins] = myhist(I, nbins)
    I = reshape(I, 1, numel(I));
    H = zeros(1, nbins);
    max_val_in = 255;
    min_val_in = 0;
    max_val_out = nbins;
    min_val_out = 1;
    
    f = (max_val_out - min_val_out)/(max_val_in - min_val_in);
    idx = floor(double(I) * f) + min_val_out;
    idx(idx > nbins) = nbins;
    for i = 1 : length(I)
        H(idx(i)) = H(idx(i)) + 1;
    end
    H = H/sum(H);
    bins = ( (1 : nbins) - min_val_out) ./ f;
end