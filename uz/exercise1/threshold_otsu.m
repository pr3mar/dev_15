function ret = threshold_otsu(I)
    nbins = 256;
    p = myhist(I, nbins);
    sigma = zeros(nbins, 1);
    for t = 1 : nbins
        qlow = sum(p(1:t));
        qhigh = sum(p(t + 1: end));
        miu_L = sum(p(1:t) .* (1:t)) / qlow;
        miu_H = sum(p(t + 1: end) .* (t + 1: nbins)) / qhigh ;
        sigma(t) = qlow * qhigh * (miu_L - miu_H) ^ 2;
    end
    [~, ret] = max(sigma(:));
end

