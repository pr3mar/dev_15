function [orientation,identity,vertex_order] = match_orientation(im,templates,allPointsX, allPointsY)
%cross correlates with stored version

[noTemplates, ~] = size(templates);
[noSquares, ~]=size(allPointsX);

allOrientations = zeros(noSquares,noTemplates);
allCorrelations = zeros(noSquares,noTemplates);
orientation = zeros(noSquares,1);
identity = zeros(noSquares,1);
correlation =zeros(4,1);

[yImageSize, xImageSize] = size(im);

for square = 1:noSquares
    A1 = [0 100 0; 0 0 100; -1 1 1];
    pointX = allPointsX(square,:);
    pointY = allPointsY(square,:);
    A2 = [pointX(1) pointX(2) pointX(4); pointY(1) pointY(2) pointY(4); 1 1 1];
    B2 = [pointX(3) ;pointY(3); 1];
    UVW = inv(A2)*B2;
    A2 = A2.*kron(ones(3,1),UVW');
    M = A2*inv(A1);

    toMatch = zeros(100,100);
    for (xCount = 1:100) 
        for (yCount = 1:100)
            V = M*[xCount;yCount;1];
            roundV1V3 = round(V(1)/V(3));
            roundV2V3 = round(V(2)/V(3));
            
            if (roundV2V3<1)
                roundV2V3 = 1;
            end;
            if (roundV1V3<1)
                roundV1V3 = 1;
            end;
            if (roundV1V3>xImageSize)
                roundV1V3 = xImageSize;
            end;
            if (roundV2V3>yImageSize)
                roundV2V3 = yImageSize;
            end;
            
            

            toMatch(yCount,xCount) =im(roundV2V3,roundV1V3); 
        end;
    end;
    toMatch= reshape(toMatch,1,100*100);
    toMatch = toMatch - mean(toMatch');
    toMatch = toMatch / std(toMatch');
    for templateC = 1:noTemplates;
        template = templates(templateC,:);
        template = template-mean(template');
        template = template/std(template');
        correlation(1,1) = sum(toMatch.*template,2);
        toMatch = reshape(fliplr(reshape(toMatch,100,100)'),1,100*100);
        correlation(2,1) = sum(toMatch.*template,2);
        toMatch = reshape(fliplr(reshape(toMatch,100,100)'),1,100*100);
        correlation(3,1) = sum(toMatch.*template,2);
        toMatch = reshape(fliplr(reshape(toMatch,100,100)'),1,100*100);
        correlation(4,1) = sum(toMatch.*template,2);
        [thisCorr thisOr] = max(correlation);
        allOrientations(square,templateC) = thisOr;
        allCorrelations(square,templateC) = thisCorr;
    end;
end;
allCorrelations = allCorrelations / length(toMatch) ;


%Now decide which is which...


[maxCols, colPosn] = max(allCorrelations,[],1);
[maximumValue, templateNo] = max(maxCols');
while(maximumValue>0)  
    squareNo = colPosn(templateNo);
    orientation(squareNo) = allOrientations(squareNo, templateNo);
    identity (squareNo) = templateNo;
    allCorrelations(:,templateNo) = 0;
    allCorrelations(squareNo,:) = 0;
    [maxCols colPosn] = max(allCorrelations,[],1);
    [maximumValue templateNo] = max(maxCols');
end;
 
orientation_chains = [1 2 3 4;...
                      4 1 2 3;...
                      3 4 1 2;...
                      2 3 4 1] ;
vertex_order = zeros(length(orientation),4) ;
for i = 1 : length(orientation)        
    if orientation(i)>0
        vertex_order(i,:) = orientation_chains(orientation(i),:) ;
    end
end


  
