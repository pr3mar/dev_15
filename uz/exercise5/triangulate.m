function [ X ] = triangulate( pts_1, pts_2, P_1, P_2)
    X = [];
    [~, len] = size(pts_1);
    for i = 1:len
        a1 = cross_form(pts_1(:,i));
        a2 = cross_form(pts_2(:,i));
        c1 = a1 * P_1;
        c2 = a2 * P_2;
        A = [c1(1:2,:); c2(1:2,:)];
        [U, D, V] = svd(A);
        x = V(:,end) ./ V(end, end);
        X = [X x];
    end
end

