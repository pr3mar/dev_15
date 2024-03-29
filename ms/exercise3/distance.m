function [ dist ] = distance( x, y, name)
    switch name
        case 'h'
            dist = 1 - sqrt(1/2 * (sum((sqrt(x) - sqrt(y)).^2 )));
        case 'ncc'
            mean_x = mean(x); mean_y = mean(y);
            N = numel(x);
            dist = 1/N * (sum((x - mean_x) .*(y - mean_y))) / ...
                (sqrt(1/N * (sum((x - mean_x).^2))) *  ...
                sqrt(1/N * (sum((y - mean_y).^2))) ); 
        otherwise
            error('unknown type')
    end
end

