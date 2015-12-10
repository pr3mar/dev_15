function [ img ] = grab_cut_old( I, mask, iters )
    [h, w, c] = size(I);
    img = reshape(I, h * w,c);
    back = zeros(h * w, c);
    frg = zeros(h * w, c);
%     I = reshape(I, h*w, 3);
    for k = 1:iters
        mask = reshape(mask, h * w, 1);
%         S = reshape(S, h*w, 1);
%         A(:,1) = double(I(:,1)) .* double(~S);
%         A(:,2) = double(I(:,2)) .* double(~S);
%         A(:,3) = double(I(:,3)) .* double(~S);
% 
%         %background
%         B(:,1) = double(I(:,1)) .* double(S);
%         B(:,2) = double(I(:,2)) .* double(S);
%         B(:,3) = double(I(:,3)) .* double(S);
% 
%         mA = mean(A);
%         mB = mean(B);
% 
%         covA = cov(A);
%         covB = cov(B);
% 
%         pxf = gaussPDF(A', mA', covA);
%         pxb = gaussPDF(B', mB', covB);
% 
%         pfx = pxf ./ (pxf + pxb);
%         pfx = reshape(pfx,h,w); 
%         pbx = 1 - pfx;
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
        f = reshape(p, h, w, 1);
        b = 1 - f;
        p = cat(3, b, f);
%         p(:,:,1) = 1 - p(:,:,1);
%         p(:,:,2) = 1 - p(:,:,1);
%         p = cat(3, pfx, pbx);
        cost = (ones(2) - eye(2))*0.001;
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