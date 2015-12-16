function I = cut_row(I, seam)
    [m, n] = size (I);
    M = true(m , n);
    M( sub2ind ([ m , n ] , seam, 1:n) ) = false ;
    I = I'; 
    I = reshape (I(M'), n, m - 1)';
end