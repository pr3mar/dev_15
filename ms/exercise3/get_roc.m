function [ R, auc, f, point] = get_roc( scores, groundworth )
    [scores, indices] = sort(scores,'descend');
    R = zeros(length(scores) + 1, 2)';
    auc = 0;
    fprev = -Inf;
    TP = 0; FP = 0; TPp = 0; FPp = 0; 
    p = length(groundworth(groundworth > 0)); n = length(groundworth) - p;
    point = [1.0 0.0]; minDist = 1000;
    for i = 1:length(groundworth)
        if fprev ~= scores(i)
            auc = auc + trapezoid_area(FP, FPp, TP, TPp);
            R(1,i) = TP/p;
            R(2,i) = FP/n;
            fprev = scores(i);
            TPp = TP;
            FPp = FP;
        end
        if groundworth(indices(i)) > 0
            TP = TP + 1;
        else
            FP = FP + 1;
        end
         dist = sqrt(sum([1 0] - [R(2,i) R(1,i)]) .^ 2);
        if dist < minDist
            point(1) = R(2,i); point(2) = R(1,i);
            precision = TP/(TP + FP);
            recall = TP/p;
            minDist = dist;
        end
    end
    R(1,i+1) = TP/p;
    R(2,i+1) = FP/n;
    auc = auc + trapezoid_area(FP, FPp, TP, TPp);
    auc = auc/(p * n);
    f = 2/(1/precision + 1/recall);
end

function area = trapezoid_area(X1, X2, Y1, Y2)
    base = abs(X1 - X2);
    height_avg = (Y1 + Y2)/2;
    area = base * height_avg;
end