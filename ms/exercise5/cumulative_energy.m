function [ cum_en ] = cumulative_energy( energy )
    [h, w] = size(energy);
    cum_en = zeros(h, w);
    cum_en(:, 1) = energy(:,1);
    for i = 2:h
        for j = 1:w
            if( j - 1 <= 1)
                cum_en(i,j) = energy(i,j) + min([cum_en(i - 1,j), cum_en(i - 1,j + 1)]);
            elseif ( j + 1 > w)
                cum_en(i,j) = energy(i,j) + min([cum_en(i - 1,j - 1), cum_en(i - 1,j)]);                    
            else
                cum_en(i,j) = energy(i,j) + min([cum_en(i - 1,j - 1), cum_en(i - 1,j), cum_en(i - 1,j + 1)]);
            end
        end
    end    
end

