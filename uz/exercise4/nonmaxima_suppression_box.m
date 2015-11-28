function [ acc_ ] =  nonmaxima_suppression_box( acc, threshold )
    x_off = [-1 0 1 -1 1 -1 0 1];
    y_off = [1 1 1 0 0 -1 -1 -1];
    [h, w] = size(acc);
    [edge_y, edge_x] = find(acc > threshold);
    acc_ = zeros(h, w);
    for i = 1:numel(edge_y)
        set = true;
        if(acc(edge_y(i), edge_x(i)) <= threshold)
            continue;
        end;
        for k = 1:numel(x_off)
            x = edge_x(i) + x_off(k); y = edge_y(k) + y_off(k);
            if (0 < x && x < h) && (0 < y && y < w) && ...
                    acc_(edge_y(i), edge_x(i)) < acc_(x,y)
                set = false;
                break;
            end
        end
        if (set == true)
            acc_(edge_y(i), edge_x(i)) = acc(edge_y(i), edge_x(i));
        end
    end
end