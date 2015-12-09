function [ img ] = grab_cut( I, mask, iters )
    [h, w, c] = size(I);
    img = reshape(I, h * w,c);
    back = zeros(h * w, c);
    frg = zeros(h * w, c);
    for k = 1:iters
        mask = reshape(mask, h * w, 1);
        for i = 1:c
%             size(back(:,i)), size(img(:,i)), size(mask)
            back(:,i) = double(img(:,i)) .* double(~mask);
            frg(:,i) = double(img(:,i)) .* double(mask);
        end
        mean_b = mean(back); cov_b = cov(back);
        mean_f = mean(frg); cov_f = cov(frg);
        prob_b = gaussPDF(back', mean_b', cov_b);
        prob_f = gaussPDF(frg', mean_f', cov_f);
        p = prob_f ./ (prob_f + prob_b);
        p = reshape(p, h, w, 1);
        p(:,:,2) = 1 - p(:,:,1);
        
        cost = (ones(2) - eye(2))*2;
        gch = GraphCut('open', p, cost);
        [gch, L] = GraphCut('expand', gch);
        gch = GraphCut('close', gch);
        mask = L ~= 0;
    end
    
    img = mask;
end


%     figure(1);clf;imagesc(uint8(back));
%     figure(2);clf;imagesc(uint8(frg));

%     back = reshape(back, h*w, c);
%     frg = reshape(frg, h*w, c);
%     mask = reshape(mask, h*w,1);