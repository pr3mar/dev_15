function [thisX3, thisY3, thisCoord3, verticesList3] = line_segments(thisX, thisY, thisCoord, area, cornerThresh)
global cornerThresh2;
cornerThresh2 = cornerThresh;

[newTotal, ~] =size(thisX);

verticesList3 = [];
thisX3 = [];
thisY3= [];
thisCoord3 = [];
for clusterNo = 1:newTotal
    
%     [x , y ,v1] = findTwoMostDistantPoints( thisX(clusterNo,1:thisCoord(clusterNo)-1), thisY(clusterNo,1:thisCoord(clusterNo)-1) ) ;
%     thisX(clusterNo,1:thisCoord(clusterNo)-1) = x ;
%     thisY(clusterNo,1:thisCoord(clusterNo)-1) = y ;
     
    dMax = 0;
    for c1 = 1:thisCoord(clusterNo)-1
        dist = sqrt( (thisX(clusterNo,c1)-thisX(clusterNo,1))^2+(thisY(clusterNo,c1)-thisY(clusterNo,1))^2);
        if (dist>dMax) 
            dMax = dist;
            v1 = c1;
        end;    
    end;   

    xCopy = thisX(clusterNo,1:v1);
    yCopy = thisY(clusterNo,1:v1);

    thisX(clusterNo,1:thisCoord(clusterNo)-v1) = thisX(clusterNo,v1+1:thisCoord(clusterNo));
    thisY(clusterNo,1:thisCoord(clusterNo)-v1) = thisY(clusterNo,v1+1:thisCoord(clusterNo));
    thisX(clusterNo,thisCoord(clusterNo)-v1+1:thisCoord(clusterNo)) = xCopy;
    thisY(clusterNo,thisCoord(clusterNo)-v1+1:thisCoord(clusterNo)) = yCopy;
    thisX(clusterNo,thisCoord(clusterNo)) = thisX(clusterNo,1);
    thisY(clusterNo,thisCoord(clusterNo)) = thisY(clusterNo,1);

    dMax = 0;
    for (c1 = 1:thisCoord(clusterNo)-1)
        dist = sqrt( (thisX(clusterNo,c1)-thisX(clusterNo,1))^2+(thisY(clusterNo,c1)-thisY(clusterNo,1))^2);
        if (dist>dMax) 
            dMax = dist;
            v1 = c1;
        end;    
    end;   

    [r, vertices] = GetVertices(thisX(clusterNo,:), thisY(clusterNo,:),v1,area(clusterNo),thisCoord(clusterNo));
    if length(vertices) == 4
        verticesList3 = [verticesList3; vertices'];         
        thisX3 = [thisX3;thisX(clusterNo,:)];
        thisY3 = [thisY3;thisY(clusterNo,:)];
        thisCoord3 = [thisCoord3 thisCoord(clusterNo)];
    end;
end;
if (isempty(verticesList3))
    disp('#######################');
    disp(' Error!');
    disp('#######################');
    disp('');
    disp('Could not find an object with 4 vertices');
    disp('Reasons may include:');
    disp('  1.    No marker is present');
    disp('  2.    Luminance threshold set inappropriately');
    disp('  3.    Corner Detection Threshold set inappropriately');
    disp(' ');
end;




function [r,vertices] = GetVertices(thisX, thisY,v1,area, chainLength)
global cornerThresh2;

thresh = cornerThresh2;
%thresh = (area/0.75)*0.01*0.1;
vertices = zeros(2,1);
vertices(1) = 1;
number1 = 2;

vertices1 = zeros(1,1);
number1 = 0;
%disp('First half search');
[r vertices1 number1] = getVertex(thisX,thisY,1,v1,thresh,vertices1,number1);
if ( r<0)
 %   disp('Failed to find vertex');
end;

vertices2 = zeros(1,1);
number2 = 0;

%disp('Second half search');
[r vertices2 number2] = getVertex(thisX,thisY,v1,chainLength-1,thresh,vertices2,number2);
if (r <0)
    %disp('Failed to find vertex');
end;

if (( number1==1) && (number2==1))
    %disp('Case 1:  Found one vertex in both halves');
    vertices(2) = vertices1(1);
    vertices(3) = v1;
    vertices(4) = vertices2(1);
elseif((number1>1) && (number2==0))
    %disp('Case 1:  Found more than one vertex in first half, but none in second');    
    v2 = round(v1/2);
    number1 = 0;
    number2 = 0;
    [r, vertices1, number1] = getVertex(thisX,thisY,1,v2,thresh,vertices1,number1);
    if ( r<0)
     %   disp('Failed to find vertex');
    end;
    [r, vertices2, number2] = getVertex(thisX,thisY,v2,v1,thresh,vertices1,number1);
    if ( r<0)
     %   disp('Failed to find vertex');
    end;
    if ((number1==1) && (number2==1))
        vertices(2)=  vertices1(1);
        vertices(3) = vertices2(1);
        vertices(4) = v1;
    else
     %   disp('Too many vertices');
    end;
elseif((number1==0) && (number2>1))
    %disp('Case 1:  Found more than one vertex in first half, but none in second');    
    v2 = round((v1+chainLength)/2);
    number1 = 0;
    number2 = 0;
    
    [r, vertices1, number1] = getVertex(thisX,thisY,v1,v2,thresh,vertices1,number1);
    if ( r<0)
      %  disp('Failed to find vertex');
    end;
 
    [r, vertices2, number2] = getVertex(thisX,thisY,v2,chainLength,thresh,vertices1,number1);
    if ( r<0)
      %  disp('Failed to find vertex');
    end;
    if ((number1==1) && (number2==1))
        vertices(2)=  v1;
        vertices(3) = vertices1(1);
        vertices(4) = vertices2(1);
    else
     %   disp('Too many vertices');
    end;
end;
if (r>=0)
 %   vertices
else
    %disp('Something wrong with vertex finding...');
end;


function [r,vertices,number]= getVertex(xVals, yVals,st,ed,thresh, vertices,number)
%disp(sprintf('Entering Routine: Searching Between %d and %d',st,ed));
%vertices
%number


% a = yVals(ed) - yVals(st);
% b = xVals(st) - xVals(ed);
% c = xVals(ed)*yVals(st) -yVals(ed)*xVals(st);
% 
% dmax = 0;
% for (i = st+1:ed-1)
%     dist = (a*xVals(i)+b*yVals(i)+c)/sqrt(a^2+b^2);
%     if ((dist)>dmax)
%         dmax=dist;
%         v1 = i;
%     end;
% end;

v = [xVals(ed);yVals(ed);0] - [xVals(st);yVals(st);0]  ;


dmax = 0;
for i = st+1:ed-1
    w = [xVals(i);yVals(i);0] - [xVals(st);yVals(st);0]  ;
    dist = norm(cross(v,w))/norm(v) ;
    if ((dist)>dmax)
        dmax=dist;
        v1 = i;
    end;
end;


if (dmax>thresh) %((dmax/(a*a+b*b))>thresh)
  %  disp(sprintf ('Distance, %f greater than thresh, %f',dmax/(a*a+b*b),thresh));
    [r, vertices, number] = getVertex(xVals,yVals,st,v1,thresh,vertices,number);
    if(r<0)
   %     disp(sprintf('Did not find 2nd Exiting'));
        r=-1;return;
    end;
    if (number>5) 
   %     disp(sprintf('More than 5 vertices found - exiting'));
        r=-1;return;
    end;
    number = number+1;
    vertices(number) = v1;
   % disp(sprintf('Adding Vertex number %d,  position %d',v1,number));
    
    [r, vertices, number] = getVertex(xVals,yVals,v1,ed,thresh,vertices,number);
    if (r<0)
   %     disp(sprintf('Did not find 3rd Exiting'));
        r=-1;return;
    end;
else
   % disp(sprintf ('Distance, %f not greater than thresh, %f',dmax/(a*a+b*b),thresh));
    
end
%disp('Exiting from routine');
%vertices
%number
r=0;
return;


