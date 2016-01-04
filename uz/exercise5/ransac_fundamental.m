function [ MF, me1, me2, maxX1, maxX2 ] = ransac_fundamental( x1, x2, eps, k)
    [~, length] = size(x1);
    maxInliers = 0;
    maxX1 = 0; maxX2 = 0; me1 = 0; me2 = 0; MF = 0;
    for i = 1:k
        rnd = randperm(length, 8);
        [F, e1, e2] = fundamental_matrix( x1(:,rnd), x2(:,rnd));
        
        [x1in, x2in] = get_inliers(F, x1, x2, eps);
        [~, inLen] = size(x1in);
        if(inLen > maxInliers)
            maxInliers = inLen;
            maxX1 = x1in; me1 = e1;
            maxX2 = x2in; me2 = e2;
            MF = F;
        end
    end
end

