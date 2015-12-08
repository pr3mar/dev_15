function [Ca, vector ] = getDot( A, d)
    Ca = cooccurrenceMatrix(A, d);
    vector = [energy(Ca), contrast(Ca), correlation(Ca), homogeneity(Ca) ];
end

