function [ dist_mat ] = dist_matrix( histograms, dist_type)
    if nargin < 2
        dist_type = 'hellinger';
    end
    [h, w, frames] = size(histograms);
    dist_mat = zeros(frames);
    for i = 1:frames
        for j = 1:frames
            if(j > i)
                break;
            end
            tmp = distance(histograms(:,:,i), histograms(:,:,j), dist_type);
            dist_mat(i,j) = tmp; dist_mat(j,i) = tmp;
        end
    end
end

