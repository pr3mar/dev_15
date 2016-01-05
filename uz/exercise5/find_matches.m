function [ indices ] = find_matches( img1, img2, sigma, tsh, bins, m, detector)
    if nargin < 7
        detector = 'hessian';
    end
    switch detector
        case 'hessian'
            [px1, py1] = hessian_points(img1, sigma, tsh);
            [px2, py2] = hessian_points(img2, sigma, tsh);
        case 'harris'
            [px1, py1] = harris_points(img1, sigma, tsh);
            [px2, py2] = harris_points(img2, sigma, tsh);
        otherwise
            error('unkown type');
    end
    D1 = descriptors_maglap(img1, px1, py1, m, sigma, bins);
    D2 = descriptors_maglap(img2, px2, py2, m, sigma, bins);
    [indices1, dist1] = find_correspondences(D1, D2);
    [indices2, dist2] = find_correspondences(D2, D1);
%     [~, ind1] = sort(dist1); indices1 = indices1(ind1);
%     [~, ind2] = sort(dist1); indices1 = indices1(ind2);
    
    indices = zeros(min(size(indices1,1),size(indices2,1)), 5);
    indices(:,5) = 100000;
    count = 1;
    for i = 1:numel(indices1)
        for j = 1:numel(indices2)
%             [i indices1(i) j indices2(j)]
%             if(ind1(i) == indices2(j)) && (ind2(j) == indices1(i))
            if(i == indices2(j)) && (j == indices1(i))
                indices(count,:) = [px1(i), py1(i), px2(j), py2(j), dist1(i)];
                count = count + 1;
            end
        end
    end
    
end

