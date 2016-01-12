function [ U, Mu ] = dual_pca( P )
    Mu = mean(P, 2);
    [m, N] = size(P);
    Pn = double(bsxfun(@minus, P, Mu));
    
    C = (1/(m-1)) * ((Pn') * Pn);
    [U, S, V] = svd(C);
    S = diag(S) + 1e-15;
    S = diag(1 ./ (S)); % (m - 1) * factor makes a difference
    U = double(Pn) * double(U) * sqrt(S);
end

