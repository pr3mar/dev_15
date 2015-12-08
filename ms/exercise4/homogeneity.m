function [ hom ] = homogeneity( img )
    [h, w] = size(img);
    hom = 0;
    for j = 1:h
        for i = 1:w
            hom = hom + img(i,j)/(1 + abs(i - j));
        end
    end
end

