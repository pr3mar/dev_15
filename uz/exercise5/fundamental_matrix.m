function [ F, e1, e2 ] = fundamental_matrix( pts_l, pts_r)
    [length, ~] = size(pts_l);
    A = zeros(length, 9);
    %     size(pts_l), size(pts_r), size(A)
    for i = 1:length
        u = pts_l(i,1); v = pts_l(i,2);
        up = pts_r(i,1); vp = pts_r(i,2);
        A(i, :) = [u * up, u * vp, u, v * up, v * vp, v, up, vp, 1];
    end
    
    [~, ~, V] = svd(A);
    Ft = reshape(V(:,end), 3, 3)';
    [U, D, V] = svd(Ft);
    D(3,3) = 0;
    F = U * D * V;
    [U, ~, V] = svd(F);
    e1 = V(:,3) ./ V(3,3);
    e2 = U(:,3) ./ U(3,3);
end

