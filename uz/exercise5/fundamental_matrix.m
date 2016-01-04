function [ F, e1, e2 ] = fundamental_matrix( pts_l, pts_r)
    [pts_l, TL] = normalize_points(pts_l);
    [pts_r, TR] = normalize_points(pts_r);
    [~, length] = size(pts_l);
    A = [(pts_l(1,:) .* pts_r(1,:))', (pts_l(1,:) .* pts_r(2,:))', pts_l(1,:)', ...
            (pts_l(2,:) .* pts_r(1,:))', (pts_l(2,:) .* pts_r(2,:))', pts_l(2,:)', ...
                pts_r(1,:)', pts_r(2, :)', ones(length, 1)];

%     for i = 1:length
%         u = pts_r(1, i); v = pts_r(2, i);
%         up = pts_l(1, i); vp = pts_l(2, i);
%         A(i,:) = [u*up, u*vp, u, v*up, v*vp, v, up, vp, 1];
%     end
    [~, ~, V] = svd(A);
    Ft = V(:,9) ./ V(9,9);
    Ft = reshape(Ft, 3, 3);
    [U, D, V] = svd(Ft);
    D(3,3) = 0;
    F = U * D * V';
    F = TR' * F * TL;
    [U, ~, V] = svd(F);
    e1 = V(:,3)./V(3,3);
    e2 = U(:,3)./U(3,3);
end

