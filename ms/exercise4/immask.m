function [I] = immask(I, M)
    if (size(I, 3) == 3)
        R = I(:,:,1);
        G = I(:,:,2);
        B = I(:,:,3);

        R = uint8(double(R) .* M);
        G = uint8(double(G) .* M);
        B = uint8(double(B) .* M);

        I = cat(3, R, G, B);
    else
        I = uint8(double(I) .* M);
    end;
end