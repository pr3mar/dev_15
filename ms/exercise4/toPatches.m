function [ patches ] = toPatches( I, R )
    patches = 0;
    [h, w] = size(I);
    ncol = floor(w/R);
    nrow = floor(h/R);
    [nrow, ncol, nrow * ncol, (h * w)/(nrow * ncol)];
    patches = zeros(R, R, nrow * ncol);
%     size(patches)
    count = 1;
    maxRow = -1;
    maxCol = -1;
    for i = 1:nrow
        if (i * R > h) && (maxRow ~= -1)
            maxRow = nrow - 1;
        end
        if maxRow ~= -1
            row = maxRow;
        else
            row = nrow;
        end
        for j = 1:ncol
            if (j * R > w) && (maxCol ~= -1)
                maxCol = nrow - 1;
            end
            if maxCol ~= -1
                col = maxCol;
            else
                col = ncol;
            end
            if maxCol ~= -1 && maxRow ~= -1
                break;
            end
            patches(:, :, count) = I( ((i - 1) * R + 1) :  ( i * R ), ((j - 1) * R + 1) :  (j * R ));
            count = count + 1;
        end
        if maxCol ~= -1 && maxRow ~= -1
            break;
        end
    end
    
    figure(1); colormap gray;
    for i = 1:(count - 1)
        subplot(nrow,ncol,i);
        imshow(uint8(patches(:,:,i))); axis equal; axis tight;
    end
end

