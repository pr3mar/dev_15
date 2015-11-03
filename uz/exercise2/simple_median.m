function filtered = simple_median(I, W)
    filtered = zeros(1,length(I));
    offset = (W - 1) / 2;
    for i = W - offset:length(I) - offset
        tmp = sort(I(i - offset: i + offset));
        filtered(i) = tmp((length(tmp) - 1)/2);
    end
end