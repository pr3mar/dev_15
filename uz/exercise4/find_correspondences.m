function [ indices, distances ] =  find_correspondences( D1, D2 )
    distances = zeros(size(D1, 1), 1); indices = zeros(size(D1,1), 1);
    for i = 1:size(D1, 1)
        min = flintmax;
        maxIdx = -1;
        for j = 1:size(D2, 1)
            dist = distance(D1(i,:), D2(j,:), 'h');
            if(min > dist)
                min = dist;
                maxIdx = j;
            end
        end
        indices(i) = maxIdx;
        distances(i) = min;
    end
end

