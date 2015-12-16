function I = cut_col(I, seam)
    [m, n] = size (I);
    M = true(m , n);
    M( sub2ind ([ m , n ] , 1:m , seam) ) = false ;
    I = I'; 
    I = reshape (I(M'), n-1, m)';
end