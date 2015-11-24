function I = gaussfilter(I, sigma)
    G = gauss(sigma);
    I = convn(convn(I, G,'same'), G', 'same');
end