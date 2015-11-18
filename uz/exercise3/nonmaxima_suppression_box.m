function [ acc ] =  nonmaxima_suppression_box( acc )
    x_off = [-1 0 1 -1 1 -1 0 1];
    y_off = [1 1 1 0 0 -1 -1 -1];
    [h, w] = size(acc);
    for i = 1:h
        for j = 1:w
            for k = 1:numel(x_off)
                x = i + x_off(k); y = j + y_off(k);
                if (0 < x && x < h) && (0 < y && y < w) && acc(i,j) < acc(x,y)
                    acc(i,j) = 0;
                    break;
                end
            end
        end
    end
end