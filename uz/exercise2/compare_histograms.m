function d = compare_histograms ( h1 , h2 , dist_name )
    switch dist_name
        case 'l2'
            d = sqrt(sum( ( h1 - h2).^2 ) );
        case 'chi2'
            d = 1/2 * (sum( ( h1 - h2).^2 / (h1 + h2 + 1e-10)));
        case 'hellinger'
            d = 1/2 * (sum(sqrt((sqrt(h1) - sqrt(h2)).^2)));
        case 'intersect'
            d = 1 - sum(min(h1, h2));
        otherwise
            error ( 'Unknown distance type ! ' ) ; % This is how you throw an exception .
    end
end