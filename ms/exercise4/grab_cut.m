function [ img ] = grab_cut( I, mask )
    [h, w, c] = size(I);
    img = reshape(I, h * w,c);
    mask = reshape(mask, h * w, 1);
    back = double(img(~mask,:));
    frg = double(img(mask,:));
%     size(back), size(frg)
    mean_b = mean(back); cov_b = cov(back);
    mean_f = mean(frg); cov_f = cov(frg);
    gaussPDF(back, mean_b, cov_b)
end

