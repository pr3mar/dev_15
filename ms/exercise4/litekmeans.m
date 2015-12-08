function label = litekmeans(X, k)
    % Perform k-means clustering.
    %   X: n x d data matrix
    %   k: number of seeds
    %   label: n x 1 matrix of class correspondance indexes
    % Written by Michael Chen (sth4nth@gmail.com).
    X = X' ;
    n = size(X,2);
    last = 0;
    label = ceil(k*rand(1,n));  % random initialization
    while any(label ~= last)
        E = sparse(1:n,label,1,n,k,n);  % transform label into indicator matrix
        m = X*(E*spdiags(1./sum(E,1)',0,k,k));    % compute m of each cluster
        last = label;
        [~,label] = max(bsxfun(@minus,m'*X,dot(m,m,1)'/2),[],1); % assign samples to the nearest centers
        [~,~,label] = unique(label);   % remove empty clusters
    end
    label = label' ;
end