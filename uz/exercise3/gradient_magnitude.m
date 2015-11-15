function [ Imag, Ideg ] = gradient_magnitude( I, sigma )
    [Ix, Iy] = image_derivatives(I, sigma);
    Imag = sqrt(Ix.^2 + Iy.^2);
    Ideg = atan2(Iy,Ix);
end

