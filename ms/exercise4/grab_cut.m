function [ img ] = grab_cut( I, mask )
    [h, w, c] = size(I);
    img = reshape(I, h * w,c);
    size(img)
end

