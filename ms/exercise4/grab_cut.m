function [ out ] = grab_cut( I, mask, iters, alfa, sigma )
    clc
    [h, w, c] = size(I);
    img = reshape(I, h * w, c);
    foreground = zeros(h*w, c);
    back = zeros(h*w, c);
    for i = 1:iters
        mask = reshape(mask, h*w, 1);
        for j = 1:c
            foreground(:,j) = double(img(:,j)) .* double(mask);
            back(:,j) = double(img(:,j)) .* double(~mask);
        end
        
        mean_f = mean(double(foreground)); cov_f = cov(double(foreground));
        mean_b = mean(double(back)); cov_b = cov(double(back));
        
        pxf = gaussPDF(double(img)', mean_f', cov_f);
        pxb = gaussPDF(double(img)', mean_b', cov_b);
        
        pfx = pxf ./ (pxf + pxb);
        pfx = reshape(pfx, h, w);
        pbx = 1 - pfx;
        p = cat(3, pfx, pbx);
%         figure(1); imagesc(p(:,:,1)); title('pfx');
%         figure(2); imagesc(p(:,:,2)); title('pbx');
        cost = (ones(2) - eye(2)) * alfa;
        gch = GraphCut('open', p, cost);
        [gch, L] =  GraphCut('expand', gch);
        gch = GraphCut('close', gch);
%         figure(1); imagesc(L); title('L');
        mask = (L ~= 0);
    end
%     out = mask;
%     figure(3); clf; imagesc(bwlabel(mask));
    [label, num] = bwlabel(mask);
    mask = zeros(size(mask));
    tsh = 1500;
    for i = 1:num
        tmp = sum(label(:) == i);
        if (tmp > tsh)
            mask = or(mask, (label == i));
        end
    end
    out = imgaussfilt(double(mask), sigma);
end

