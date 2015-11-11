function [ trackX, trackY ] = track_point( frames, startX, startY, patchSize, searchSize )
    [h, w, ~, n] = size(frames);
    image = rgb2gray(frames(:,:,:,1));
    x1 = max(1, startX - patchSize/2);
    y1 = max(1, startY - patchSize/2);
    x2 = min(w, startX + patchSize/2 - 1);
    y2 = min(h, startY + patchSize/2 - 1);
    
    patch = image(y1:y2,x1:x2);
    
    trackX = zeros(1, n); trackX(1) = startX;
    trackY = zeros(1, n); trackY(1) = startY;
    
    for i = 2:n
        x1 = max(1, startX - searchSize/2);
        y1 = max(1, startY - searchSize/2);
        x2 = min(w, startX + searchSize/2 - 1);
        y2 = min(h, startY + searchSize/2 - 1);
        region = rgb2gray(frames(y1:y2,x1:x2,:,i));
        norcorr = normxcorr2(patch, region);
        [~, maxInd] = max(norcorr(:));
        [indY, indX] = ind2sub(size(norcorr), maxInd);
        trackY(i) = indY - size(patch, 1)/2 + y1;
        trackX(i) = indX - size(patch, 2)/2 + x1;
    end
end
