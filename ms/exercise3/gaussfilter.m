function I = gaussfilter(I, sigma)

G = gauss(sigma);
I = conv2(conv2(I, G,'same'), G', 'same');