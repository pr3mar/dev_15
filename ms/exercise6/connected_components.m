function [imConn,area,x,y,l,r,t,b] = connected_components(im, areaMin)

[imY, imX] = size(im);

maxRegions = 50;                            %maximum number of regions it can possibly find.

im(1,:)=1;im(imY,:)=1;im(:,1)=1;im(:,imX)=1;
[im noRegions] = bwlabel((im==0),8);
freqHist = hist(reshape(im,imY*imX,1),[-0.5:1:noRegions+0.5]);
freqHist = freqHist(2:length(freqHist));
toKeep = find(freqHist > areaMin);
noRegions = length(toKeep);

area = zeros(1,noRegions);
x = zeros(1,noRegions);
y = zeros(1,noRegions);
l = zeros(1,noRegions);
r = zeros(1,noRegions);
t = zeros(1,noRegions);
b = zeros(1,noRegions);

imConn = zeros(imY,imX);
posn = 1;
for (c1=toKeep)
    [row col] = find(im==c1);
    area(posn) = length(row);
    x(posn) = mean(col);
    y(posn) = mean(row);
    l(posn) = min(col);
    r(posn) = max(col);
    t(posn) = min(row);
    b(posn) = max(row);
    imConn((col-1)*imY+row) = posn;
    posn = posn+1;
end;

