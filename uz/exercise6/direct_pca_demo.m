function direct_pca_demo()
 
    figure(1); clf;
    P = load('points.txt') ;
    subplot(1,2,1);
    plot(P(1,:),P(2,:),'b+'); hold on;
    for i = 1 : size(P,2)
       text( P(1,i)-0.5, P(2,i), num2str(i)); 
    end
    xlabel('x_1'); ylabel('x_2');
    xlim([-10 10]);
    ylim([-10 10]);
    
    % (a)
    mu = mean(P, 2);
    Pn = bsxfun(@minus, P, mu);
    N = size(P, 2);
    C = Pn * Pn' * (1/(N - 1));
    [U, S, V] = svd(C);
    
    U
    
    % project to PCA space: y = U' * (xq - mu)
    % project to original space: xq = U' * y + mu
    
    % (b)
    draw_gauss2d(mu, C, 'r', 1);
    vec1 = U(:, 1) * S(1, 1) + mu;
    vec2 = U(:, 2) * S(2, 2) + mu;
    plot([mu(1), vec1(1)], [mu(2), vec1(2)], 'g');
    plot([mu(1), vec2(1)], [mu(2), vec2(2)], 'r');
    
    % (d)
    proj = U' * bsxfun(@minus, P, mu);
    proj_back = bsxfun(@plus, U * proj, mu);
    Up = U; Up(:,2) = 0;
    proj_back_1 = bsxfun(@plus, Up * proj, mu);
    
    draw_reconstructions(proj_back, proj_back_1);
    % projected onto a line
    
    % (e)
    q = [3; 6];
    qn = U' * (q - mu);
    qp = bsxfun(@plus, Up' * qn, mu);
    plot(q(1), q(2), 'x');
    plot(qp(1), qp(2), 'x');
    
    
    minDist = realmax; minDistVector = [0, 0];
    minDistP = realmax; minDistVectorP = [0, 0];
    for i = 1:size(P,2)
        dist = norm(q - P(:,i));
        if dist < minDist
            minDist = dist;
            minDistVector = P(:,i);
        end
        distP = norm(qp - Pn(:,i));
        if distP < minDistP
            minDistP = distP;
            minDistVectorP = Pn(:,i);
        end
    end
%     minDist, minDistVector
    plot(minDistVector(1), minDistVector(2), 'or');
%     minDistP, minDistVectorP
    plot(minDistVectorP(1), minDistVectorP(2), 'or');
    
    % (c)
    cumulative_sum = cumsum(diag(S));
    cumulative_sum = cumulative_sum ./ max(cumulative_sum(:));
    
    subplot(1,2,2);
    plot(cumulative_sum);
    
end
