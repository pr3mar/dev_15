function [imCont,thisY,thisX,thisCoord]=findContours(imConn,topMost2,rightMost2,leftMost2)

imCont = imConn.*0;


newTotal = length(topMost2);
xDir = [0 1 1 1 0 -1 -1 -1];
yDir = [-1 -1 0 1 1 1 0 -1];

thisY = zeros(newTotal,1000);
thisX = zeros(newTotal,1000);
thisCoord = ones(newTotal,1);

for (clusterNo = 1:newTotal)
    thisY(clusterNo,1) = topMost2(clusterNo);
    for (x = leftMost2(clusterNo):rightMost2(clusterNo))
        if (imConn(thisY(clusterNo,1),x) ==clusterNo)
            thisX(clusterNo,1) = x;          
            break;
        end;
    end;
    
    
    
    count = 0;
    dir = 5;
    while(count<1000)  
        count = count+1;
        dir = rem(dir+5,8);
        for (dirnCount=0:7)     
            if (imConn(thisY(clusterNo,thisCoord(clusterNo))+yDir(dir+1),thisX(clusterNo,thisCoord(clusterNo))+xDir(dir+1))>0)
                    break;
            else        
               dir = rem(dir+1,8);     
            end;
        end;
        thisY(clusterNo,thisCoord(clusterNo)+1) = thisY(clusterNo,thisCoord(clusterNo))+yDir(dir+1);
        thisX(clusterNo,thisCoord(clusterNo)+1) = thisX(clusterNo,thisCoord(clusterNo))+xDir(dir+1);
       
        thisCoord(clusterNo) = thisCoord(clusterNo)+1;
        if ( (thisY(clusterNo,thisCoord(clusterNo))==thisY(clusterNo,1)) & (thisX(clusterNo,thisCoord(clusterNo))==thisX(clusterNo,1)) );
                break;
        end;
    end;
    for (c1 = 1:thisCoord(clusterNo));
        imCont(thisY(clusterNo,c1),thisX(clusterNo,c1)) = clusterNo;
    end;
end;



