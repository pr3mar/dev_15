function [ H ] = myhist3( img, bins )
    idx = floor(double(img) * bins / (255 + 1e-5)) + 1;
    H = zeros(bins, bins, bins);
    for i = 1:size(img, 1)
        for j = 1:size(img,2)
            R = idx(i,j,1);
            G = idx(i,j,2);
            B = idx(i,j,3);
            H(R,G,B) = H(R,G,B) + 1;
        end;
    end;
    H = H / sum(sum(sum(H)));
end
