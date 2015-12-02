function [ H ] = estimate_homography( px1, py1, px2, py2)
    H = zeros(2*numel(px1), 9);
    for i = 1:numel(px1)
        H(2*i - 1, :) = [px1(i), py1(i), 1, 0, 0, 0, -px2(i) * px1(i), -px2(i) * py1(i), -px2(i)];
        H(2*i, :) = [0, 0, 0, px1(i), py1(i), 1, -py2(i) * px1(i), -py2(i) * py1(i), -py2(i)];
    end
    [U, D, V] = svd(H);
    H = V(:,end) ./ V(end, end);
    H = reshape(H, 3, 3)';
end

