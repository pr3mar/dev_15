function [ x1in, x2in ] = get_inliers( F, x1, x2, eps)
    [~, length] = size(x1);
    indices = false(length, 1);
    for i = 1:length
        [~, d1, d2] = reprojection_error(x1(:,i), x2(:,i), F);
        if (d1 < eps) && (d2 < eps)
            indices(i) = true;
        end
    end
    x1in = x1(:, indices);
    x2in = x2(:, indices);
end
