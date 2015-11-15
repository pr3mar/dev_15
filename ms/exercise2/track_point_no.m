function [ trackX, trackY ] = track_point_no( frames, startX, startY, patchSize, searchSize )
    [height, width, ~, n] = size(frames);
    img = rgb2gray( frames(:,:,:,1) );
    x1 = max(1, startX - halfSize(patchSize));
    y1 = max(1, startY - halfSize(patchSize));
    x2 = min(width, startX + halfSize(patchSize) - 1);
    y2 = min(height, startY + halfSize(patchSize) - 1);
    
    template = img(y1:y2, x1:x2);
%     tempSize = size(template);
    trackX = zeros(1, n); trackX(1) = startX;
    trackY = zeros(1, n); trackY(1) = startY;
    
    for i = 2:n
        centerX = trackX(i - 1); centerY = trackY(i - 1);
        currentPatch = rgb2gray(frames(:,:,:,i));
        x1 = max(1, centerX - halfSize(searchSize))
        y1 = max(1, centerY - halfSize(searchSize))
        x2 = min(width, centerX + halfSize(searchSize) - 1)
        y2 = min(height, centerY + halfSize(searchSize) - 1)
        currentPatch = currentPatch(y1:y2, x1:x2);
        currSize = size(currentPatch)
        tt = normxcorr2(template, currentPatch); % dokumentacija
%         tt_size = size(tt);
        [~, ind] = max(max(tt));
        [indX, indY] = ind2sub(size(tt),ind);
        % how to do this????
        trackX(i) = indX - size(template,1) + x1;
        trackY(i) = indY - size(template,2) + y1;
        % iste slike zaporedoma
        if( i == 3)
            break
        end
    end
end

function [ret] = halfSize(index)
    if mod(index, 2) == 0
        ret = index / 2;
    else
        ret = floor(index/2);
    end
end

