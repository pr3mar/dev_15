function [allPointsX,allPointsY]= calculate_intersection(thisX3,thisY3,thisCoord3,verticesList3)

skipVal = 5;

allPointsX = [];
allPointsY = [];

clusterNo = length(thisCoord3);
for (c1 = 1:clusterNo)
    lineToVectors = [];
    lineAlongVectors = [];
    for (thisLine = 1:4)        %find vector to and vector along lines        
        firstCoord = verticesList3(c1,thisLine)+skipVal;
        secondCoord = verticesList3(c1,rem(thisLine,4)+1)-skipVal;

    
         if (firstCoord<1)
            firstCoord = firstCoord+thisCoord3(c1);
        end;
        if (secondCoord<1)
            secondCoord = secondCoord+thisCoord3(c1);
        end;
        if (firstCoord>secondCoord)
            temp = firstCoord;
            firstCoord=secondCoord;
            secondCoord = temp;
        end;

        pointOnLine = [thisX3(c1,firstCoord); thisY3(c1, firstCoord)];
        lineToVectors= [lineToVectors pointOnLine];
     
        A = [thisX3(c1,firstCoord:secondCoord); thisY3(c1,firstCoord:secondCoord)];   
        A(1,:) = A(1,:)-mean(A(1,:),2);
        A(2,:) = A(2,:)-mean(A(2,:),2);
        A = A*A';
        [U L V] = svd(A);
        lineAlongVectors = [lineAlongVectors U(:,1)];                            
    end;

    pointX = [];
    pointY = [];

    for (thisVertex = 1:4)  %find co-ordinates of where lines meet by solve equation Ml = b
        line1 = thisVertex;
        line2 = rem(thisVertex,4)+1;
        b = lineToVectors(:,line2)-lineToVectors(:,line1);
        M = [lineAlongVectors(:,line1) -1*lineAlongVectors(:,line2)];
        l = M\b;
        pointX =[pointX lineToVectors(1,line1)+l(1,1)*lineAlongVectors(1,line1)]; 
        pointY =[pointY lineToVectors(2,line1)+l(1,1)*lineAlongVectors(2,line1)];           
    end;
    allPointsX = [allPointsX; pointX];
    allPointsY = [allPointsY; pointY];
    
end;

