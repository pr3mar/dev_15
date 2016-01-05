function d = distance( h1 , h2 , dist_name )
    h1 = h1(:); h2 = h2(:);
    switch dist_name
        case 'l2'
            d = sqrt(sum( ( h1 - h2).^2 ) );
        case 'chi2'
            d = 1/2 * sum((h1 - h2).^2 ./(h1 + h2 + 1e-10));
        case 'hellinger'
            d = 1/2 * (sum(sqrt((sqrt(h1) - sqrt(h2)).^2)));
        case 'intersect'
            d = 1 - sum(min(h1, h2));
        case 'h'
            d = sqrt(1/2 * (sum((sqrt(h1) - sqrt(h2)).^2 )));
        case 'ncc'
            mean_x = mean(h1); mean_y = mean(h2);
            N = numel(h1);
            d = 1/N * (sum((h1 - mean_x) .*(h2 - mean_y))) / ...
                (sqrt(1/N * (sum((h1 - mean_x).^2))) *  ...
                sqrt(1/N * (sum((h2 - mean_y).^2))) ); 
        otherwise
            error ( 'Unknown distance type ! ' ) ; % This is how you throw an exception .
    end
end