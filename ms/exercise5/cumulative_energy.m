function [ cum_en ] = cumulative_energy( energy )
    [h, w] = size(energy);
    cum_en = zeros(h, w);
    cum_en(:, 1) = energy(:,1);
    for i = 2:h
        for j = 2:(w - 1)
            cum_en(i,j) = energy(i,j) + min([cum_en(i - 1,j - 1), cum_en(i - 1,j), cum_en(i - 1,j + 1)]);
        end
    end
    
end

