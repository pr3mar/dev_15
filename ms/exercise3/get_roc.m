function [ R, auc, tsh, f, point] = get_roc( scores, groundworth )
    [scores, indices] = sort(scores,'descend');
    R = zeros(length(scores) + 1, 2)';
    auc = 0;
    fprev = -Inf;
    TP = 0; FP = 0; TPp = 0; FPp = 0; 
    p = length(groundworth(groundworth > 0)); n = length(groundworth) - p;
    point = [0.0 0.0]; minDist = 1000; tsh = 0;
    counter = 1;
    for i = 1:length(groundworth)
        if fprev ~= scores(i)
            auc = auc + trapezoid_area(FP, FPp, TP, TPp);
            R(1,counter) = TP/p;
            R(2,counter) = FP/n;
            fprev = scores(i);
            TPp = TP;
            FPp = FP;
            counter = counter + 1;
        end
        if groundworth(indices(i)) > 0
            TP = TP + 1;
        else
            FP = FP + 1;
        end
%         dist = sqrt(sum([1 0] - [R(2,i) R(1,i)]) .^ 2);
        dist = sqrt(sum(([0 1] - [R(2,counter - 1) R(1,counter - 1)]) .^ 2));
%         R(2,i), R(1,i), dist
        if dist < minDist
            tsh = scores(counter - 1);
            point(1) = R(2,counter - 1); point(2) = R(1,counter - 1);
            minDist = dist;
        end
    end
    R(1,counter) = TP/p;
    R(2,counter) = FP/n;
    R = R(:,1:counter);
    auc = auc + trapezoid_area(FP, FPp, TP, TPp);
    auc = auc/(p * n);
    
    apply_tsh = scores >= tsh;
    TP = 0; FP = 0;
    for i = 1:numel(apply_tsh)
        if apply_tsh(i) == 1 && apply_tsh(i) == groundworth(i)
            TP = TP + 1;
        elseif apply_tsh(i) == 0 && apply_tsh(i) == groundworth(i)
            FP = FP + 1;
        end
    end
    p = length(apply_tsh(scores >= tsh)); n = length(apply_tsh) - p;
    precision = TP/(TP + FP);
    recall = TP/p;
    f = 2*(precision * recall)/(precision + recall);
end

function area = trapezoid_area(X1, X2, Y1, Y2)
    base = abs(X1 - X2);
    height_avg = (Y1 + Y2)/2;
    area = base * height_avg;
end