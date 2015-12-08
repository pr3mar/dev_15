function [ patches ] = toPatches( I, R )
    patches = 0;
    [h, w] = size(I);
    ncol = floor(w/R);
    nrow = floor(h/R);
    [nrow, ncol, nrow * ncol, (h * w)/(nrow * ncol)];
    patches = zeros(nrow, ncol, R^2);
%     size(patches)
    count = 1;
    maxRow = -1;
    maxCol = -1;
%     tic
    for i = 1:R
        if (i * nrow > h) && (maxRow ~= -1)
            maxRow = nrow - 1;
        end
        if maxRow ~= -1
            row = maxRow;
        else
            row = nrow;
        end
        for j = 1:R
            if (j * ncol > w) && (maxCol ~= -1)
                maxCol = ncol - 1;
            end
            if maxCol ~= -1
                col = maxCol;
            else
                col = ncol;
            end
            if maxCol ~= -1 && maxRow ~= -1
                break;
            end
            patches(:, :, count) = I( ((i - 1) * nrow + 1) :  ( i * nrow ), ((j - 1) * ncol + 1) :  (j * ncol ));
            count = count + 1;
        end
        if maxCol ~= -1 && maxRow ~= -1
            break;
        end
    end
%     toc
%     tic
%     figure(1); colormap gray;
%     for i = 1:(count - 1)
%         subplot(R,R,i);
%         imshow(uint8(patches(:,:,i))); axis equal; axis tight;
%     end
%     toc
end

