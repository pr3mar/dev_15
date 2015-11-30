function [ acc_ ] =  nonmaxima_suppression_box( acc, threshold, box )
    [h, w] = size(acc);
    [edge_y, edge_x] = find(acc > threshold);
    acc_ = zeros(h, w);
    for i = 1:numel(edge_y)
        startX = edge_x(i) - box; startY = edge_y(i) - box;
        endX = edge_x(i) + box; endY = edge_y(i) + box;
        startX = max(startX, 1); startY= max(startY, 1);
        endX = min(endX, w); endY = min(endY, h);
        tmp = acc(startY:endY, startX:endX);
        max_ = max(tmp(:));
        [tmp_y, tmp_x] = find(tmp == max_);
        if isscalar(tmp_y) && (tmp(tmp_y, tmp_x) == acc(edge_y(i), edge_x(i)))
            acc_(edge_y(i), edge_x(i)) = acc(edge_y(i), edge_x(i));
        end
    end
end



% function [ acc_ ] =  nonmaxima_suppression_box( acc, threshold, box )
%     x_off = [-1 0 1 -1 1 -1 0 1];
%     y_off = [1 1 1 0 0 -1 -1 -1];
%     [h, w] = size(acc);
%     [edge_y, edge_x] = find(acc > threshold);
%     acc_ = zeros(h, w);
%     %TODO: make a box of BOX x BOX pixels
%     % 1px (9x9) is very small box
%     for i = 1:numel(edge_y)
%         set = true;
%         for j = 1:numel(x_off)
%             y = edge_y(i) + y_off(j); 
%             x = edge_x(i) + x_off(j);
%             if (0 < x) && (x < w) && ...
%                     (0 < y) && (y < h) && ...
%                         (acc(edge_y(j), edge_x(j)) < acc(y, x))
%                 set = false;
%                 break;
%             end
%         end
%         if (set == true)
%             acc_(edge_y(i), edge_x(i)) = acc(edge_y(i), edge_x(i));
%         end
%     end
% end