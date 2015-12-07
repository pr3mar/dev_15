A1 = [0 0 3 3; 0 0 3 3; 2 2 1 1; 2 2 1 1];
A2 = [2 2 1 1; 2 2 1 1; 0 0 3 3; 0 0 3 3];
A3 = [0 3 0 3; 3 0 3 0; 1 2 1 2; 2 1 1 2];

Ca1 = cooccurrenceMatrix(A1, [-1 2])
ener = energy(Ca1)
cont = contrast(Ca1)
corr = correlation(Ca1)