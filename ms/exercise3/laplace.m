function Il = laplace(I)
L = [1, -2, 1];
Ixx = conv2(I, L, 'same');
Iyy = conv2(I, L', 'same');
Il = Ixx + Iyy;
end