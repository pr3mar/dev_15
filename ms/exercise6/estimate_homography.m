function H = estimate_homography(px1,py1,px2,py2)
    % H = ESTIMATE_HOMOGRAPHY (px1, py1, px2, py2)
    %
    % Computes homography between two sets of corresponding points.
    %
    % Input:
    %  - px1, py1: vectors of x and y coordinates of the first point set
    %  - px2, py2: vectors of x and y coordinates of the second point set
    %
    % Output:
    %  - H: estimated homography

    n = length(px1);

    % Build up the matrix A
    A = zeros(2*n, 9);
    for i = 1:n,
        A(2*i-1,:) = [ px1(i), py1(i), 1, 0, 0, 0, -px2(i)*px1(i), -px2(i)*py1(i), -px2(i) ];
        A(2*i,:)   = [ 0, 0, 0, px1(i), py1(i), 1, -py2(i)*px1(i), -py1(i)*py2(i), -py2(i) ];
    end
    
    % Decompose A using SVD
    [ ~, ~, V ] = svd(A);

    % Compute h as the normalized smallest eigenvector
    h = V(:,9) ./ V(9,9);

    % reshape to form a matrix
    H = reshape(h, 3, 3)';
end
