function [ filtered ] = median2d( img, filter_size )
    % O(n^3logn)
    % O(n^2), qsort is always performing on 9 elements -> constant time?
    offset = floor(filter_size/2);    
    filtered = zeros(size(img));
%     tmp_img = zeros(size(img) + 2 * offset);
%     tmp_img(offset + 1:size(tmp_img,1) - offset, offset + 1:size(tmp_img,2) - offset) = img(:,:);
%     filtered = tmp_img;
    
    for i = 1+offset:size(img,1) - 1
        for j = 1+offset:size(img,2) - 1
            tmp = img(i - offset:i + offset, j - offset:j+offset);
            tmp = sort(tmp(:));
            filtered(i,j) = tmp(floor(length(tmp)/2));
%             filtered(i,j)
%             break
        end
%         break;
    end
%     filtered = filtered(filter_size + 1: size(filtered,1) - filter_size, filter_size + 1: size(filtered,2) - filter_size);
end

