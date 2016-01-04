function [ x1in, x2in ] = get_inliers( F, x1, x2, eps)
    [~, length] = size(x1);
    vals = zeros(length, 1);
    for i = 1:length
%         vals =  what do?
    end
    inliers = vals < eps;
    x1in = x1(:, inliers);
    x2in = x2(:, inliers);
end
