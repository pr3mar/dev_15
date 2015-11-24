function [ acc ] =  nonmaxima_suppression_box( acc )
    x_off = [-1 0 1 -1 1 -1 0 1];
    y_off = [1 1 1 0 0 -1 -1 -1];
    [h, w] = size(acc);
%     for i = 1:h
%         for j = 1:w
%             for k = 1:numel(x_off)
%                 x = i + x_off(k); y = j + y_off(k);
%                 if (0 < x && x < h) && (0 < y && y < w) && acc(i,j) < acc(x,y)
%                     acc(i,j) = 0;
%                     break;
%                 end
%             end
%         end
%     end
    [edge_y, edge_x] = find(acc > 0);
    for i = 1:numel(edge_y)
%         if (0 < edge_y(i)-1 && edge_y(i)+1 < h) && ...
%                 (0 < edge_x(i)-1 && edge_x(i)+1 < w)
%             minim = acc(edge_y(i)-1:edge_y(i)+1, edge_x(i)-1:edge_x(i)+1);
%             acc(edge_y(i)-1:edge_y(i)+1, edge_x(i)-1:edge_x(i)+1) = ordfilt2(minim, 9 , ones(3,3));
%         end
        for k = 1:numel(x_off)
            x = edge_x(i) + x_off(k); y = edge_y(k) + y_off(k);
            if (0 < x && x < h) && (0 < y && y < w) && acc(edge_y(i), edge_x(i)) < acc(x,y)
                acc(edge_y(i), edge_x(i)) = 0;
                break;
            end
        end
    end
end