function h = myhistRGB( I, nbins )
I = double(I) ;
[W,H,d] = size(I) ;  

I = round((nbins-1)*(I/255)) ;

I_r = reshape(I(:,:,1),1,W*H);
I_g = reshape(I(:,:,2),1,W*H);
I_b = reshape(I(:,:,3),1,W*H);
h = zeros(nbins,nbins,nbins) ;
for i_r = 0 : nbins-1
    for i_g = 0 : nbins-1
        for i_b = 0 : nbins-1
            s = sum((I_r == i_r).*(I_g == i_g).*(I_b == i_b)) ;
            h(i_r+1, i_g+1, i_b+1) = s ;             
        end
    end
end
h = h(:) ;
h = h / sum(h) ;
