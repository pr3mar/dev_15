function imThresh=threshold(im,threshold)


imThresh = (im>threshold)*255;
[ySize xSize dSize]  = size (imThresh);
imThresh = imThresh(2:ySize-1,2:xSize-1);
imThresh = round (double(imThresh)/255);
[imY imX] = size (imThresh);
imThresh(1,:) = 0;
imThresh(imY,:) = 0;
imThresh(:,1) = 0;
imThresh(:,imX) = 0;
r = imThresh;