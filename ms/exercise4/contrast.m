function [ cont ] = contrast( A )
    [i,j] = find(A);
    cont = sum( ((i-j) .^ 2) .* nonzeros(A(:)));
end

