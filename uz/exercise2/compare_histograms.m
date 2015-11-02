function d = compare_histograms ( h1 , h2 , dist_name )
    switch dist_name
        case ' l2 '
            % TODO: d = . . .
        case ' chi2 '
            % TODO: d = . . .
        case ' hellinger '
            % TODO: d = . . .
        case ' intersect '
            % TODO: d = . . .
        otherwise
            error ( 'Unknown distance type ! ' ) ; % This is how you throw an exception .
    end
end