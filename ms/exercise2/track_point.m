function [ trackX, trackY ] = track_point( frames, startX, startY, patchSize, searchSize )
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
        x1 = max(1, centerX - halfSize(searchSize));
        y1 = max(1, centerY - halfSize(searchSize));
        x2 = min(width, centerX + halfSize(searchSize) - 1);
        y2 = min(height, centerY + halfSize(searchSize) - 1);
        currentPatch = currentPatch(y1:y2, x1:x2);
        currSize = size(currentPatch)
        tt = normxcorr2(template, currentPatch); % dokumentacija
%         tt_size = size(tt);
        [x] = max(max(tt));
        [indY, indX] = find(tt == max(tt(:)), 1)
        % how to do this????
        trackX(i) = indX + x1 - size(template,1)/2;
        trackY(i) = indY + y1 - size(template,2)/2;
        % iste slike zaporedoma
    end
end

function [ret] = halfSize(index)
    if mod(index, 2) == 0
        ret = index / 2;
    else
        ret = floor(index/2);
    end
end

